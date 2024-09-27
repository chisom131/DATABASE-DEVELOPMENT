Create Database Hospital
Use Hospital
--Create the database with name Hospital--

--Create table patients--
CREATE TABLE Patients (
    PatientID Tinyint IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(30) NOT NULL,
    MiddleName NVARCHAR(30) NULL,
    LastName NVARCHAR(30) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Insurance NVARCHAR(20) NOT NULL,
    Username NVARCHAR(20) NOT NULL,
	AddressID TINYINT NOT NULL,
    PasswordHash BINARY(64) NOT NULL
);

--Create table Address--
CREATE TABLE Address(
	AddressID tinyint IDENTITY(1,1) PRIMARY KEY,
	AddressLine1 nvarchar(50) NOT NULL,
	AddressLine2 nvarchar(50) NULL,
	City nvarchar(20) NOT NULL,
	County nvarchar(20) Null,
	Country nvarchar (20) NOT Null,
	Postcode nvarchar(10) NOT NULL,
	CONSTRAINT UC_Address UNIQUE (AddressLine1, Postcode)
);

--Create table ContactInfo--
CREATE TABLE ContactInfo (
	ContactInfoID tinyint IDENTITY(1,1) PRIMARY KEY,
	Email nvarchar(50)  UNIQUE NOT NULL CHECK
	(Email LIKE '%_@_%._%'),
	Phonenumber nvarchar(20) NOT NULL,
	Landline nvarchar(20) NULL,
	PatientID tinyint NULL FOREIGN KEY REFERENCES Patients
	(PatientID)
	);

--Create table Doctors--
CREATE TABLE Doctors (
    DoctorID tinyint IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(30) NOT NULL,
    MiddleName NVARCHAR(30) NULL,
    LastName NVARCHAR(30) NOT NULL,
    Specialty NVARCHAR(20) NOT NULL,
    DepartmentID tinyINT  null
);

--Create table Availability--
CREATE TABLE Availability(
	AvailabilityID tinyint IDENTITY(1,1) PRIMARY KEY,
	DoctorID tinyint Not null,
	DaysAvailable nvarchar(20) null,
	StartTime time not null,
	EndTime  time not null
);

--Create table Departments--
CREATE TABLE Departments (
    DepartmentID tinyINT PRIMARY KEY IDENTITY,
    DepartmentName NVARCHAR(20) NOT NULL,
	DepartmentEmail nvarchar(50)  UNIQUE NOT NULL CHECK
	(DepartmentEmail LIKE '%_@_%.hospital.%')
);

--Create table AppointmentHistory--
CREATE TABLE AppointmentHistory(
	HistoryID int IDENTITY(1,1) PRIMARY KEY,
	PatientID tinyint not NULL FOREIGN KEY REFERENCES Patients
	(PatientID),
	DoctorID tinyint null FOREIGN KEY REFERENCES Doctors
	(DoctorID),
    Feedback NVARCHAR(MAX),
	Status NVARCHAR(20),
	DateOFApp  date not null
);

--Create table Appointments--
CREATE TABLE Appointments (
    AppointmentID int IDENTITY(1,1) PRIMARY KEY,
    PatientID tinyint not NULL FOREIGN KEY REFERENCES Patients
	(PatientID),
    DoctorID tinyint null FOREIGN KEY REFERENCES Doctors
	(DoctorID),
    AppointmentDate DATE not null,
    AppointmentTime TIME null,
    DepartmentID tinyINT null FOREIGN KEY REFERENCES Departments
	(DepartmentID),
    Status NVARCHAR(20)
);

--Create table MedicalRecords--
CREATE TABLE MedicalRecords (
    RecordID INT PRIMARY KEY IDENTITY,
    PatientID tinyINT not null FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID tinyINT null FOREIGN KEY REFERENCES Doctors(DoctorID),
    Diagnosis NVARCHAR(100) null,
    Medicine NVARCHAR(100) null,
    MedPreDate DATE null,
    Allergies NVARCHAR(50) null
);

