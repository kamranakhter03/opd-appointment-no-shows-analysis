-- Task 2: Hospitals in the chain
-- Requirement: FR-01
--
-- How many hospitals are in `hospitals`?

-- Write SQL here. Tables: appointments, sms_reminders, doctors, patients, hospitals
SELECT COUNT(*) as total_hospitals FROM hospitals;
