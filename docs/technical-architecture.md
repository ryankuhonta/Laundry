# Laundry Loyalty Program - Technical Architecture

## Architecture Summary

The MVP is an offline-first Flutter Android tablet app. Drift owns local persistence through SQLite. Riverpod exposes the database, repositories, query streams, form controllers, and dashboard state. The UI is feature-first, with reusable widgets kept close to the features that use them.

## Folder Structure

```text
lib/
  main.dart
  app.dart
  core/
    constants/
    database/
    routing/
    utils/
  features/
    customer_kiosk/
      presentation/
      application/
    dashboard/
      presentation/
      application/
    payments/
      presentation/
      application/
      domain/
    customer_details/
      presentation/
    customers/
      domain/
      data/
      application/
      presentation/
```

## State Management

- `ProviderScope` wraps the app.
- `appDatabaseProvider` creates and disposes the Drift database.
- `laundryRepositoryProvider` contains all write workflows and read queries.
- `kioskFormControllerProvider` manages the customer submission workflow.
- Dashboard and detail pages use Riverpod `FutureProvider` and `StreamProvider` where appropriate.

## Persistence Design

- `customers` stores the canonical customer profile.
- `visits` stores each visit, signature path, staff-entered laundry load count, payment status, payment date, payment amount, and whether a free load was redeemed on that visit.
- `loyalty_settings` stores the configurable laundry-load threshold before the next free load.
- Signature images are written to app documents storage and referenced by path.

## Navigation

- `/kiosk`: customer-facing form.
- `/dashboard`: staff overview and search.
- `/payments`: staff payment processing and sales report.
- `/customers/:id`: customer details.

## Offline-First Decisions

- SQLite is the source of truth.
- No network dependency exists in the MVP.
- All analytics are computed from local visits and customers.
- Generated Drift code is produced by `dart run build_runner build`.