--Alter table Patients to link the foreign key--
alter table Patients ADD CONSTRAINT PatientsAddress
foreign key (AddressID) references Address
(AddressID);

--Alter table Doctors to link the foreigns key--
alter table Doctors ADD constraint DoctorsDepartment
foreign key (DepartmentID) references Departments
(DepartmentID);

--Alter table Availability to link the foreigns key--
alter table Availability add constraint DoctorsAvailability
foreign key (DoctorID) references Doctors
(DoctorID);


select * from MedicalRecords

-- Stored procedure to encrypt my password--
CREATE PROCEDURE InsertPatient
    @FirstName NVARCHAR(30),
    @MiddleName NVARCHAR(30),
    @LastName NVARCHAR(30),
    @DateOfBirth DATE,
    @Insurance NVARCHAR(50),
    @Username NVARCHAR(50),
	@AddressID TINYINT,
    @Password NVARCHAR(50)
AS
 BEGIN
    DECLARE @salt UNIQUEIDENTIFIER = NEWID();
    DECLARE @HashedPassword BINARY(64);

    SET @HashedPassword = HASHBYTES('SHA2_512', @Password + CAST(@salt AS NVARCHAR(36)));

    INSERT INTO Patients (FirstName, MiddleName, LastName, DateOfBirth, Insurance, Username, AddressID, PasswordHash)
    VALUES (@FirstName, @MiddleName, @LastName, @DateOfBirth, @Insurance, @Username, @AddressID, @HashedPassword);
END;


--INSERT INTO Address--
INSERT INTO Address (AddressLine1, City, Country, Postcode)
VALUES ('WxWcarvbsiy', 'M AnCity','United Kingdom', 'M34 76d'),
('AxWcarvbsiy', 'MAnCi ty1','United Kingdom', 'M341 76d'),
('WxWcarverer  bsiy', 'MAnCi ty2w','United Kingdom', 'M34s 76d'),
('W xWcarvb12d fd siy', 'MAnCity cd','United Kingdom', 'M34d 76d'),
('WxW1 4bv rc carvbsiy', 'MAnCsdit y','United Kingdom', 'cM34 76d'),
('W8iu 1v xWcarvbsiy', 'acheMAnC ity','United Kingdom', '2M34 76d'),
('A xWcar gv vbsiy', 'Chelesea','U Kingdom', 'M341 76d'),
('W xWcarverer  bsiy', 'MA nCit y2w','United AUST', 'M34s 76d'),
('WxWc arvb12d fd siy', 'MAnCi tycd','Kingdom hALLSEED', 'M3 4d 76d'),
('WxW 14bv rc carvbsiy', 'MAzAnCsdity','United Kingdom', 'cM34 76d'),
('W8 iu1v xWcarvbsiy', 'acheMAnCity','wALES', 'W 76d');


--INSERT INTO Patients
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Insurance, Username, AddressID, PasswordHash)
VALUES 
('Isaac', 'Onnana', '1950-05-23', 'M34TDDCE', 'ISSAC123', 1, HASHBYTES('SHA2_512', 'password1')),
('John', 'Willi', '1950-05-23', 'M34TDDCE', 'ISSA788C123', 9, HASHBYTES('SHA2_512', 'password2')),
('Fill', 'Kate', '1987-08-23', 'M34TDDCE', 'YYUFRISSAC123', 4, HASHBYTES('SHA2_512', 'password3'));

