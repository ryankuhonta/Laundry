# Laundry Loyalty Program

Offline-first Flutter Android tablet kiosk for a laundry shop customer log and loyalty tracker.

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Main Routes

- `/kiosk` - customer sign-in form
- `/dashboard` - staff dashboard and search
- `/customers/:id` - customer details and visit history

## Notes

- Drift generated files are intentionally not checked in yet. Generate `*.g.dart` with build runner.
- Signatures are stored as local PNG files in the app documents directory.
- The app has no network dependency for the MVP.

