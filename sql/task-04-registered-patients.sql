-- Task 4: Registered patients
-- Requirement: FR-01
--
-- How many patients are in `patients`?

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
SELECT COUNT (*) as total_patients FROM patients;