INSERT INTO Patients (FirstName, LastName, DateOfBirth, Insurance, Username, AddressID, PasswordHash)
VALUES 
('John', 'Water', '2014-05-02', 'D34TDDCE', 'WA123', 2, HASHBYTES('SHA2_512', 'password1')),
('Obina', 'Rice', '1983-12-23', 'YI4TDDCE', 'OBI788C123', 3, HASHBYTES('SHA2_512', 'password2')),
('Joseph', 'Stone', '1997-05-23', 'E34TDDCE', 'JOEC123', 4, HASHBYTES('SHA2_512', 'password3')),
('Peter', 'Onnuma', '1985-09-23', 'F34TDDCE', 'PTAC123', 5, HASHBYTES('SHA2_512', 'password1')),
('Andrew', 'Gideon', '1982-10-23', 'U34TDDCE', 'IGIDC123', 6, HASHBYTES('SHA2_512', 'password2')),
('Kate', 'Kelechi', '1960-11-23', 'K34TDDCE', 'YKLEC123', 7, HASHBYTES('SHA2_512', 'password3')),
('Issabella', 'Abel', '1997-03-23', 'I34TDDCE', 'ABE34', 11, HASHBYTES('SHA2_512', 'password1')),
('Philip', 'Wiliams', '1999-12-23', 'M54TDDCE', 'PHIL', 10, HASHBYTES('SHA2_512', 'password2')),
('Masson', 'Kelvin', '2000-06-23', 'T34TDDCE', 'RICHASF', 8, HASHBYTES('SHA2_512', 'password3')),
('Hope', 'Gold', '1957-05-13', 'ML4TDDCE', 'HGPK', 4, HASHBYTES('SHA2_512', 'password1')),
('Love', 'Isa', '1922-05-20', 'Q34TDDCE', 'IWER456677', 6, HASHBYTES('SHA2_512', 'password2')),
('Annastasia', 'Kin-Hun-mu', '1999-08-03', 'R34TDDCE', 'YaSSAC123', 1, HASHBYTES('SHA2_512', 'password3'));

SELECT *
FROM Patients 

--INSERT INTO ContactInfo--

INSERT INTO ContactInfo
VALUES ('doha@g.com', '+23401226656', '', 2),
('dha@g.com', '+23401226656', '454200', 3),
('doa@g.com', '+23401226656', '0 5525', 4),
('doh@g.com', '+23401226656', '0074', 5),
('oha@g.com', '+23401226656', '', 6),
('da@g.com', '+23401226656', '', 7),
('d@g.com', '+23401226656', '474', 8),
('oa@g.com', '+23401226656', '', 9),
('oh@g.com', '+23401226656', '', 10),
('o@g.com', '+23401226656', '1201', 11),
('do@g.com', '+23401226656', '', 12),
('yuh@g.com', '+23401226656', '', 13),
('fhgt@g.com', '+23401226656', '1412', 14),
('hthn@g.com', '+23401226656', '', 15),
('nhj@g.com', '+23401226656', '', 1);

--INSERT INTO Departments--
INSERT INTO Departments
VALUES ('Emergency Department', 'Hosp@Emergency.hospital.com'),
('Aldult Department', 'Hosp@Aldult.hospital.com'),
('Critical Department', 'Hosp@critical.hospital.com'),
('Children Department', 'Hosp@children.hospital.com'),
('Aged Department', 'Hosp@aged.hospital.com');

select * from Departments

--INSERT INTO Doctors
INSERT INTO Doctors
VALUES ('Gideon','', 'Wolf', 'Gastroenterologist', 2),
('Joseph', 'Aita','Williams', 'paediatrician ', 4),
('Charlse','', 'Hoza', 'oncologists', 5),
('Katrine','Kim', 'Kliams', 'surgeon  ', 1),
('Uche', '','ignatus', 'Gastroenterologist', 3),
('Kate', '', 'Gidi', 'General practice  ', 5),
('Dozie','', 'faruke', 'Emergency Medcine', 3);

select * from Doctors

--INSERT INTO Availability
INSERT INTO Availability
VALUES 
(3, 'Satuday', '08:50:00', '12:00:00'),
(2, 'Monday', '14:00:00', '18:04:00'),
(3, 'Sunday', '09:32:00', '13:00:00'),
(2, 'Tuesday', '15:00:00', '19:00:00'),
(4, 'Wednesday', '10:05:00', '14:00:00'),
(7, 'Wednesday', '16:00:00', '20:00:00'),
(1, 'Thursday', '11:30:00', '15:00:00'),
(5, 'Friday', '17:00:00', '21:00:00'),
(3, 'Friday', '12:00:00', '16:00:00'),
(5, 'Friday', '18:45:00', '22:00:00'),
(6, 'Tuesday', '13:00:00', '17:00:00'),
(5, 'Satuday', '19:00:00', '23:00:00'),
(7, 'Monday', '14:00:00', '18:00:00'),
(6, 'Sunday', '16:30:00', '23:59:00');

