# Data

The full tables are part of the JobPrax project. This folder has a sample of each table and its columns.

### Appointments (`appointments.csv`)

One row per OPD appointment, as extracted from the booking system. Contains duplicates and inconsistent formats.

Sample: [`data/appointments_sample.csv`](appointments_sample.csv) (first 100 rows)

| Column | Type | Description |
| --- | --- | --- |
| appointment_id | text | Appointment identifier |
| patient_id | text | Patient (see patients.csv) |
| doctor_id | text | Doctor (see doctors.csv) |
| booking_date | date | Date the appointment was booked |
| appointment_date | date | Date of the visit |
| slot_time | text | Time slot (HH:MM) |
| booking_channel | text | Front desk, Phone, Website or App (App from July 2026) |
| visit_type | text | New or Follow-up |
| payment_mode | text | Prepaid online, Pay at hospital or Insurance |
| fee | text | Consultation fee, ₹ (some values contain '₹' or 'Rs') |
| status | text | Completed, No-show or Cancelled (spelling and case vary) |

### SMS reminders (`sms_reminders.csv`)

Reminder messages sent the day before each appointment booked at least a day ahead. A failed SMS may be retried once.

Sample: [`data/sms_reminders_sample.csv`](sms_reminders_sample.csv) (first 100 rows)

| Column | Type | Description |
| --- | --- | --- |
| reminder_id | text | Message identifier |
| appointment_id | text | Appointment the reminder is for |
| sent_on | date | Date the SMS was sent |
| delivery_status | text | Delivered or Failed |

### Doctors (`doctors.csv`)

Doctors taking OPD consultations (no names).

Sample: [`data/doctors_sample.csv`](doctors_sample.csv) (first 100 rows)

| Column | Type | Description |
| --- | --- | --- |
| doctor_id | text | Doctor identifier |
| hospital_id | text | Hospital (see hospitals.csv) |
| department | text | Department, e.g. Cardiology |
| experience_years | number | Years of experience |
| consultation_fee | number | Standard fee for a new visit, ₹ |
| joined_on | date | Date the doctor joined Medisetu |

### Patients (`patients.csv`)

Registered patients (no names or contact details).

Sample: [`data/patients_sample.csv`](patients_sample.csv) (first 100 rows)

| Column | Type | Description |
| --- | --- | --- |
| patient_id | text | Patient identifier |
| age | number | Age in years (sometimes missing) |
| gender | text | Gender as captured (M, Male, F, Female, …) |
| city | text | City of residence (some old names are still in use) |
| registered_on | date | First registration date |

### Hospitals (`hospitals.csv`)

The four Medisetu hospitals.

Sample: [`data/hospitals_sample.csv`](hospitals_sample.csv) (first 100 rows)

| Column | Type | Description |
| --- | --- | --- |
| hospital_id | text | Hospital identifier |
| hospital_name | text | Hospital name |
| city | text | City |
| state | text | State |
| beds | number | Number of beds |
| opened_on | date | Opening date |
