# Laundry Loyalty Program - Business Analysis

## Context

The laundry shop currently uses a paper sign-in form to record the date, customer name, mobile number, address, and signature. This creates manual filing work, makes repeat-customer tracking difficult, and limits the owner's ability to run a simple loyalty program.

## Business Goals

- Replace the paper customer log with an Android tablet kiosk.
- Track visits reliably while the shop operates offline.
- Detect returning customers using mobile number.
- Track loyalty progress from laundry load counts entered by staff.
- Give staff a fast dashboard for daily counts, repeat customers, recent visits, and customer lookup.

## Users

- Customer: enters their own details and signature at the front desk.
- Staff: monitors visits, searches customers, and checks loyalty progress.
- Owner/Manager: reviews repeat behavior and adjusts the reward threshold.

## MVP Success Criteria

- A customer can submit a visit in under one minute.
- Existing customers are recognized by mobile number and their saved details are reused.
- Every submission creates exactly one visit record, and staff can update the number of loads for that visit.
- Staff can see today's new, returning, and total customer counts.
- Staff can search by mobile number or name without internet access.

## Key Assumptions

- One tablet is used at the front desk for the MVP.
- Mobile number is the unique customer identifier.
- Signatures are stored locally as image files, with the path saved in SQLite.
- Full redemption accounting is outside MVP scope; MVP tracks load totals and highlights customers near or at the free-load threshold.