select * from Availability

--2. Add the constraint to check that the appointment date is not in the past.
ALTER TABLE Appointments 
ADD CONSTRAINT Checking_AppointmentDate
CHECK (AppointmentDate >= GETDATE());


--INSERT INTO Appointments--
INSERT INTO Appointments
VALUES (2, 1, '2027-03-23', '09:30:00', 1, 'Pending'),
(3, 2, '2029-03-24', '10:00:00', 2, 'Pending'),
(4, 3, '2025-03-25', '11:45:00', 3, 'Pending'),
(3, 2, '2026-03-24', '10:00:00', 2, 'Pending'),
(4, 3, '2024-06-25', '11:20:00', 3, 'Pending'),
(5, 4, '2024-07-26', '12:00:00', 4, 'Pending'),
(6, 5, '2024-09-27', '13:13:00', 5, 'Pending'),
(7, 6, '2026-01-28', '14:00:00', 1, 'Pending'),
(1, 3, '2024-06-02', '18:00:00', 5, 'Pending'),
(12, 4, '2024-04-30', '19:45:00', 1, 'Cancelled'),
(13, 5, '2024-05-03', '20:00:00', 2, 'Pending'),
(14, 6, '2024-05-04', '21:00:00', 3, 'Pending'),
(6, 5, '2024-08-27', '13:30:00', 5, 'Pending'),
(7, 6, '2024-12-28', '14:42:00', 1, 'Pending'),
(8, 7, '2024-11-29', '15:00:00', 2, 'Cancelled'),
(9, 1, '2024-07-30', '16:00:00', 3, 'Pending'),
(10, 2, '2024-05-31', '17:40:00', 4, 'Pending'),
(11, 3, '2024-06-01', '18:00:00', 5, 'Pending'),
(12, 4, '2024-06-02', '19:00:00', 1, 'Pending'),
(1, 5, '2024-07-03', '20:13:00', 2, 'Cancelled'),
(14, 6, '2024-09-04', '21:00:00', 3, 'Pending'),
(15, 7, '2024-10-05', '22:13:00', 4, 'Pending');

select * from Appointments

--INSERT INTO AppointmentHistory--
INSERT INTO AppointmentHistory
VALUES 
(10, 4, 'My first time here, ill say it was a good enviroment. very clean and calm','Completed', '2024-01-25'),
(11, 5, 'WHY? Im so angry now', 'Cancelled', '2024-01-26'),
(12, 6, 'Doctor was knowledgeable and friendly.', 'Completed', '2024-01-27'),
(3, 7, 'wdfhjtjng trhrnr th', 'Completed', '2024-01-28'),
(14, 1, 'Le rendez-vous a commencé à l’heure.', 'Completed', '2024-01-29'),
(15, 2, 'Az orvos türelmes és megértő volt.', 'Completed', '2024-01-30'),
(1, 3, 'Will recommend to others.', 'Completed', '2024-01-31'),
(2, 4, 'THis Doctor cancelled the appointment because he wanted to go on a date! for real!!', 'Cancelled', '2024-02-15'),
(13, 5, 'Amaghị m ihe ọzọ ị ga-ekwu, natara nlekọta dị mma.','Completed', '2024-02-02'),
(4, 2, 'Dont know Arabic','Completed', '2024-02-03'),
(15, 7, 'Sun yi sanyin gwiwa don hidimar.','Completed', '2024-02-04'),
(6, 1, 'effbf rgrt ryrg', 'Cancelled','2024-02-05'),
(7, 2, 'Lange Wartezeit und überstürzte Terminvereinbarung.','Cancelled', '2024-02-06'),
(8, 3, 'Randevou te repwodui san avètisman.','Completed', '2024-02-07'),
(9, 4, 'Send me away','Completed', '2024-02-08'),
(5, 2, 'Happy Happier Happiest', 'Completed','2024-02-09')

