# Laundry Loyalty Program - Testing Plan

## Unit Tests

- Verify mobile number lookup returns existing customers.
- Verify new mobile numbers create customers.
- Verify repeat visits update customer details and create visit rows.
- Verify a new visit starts with zero loads until staff updates the load count.
- Verify staff can update the load count for a visit.
- Verify reward threshold cannot be saved below one.
- Verify new visits are unpaid until staff records payment.
- Verify staff can record payment amount, payment date, and free-load redemption.
- Verify staff can mark a paid visit as unpaid.
- Verify that after five paid laundry loads the next visit shows a free load available, and that marking the visit as free-load redeemed clears the notice.
- Verify free-load redemption does not count as another paid loyalty load.
- Verify dashboard counts separate new and returning customers for the current day.

## Widget Tests

- Kiosk form shows current date and required fields.
- Submit is blocked when required fields are empty.
- Submit is blocked when signature is empty.
- Existing mobile number fills name and address.
- Dashboard renders today counts, recent visits, near-reward customers, and search results.
- Payments screen renders sales total, paid count, unpaid count, date range controls, and visit payment actions.
- Customer detail page renders totals and visit history.

## Manual Tablet QA

- Test portrait and landscape orientations.
- Confirm touch targets are comfortable on a 10-inch tablet.
- Confirm kiosk form can be completed without staff help.
- Turn Wi-Fi off and record multiple visits.
- Restart the app and confirm local data remains.
- Confirm signature image paths are saved and visits still load.

## Build Verification

Run these commands after Flutter is installed:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run
```
