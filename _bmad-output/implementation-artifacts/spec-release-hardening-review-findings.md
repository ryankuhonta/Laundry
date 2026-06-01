---
title: 'Release Hardening Review Findings'
type: 'bugfix'
created: '2026-05-31'
status: 'done'
baseline_commit: 'NO_VCS'
context:
  - '{project-root}/docs/functional-requirements.md'
  - '{project-root}/docs/play-store-submission.md'
---

<frozen-after-approval reason="human-owned intent - do not modify unless human renegotiates">

## Intent

**Problem:** The first Play Store testing build has three release-risk findings: payment sales reports can miss payments made on a different day than the visit, eligible free-load redemptions are preselected in the payment dialog, and staff PINs are stored in plaintext.

**Approach:** Harden the existing local-only app behavior without changing the release scope: fix payment reporting semantics, make free-load redemption an explicit staff choice, and store staff PINs as local hashes while preserving existing users' ability to unlock once after migration.

## Boundaries & Constraints

**Always:** Preserve offline-only operation; keep customer, visit, payment, and export data local; keep existing Riverpod/Drift architecture; keep payment and loyalty behavior easy for staff to understand; add focused regression tests for the changed business rules.

**Ask First:** Any change requiring network services, cloud sync, Play Store APIs, account login, a new database table, or a user-visible reset of existing staff PINs.

**Never:** Reintroduce ads, analytics, or network permissions; remove staff PIN protection; change the package ID; change Play Store signing files; rewrite broad UI layout unrelated to the findings.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Payment made after visit date | Visit date is May 30, payment date is May 31, report range is May 31 | Sales total and paid visit count include the payment | No special error |
| Unpaid visit in visit range | Visit date is in selected range and not paid | Report still lists it as unpaid for staff follow-up | No special error |
| Eligible free load payment | Customer has available free load and staff opens payment dialog | Free-load checkbox starts unchecked unless the visit already redeemed it | Staff can explicitly check it |
| Existing plaintext PIN | Stored staff PIN is six digits and staff enters that PIN | Unlock succeeds and stored value is upgraded to hashed form | Incorrect PIN still fails |

</frozen-after-approval>

## Code Map

- `lib/features/customers/data/laundry_repository.dart` -- central write/read workflows for visits, payments, loyalty progress, staff PIN storage, and payment report assembly.
- `lib/features/payments/presentation/payment_report_screen.dart` -- payment dialog UI and free-load redemption default behavior.
- `lib/core/database/app_database.dart` -- Drift schema currently stores `staffPin` as nullable text in `loyalty_settings`.
- `test/features/customers/data/laundry_repository_test.dart` -- existing repository regression tests for loyalty and paid/free-load behavior.
- `test/widget_test.dart` -- launch smoke test to confirm kiosk still renders.

## Tasks & Acceptance

**Execution:**
- [x] `lib/features/customers/data/laundry_repository.dart` -- update payment report assembly so paid sales are included by `paymentDate` and unpaid follow-up visits remain visible by `visitDate`.
- [x] `lib/features/payments/presentation/payment_report_screen.dart` -- default free-load redemption checkbox from stored `freeLoadRedeemed` only, not eligibility.
- [x] `lib/features/customers/data/laundry_repository.dart` -- hash newly saved staff PINs and support one-time verification/migration of legacy plaintext PIN values.
- [x] `test/features/customers/data/laundry_repository_test.dart` -- add regression coverage for cross-date payment reporting, free-load explicit redemption semantics where practical, and PIN hash migration.

**Acceptance Criteria:**
- Given a paid visit whose payment date falls inside the selected report range but visit date does not, when the payment report is loaded, then the sales total includes that payment.
- Given an unpaid visit whose visit date falls inside the selected report range, when the payment report is loaded, then the item appears as unpaid.
- Given a customer has a free load available, when staff opens the payment dialog for an unredeemed visit, then the free-load checkbox is not selected by default.
- Given a legacy plaintext staff PIN exists, when staff verifies the correct PIN, then verification succeeds and the stored value is no longer plaintext.
- Given a newly saved staff PIN, when the database record is inspected, then the stored value is a hash marker rather than the raw PIN.

## Spec Change Log

## Verification

**Commands:**
- `C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe -Command '$env:DART_SUPPRESS_ANALYTICS=''true''; $env:FLUTTER_SUPPRESS_ANALYTICS=''true''; C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe analyze'` -- expected: no analyzer issues.
- `C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe -Command '$env:DART_SUPPRESS_ANALYTICS=''true''; $env:FLUTTER_SUPPRESS_ANALYTICS=''true''; C:\src\flutter\bin\flutter.bat test'` -- expected: all tests pass.
- `C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe -Command '$env:DART_SUPPRESS_ANALYTICS=''true''; $env:FLUTTER_SUPPRESS_ANALYTICS=''true''; C:\src\flutter\bin\flutter.bat build appbundle --release'` -- expected: signed release app bundle builds successfully.
