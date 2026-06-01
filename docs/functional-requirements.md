# Laundry Loyalty Program - Functional Requirements

## Customer Kiosk

- FR-001: The app shall show the current date automatically on the customer form.
- FR-002: The app shall collect customer name, mobile number, address, and signature.
- FR-003: The app shall use large text fields and buttons suitable for tablet touch input.
- FR-004: The app shall detect an existing customer when the entered mobile number matches a saved record.
- FR-005: The app shall auto-fill existing customer name and address after mobile lookup.
- FR-006: The app shall require name, mobile number, address, and signature before submission.
- FR-007: The app shall create a visit record on submission.
- FR-008: The app shall confirm that the customer visit was saved and that staff can add the load count.

## Customer Tracking

- FR-009: The app shall create a new customer when the mobile number is not found.
- FR-010: The app shall update an existing customer's name and address when submitted.
- FR-011: The app shall store visit history per customer.
- FR-012: The app shall support staff search by customer name or mobile number.
- FR-012A: The app shall allow staff to enter or update the number of laundry loads for each visit after the customer signs in.

## Loyalty

- FR-013: The app shall count loyalty progress by paid laundry load, not by visit.
- FR-014: The app shall store a configurable laundry-load reward threshold, defaulting to five loads.
- FR-015: The app shall identify customers close to the free-load threshold.
- FR-015A: The app shall treat every five paid laundry loads as qualifying the customer's next load for free.
- FR-015B: The app shall track when a qualified free load is redeemed on a visit so the free-load notice is cleared only after redemption is recorded.

## Payments and Sales

- FR-015C: The app shall create new visits as unpaid until staff records payment.
- FR-015D: The app shall allow staff to record payment amount, payment date, and free-load redemption for a visit.
- FR-015E: The app shall allow staff to mark a paid visit as unpaid if payment was recorded by mistake.
- FR-015F: The app shall show a date-range payment report with paid visits, unpaid visits, and total sales.
- FR-015G: The app shall calculate loyalty progress from paid chargeable loads only; a redeemed free load shall not count as a paid loyalty load.

## Staff Dashboard

- FR-016: The app shall show today's total customer visits.
- FR-017: The app shall show today's new customer count.
- FR-018: The app shall show today's returning customer count.
- FR-019: The app shall show recent customer visits.
- FR-020: The app shall show customers near the reward threshold.
- FR-021: The app shall allow navigation to a customer detail page.

## Customer Details

- FR-022: The app shall show customer name, mobile number, address, total visits, total loads, and last visit date.
- FR-023: The app shall list visit history with date and load count.

## Non-Functional Requirements

- NFR-001: The app shall work without internet connectivity.
- NFR-002: The app shall use local SQLite storage through Drift.
- NFR-003: The UI shall use Material 3.
- NFR-004: The code shall use Riverpod for state management.
- NFR-005: The app shall use a clean architecture, feature-first folder structure.
- NFR-006: The MVP shall avoid cloud sync and user accounts.
