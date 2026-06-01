# Play Store Submission Notes

## Release Artifact

- App Bundle: `C:\Dev\Laundry Loyalty Program\build\app\outputs\bundle\release\app-release.aab`
- Package name: `com.rhk.laundryloyalty`
- App name: `Laundry Loyalty`
- Version: `0.1.0`
- Version code: `1`

## Store Listing Draft

Short description:

Offline laundry customer log, visit tracker, payments report, and loyalty rewards tool.

Full description:

Laundry Loyalty helps laundry shop staff replace paper sign-in sheets with an offline Android tablet app. Customers can sign in with their name, mobile number, address, and signature. Staff can track visit history, laundry loads, payments, unpaid visits, and free-load loyalty rewards.

The app is built for simple shop operations and works without an internet connection. Customer and visit data are stored locally on the device.

Core features:

- Customer kiosk sign-in form
- Repeat customer lookup by mobile number
- Visit and laundry load history
- Free-load loyalty tracking
- Paid and unpaid visit tracking
- Date-range sales report
- Local Excel export for shop records
- Staff PIN protection for management screens

## Internal Testing Release Notes

Initial internal testing release.

Includes customer sign-in, local customer records, visit tracking, loyalty load tracking, payment reporting, Excel export, and staff PIN protection.

## App Content Answers

App category:

- Suggested category: Business

Ads:

- Current answer: No, this release does not contain ads.
- Change this later when AdMob is added.

App access:

- Current answer: All or some functionality is restricted.
- Note for reviewer: Staff dashboard and reports are protected by a staff PIN. The customer kiosk screen is available on app launch.

Target audience:

- Suggested: Adults / business users, not directed at children.

Permissions:

- Release build does not declare Internet permission.
- Debug/profile manifests include Internet only for Flutter development tooling.

## Data Safety Draft

This release does not transmit user data to external servers.

Data entered by users and staff is stored locally on the device for shop operations:

- Customer name
- Mobile number
- Address
- Signature image
- Visit dates
- Laundry load counts
- Payment amount and payment date
- Free-load redemption status

Suggested Data safety interpretation for this release:

- Data collected: No, if Google Play's definition is limited to data transmitted off the device.
- Data shared: No.
- Data encrypted in transit: Not applicable, because the app does not transmit user data.
- Users can request deletion: Local records can be deleted only through app/device data management unless a delete feature is added later.

Review carefully in Play Console. If ads, analytics, cloud sync, crash reporting, account login, or remote backups are added later, update this section.

## Privacy Policy Draft

Laundry Loyalty stores customer and shop visit information locally on the Android device where the app is installed.

The app may store customer names, mobile numbers, addresses, signature images, visit records, laundry load counts, payment records, and free-load redemption status. This information is used only for laundry shop customer tracking, payment reporting, and loyalty rewards.

This release does not send customer data to external servers and does not include advertising or analytics SDKs.

The app's data remains on the device unless the shop exports records or backs up/transfers the device data outside the app. Shop owners are responsible for handling exported customer records securely and for deleting local app data when needed.

Contact: replace-with-your-support-email

Last updated: 2026-05-31

## Manual Play Console Steps

1. Open Google Play Console.
2. Create a new app named `Laundry Loyalty`.
3. Set default language and app type.
4. Choose free or paid.
5. Complete Store listing using the text above.
6. Upload required graphics and screenshots.
7. Complete App content:
   - Privacy policy URL
   - Data safety
   - Ads
   - App access
   - Target audience
   - Content rating
8. Go to Testing > Internal testing.
9. Create a new release.
10. Upload `app-release.aab`.
11. Add the internal testing release notes.
12. Add tester email list or Google Group.
13. Review and roll out to Internal testing.

## Keystore Backup

Back up these files securely:

- `C:\Dev\Laundry Loyalty Program\android\app\upload-keystore.jks`
- `C:\Dev\Laundry Loyalty Program\android\key.properties`

You need the same upload key for future app updates.