select * from AppointmentHistory

--INSERT INTO MedicalRecords
INSERT INTO MedicalRecords
VALUES (1,7,'Hypertension', 'Lisinopril', '2023-11-04', 'Drug Allergies'),
(1,5,'Cancer ', 'Chemotherapy', '2023-05-04', 'Drug Allergies'),
(2,4,'Lymphoma', 'Bleomycin', '2021-11-04', ' Milk, Eggs'),
(2,1,'Migraine Headaches ', 'Propranolol ', '2022-01-04', 'Eggs'),
(3,6,'Bladder Cancer', 'Cisplatin', '2020-11-04', 'Anaphylaxis'),
(4,2,'Hyperlipidemia  ', 'Rosuvastatin', '2024-01-04', 'Latex Allergy'),
(4,4,'Lymphoma', 'Bleomycin', '2021-11-04', ' Wheat Allergy'),
(3,1,'(stage 3)Bladder Cancer', 'Chemotherapy ', '2024-03-04', 'Mould Allergy'),
(15,3,'Type 2 Diabetes Mellitus', 'Insulin (various types)', '2019-11-14', ''),
(14,5,'Prostate Cancer', 'Enzalutamide', '2015-01-01', 'Sesame Seed Allergy'),
(12,4,'Lymphoma', 'Bleomycin', '2021-11-04', ' Milk, Eggs'),
(9,1,'Migraine Headaches ', 'Propranolol ', '2022-01-04', 'Eggs'),
(7,6,'Bladder Cancer', 'Cisplatin', '2020-11-04', ''),
(5,2,'Hyperlipidemia  ', 'Rosuvastatin', '2024-01-04', 'Latex Allergy'),
(6,4,'Lymphoma', 'Bleomycin', '2021-11-04', ' Wheat Allergy'),
(8,1,'(stage 3)Bladder Cancer', 'Chemotherapy ', '2024-01-04', 'Soy Allergy'),
(10,7,'Hypertension', 'Lisinopril', '2023-11-04', 'Food Allergies( Milk, Eggs)'),
(11,5,'Cancer ', 'Chemotherapy', '2020-01-13', 'Food Allergies'),
(2,4,'Lymphoma', 'Bleomycin', '2021-11-04', ' Milk, Eggs'),
(2,1,'MigraineHeadaches ', 'Propranolol ', '2022-01-04', 'Eggs'),
(13,6,'Bladder Cancer', 'Cisplatin', '2020-11-04', 'Sesame Seed Allergy'),
(1,2,'Hyperlipidemia  ', 'Rosuvastatin', '2023-01-07', 'Drug Allergies'),
(10,4,'Lymphoma', 'Bleomycin', '2021-11-04', 'Insect Sting Allergy'),
(13,1,'(stage 3)Bladder Cancer', 'Chemotherapy ', '2024-02-04', 'Sesame Seed Allergy');

--3. List all the patients with older than 40 and have Cancer in diagnosis.

select distinct p.FirstName, p.LastName, p.DateOfBirth
from Patients As p
inner join MedicalRecords AS MR ON p.PatientID = MR.PatientID
where DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) > 40
AND mr.Diagnosis LIKE '%Cancer%';

--4. The hospital also requires stored procedures or user-defined functions to do the 

--A) Search the database of the hospital for matching character strings by name of medicine. Results should be sorted with most recent medicine prescribed date first. 

CREATE PROCEDURE SearchMedicines
    @Medicine NVARCHAR(100)
AS
BEGIN
    SELECT *
    FROM MedicalRecords
    WHERE Medicine LIKE '%' + @Medicine + '%'
    ORDER BY MedPreDate DESC;
END;


-- Lets find "Chemotherapy"
EXEC SearchMedicines @Medicine = 'Chemotherapy';

--B) Return a full list of diagnosis and allergies for a specific patient who has an appointment today (i.e., the system date when the query is run)

CREATE PROCEDURE GetPatDiogAndAleg
    @PatientID INT
AS
BEGIN
    SELECT me.Diagnosis, me.Allergies
    FROM MedicalRecords as me
	inner join Appointments as app on me.PatientID = app.PatientID
    WHERE me.PatientID = @PatientID
    AND AppointmentDate = CAST(GETDATE() AS DATE);
END;

-- Lets find who has appointment today
EXEC GetPatDiogAndAleg @PatientID = 15; 

--C) Update the details for an existing doctor


CREATE PROCEDURE UpdatingDoctor
    @DoctorID tinyint,
    @FirstName NVARCHAR(30),
	@MiddleName NVARCHAR(30),
	@LastName NVARCHAR(30),
	@Specialty NVARCHAR(20),
    @DepartmentID tinyINT
AS
BEGIN
    UPDATE Doctors
    SET FirstName = @FirstName,
		MiddleName = @MiddleName,
		LastName = @LastName,
        Specialty = @Specialty,
		DepartmentID = @DepartmentID
    WHERE DoctorID = @DoctorID;
END;


EXEC UpdatingDoctor 
    @DoctorID = 1, @FirstName = 'Chisom', @MiddleName = 'Gideon', @LastName = 'Kelechi', @Specialty = 'HideAndSeck', @DepartmentID = 5;
select * from Doctors

--D) Delete the appointment who status is already completed.


CREATE PROCEDURE DelApp_Cmp
AS
BEGIN
    SET NOCOUNT ON;
	    -- Move completed appointments to AppointmentHistory--
    INSERT INTO AppointmentHistory (PatientID, DoctorID, Feedback, Status, DateOFApp)
    SELECT PatientID, DoctorID, NULL AS Feedback, 'completed' AS Status, AppointmentDate AS DateOFApp
    FROM Appointments
    WHERE Status = 'completed';

    DELETE FROM Appointments
    WHERE Status = 'completed';
END


select * from Appointments
 --Testing my Code
 UPDATE Appointments
SET Status = 'completed'
WHERE AppointmentID = 19
EXEC DelApp_Cmp;


-- 5 . The hospitals wants to view the appointment date and time, showing all previous and current appointments for all doctors, and including details of the department (the doctor is associated with), doctor’s specialty and any associate review/feedback given for a doctor. You should create a view containing all the required information.

--CREATE VIEW AppointmentDetails--
CREATE VIEW AppointmentDetails (DoctorID, FirstName, LastName, Specialty, AppointmentDate,  AppointmentTime,DateOFApp, Feedback, DepartmentName)
As
SELECT D.DoctorID, D.FirstName, D.LastName, D.Specialty,
       A.AppointmentDate, A.AppointmentTime, AH.DateOFApp, AH.Feedback,
       Dp.DepartmentName
FROM Doctors D
JOIN Appointments A ON D.DoctorID = A.DoctorID
JOIN AppointmentHistory AH ON D.DoctorID = AH.DoctorID
JOIN Departments Dp ON D.DepartmentID = Dp.DepartmentID;

 select * from AppointmentDetails


 --6. Create a trigger so that the current state of an appointment can be changed to available when it is cancelled.
Create trigger changed_to_available 
on Appointments
AFTER Update 
as Begin
	IF UPDATE(Status)
		Begin
			UPDATE Appointments
			SET Status = 'Available'
			WHERE Status = 'Cancelled';
		END;
END


UPDATE Appointments
SET Status = 'Cancelled'
WHERE Status = 'completed'

 select * from Appointments


 --7. Write a select query which allows the hospital to identify the number of completed appointments with the specialty of doctors as ‘Gastroenterologists’.

 SELECT * from Doctors
 select * from AppointmentHistory



SELECT COUNT(*) AS completed_appointments
FROM AppointmentHistory AH
JOIN Doctors D ON Ah.DoctorID = D.DoctorID
WHERE AH.status = 'completed'
AND D.Specialty = 'Gastroenterologist';
