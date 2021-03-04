--
-- Abstract: This database is used for keeping records for a construction company
--			 to help maintain orderly, productive flow of business. 
--							 
-- Author: Derrick Warren			  
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL1;  
SET NOCOUNT ON;		-- report errors only

-- --------------------------------------------------------------------------------
-- Drop Tables
-- --------------------------------------------------------------------------------

IF OBJECT_ID( 'TJobMaterials' )		IS NOT NULL DROP TABLE TJobMaterials
IF OBJECT_ID( 'TJobWorkers' )		IS NOT NULL DROP TABLE TJobWorkers
IF OBJECT_ID( 'TWorkerSkills' )		IS NOT NULL DROP TABLE TWorkerSkills

IF OBJECT_ID( 'TJobs' )				IS NOT NULL DROP TABLE TJobs
IF OBJECT_ID( 'TMaterials' )		IS NOT NULL DROP TABLE TMaterials
IF OBJECT_ID( 'TSkills')			IS NOT NULL DROP TABLE TSkills

IF OBJECT_ID( 'TWorkers' )			IS NOT NULL DROP TABLE TWorkers
IF OBJECT_ID( 'TCustomers' )		IS NOT NULL DROP TABLE TCustomers
IF OBJECT_ID( 'TVendors' )			IS NOT NULL DROP TABLE TVendors

IF OBJECT_ID( 'TStatuses' )			IS NOT NULL DROP TABLE TStatuses

IF OBJECT_ID( 'TStates' )			IS NOT NULL DROP TABLE TStates


-- --------------------------------------------------------------------------------
-- Drop Views
-- --------------------------------------------------------------------------------

IF OBJECT_ID( 'vJobLaborCosts' )		IS NOT NULL DROP VIEW vJobLaborCosts

-- --------------------------------------------------------------------------------
-- Create Tables
-- --------------------------------------------------------------------------------

CREATE TABLE TJobs
(
	 intJobID							INTEGER				NOT NULL
	,intCustomerID						INTEGER				NOT NULL
	,intStatusID						INTEGER				NOT NULL
	,dtmStartDate						DATETIME			NOT NULL
	,dtmEndDate							DATETIME			NOT NULL
	,strJobDesc							VARCHAR(2000)		NOT NULL
	,CONSTRAINT TJobs_PK				PRIMARY KEY ( intJobID )
)


CREATE TABLE TCustomers
(
	  intCustomerID						INTEGER				NOT NULL
	 ,strFirstName						VARCHAR(50)			NOT NULL
	 ,strLastName						VARCHAR(50)			NOT NULL
	 ,strAddress						VARCHAR(50)			NOT NULL
	 ,strCity							VARCHAR(50)			NOT NULL
	 ,intStateID						INTEGER				NOT NULL
	 ,strZip							VARCHAR(50)			NOT NULL
	 ,strPhoneNumber					VARCHAR(50)			NOT NULL
	 ,CONSTRAINT TCustomer_PK			PRIMARY KEY ( intCustomerID )
)


CREATE TABLE TStatuses
(
	 intStatusID						INTEGER				NOT NULL
	,strStatus							VARCHAR(50)			NOT NULL
	,CONSTRAINT TStatuses_PK			PRIMARY KEY ( intStatusID )
)

CREATE TABLE TJobMaterials
(
	 intJobMaterialID					INTEGER				NOT NULL
	,intJobID							INTEGER				NOT NULL
	,intMaterialID						INTEGER				NOT NULL
	,intQuantity						INTEGER				NOT NULL
	,CONSTRAINT TCustomerJobMaterials_PK PRIMARY KEY ( intJobMaterialID )
)

CREATE TABLE TMaterials
(
	 intMaterialID						INTEGER				NOT NULL
	,strDescription						VARCHAR(100)		NOT NULL
	,monCost							MONEY				NOT NULL
	,intVendorID						INTEGER				NOT NULL
	,CONSTRAINT TMaterials_PK			PRIMARY KEY ( intMaterialID )
)

CREATE TABLE TVendors
(
	 intVendorID						INTEGER				NOT NULL
	,strVendorName						VARCHAR(50)			NOT NULL
	,strAddress							VARCHAR(50)			NOT NULL
	,strCity							VARCHAR(50)			NOT NULL
	,intStateID							INTEGER				NOT NULL
	,strZip								VARCHAR(50)			NOT NULL
	,strPhoneNumber						VARCHAR(50)			NOT NULL
	,CONSTRAINT TVendors_PK				PRIMARY KEY ( intVendorID )
)

CREATE TABLE TJobWorkers
(
	 intJobWorkerID						INTEGER				NOT NULL
	,intJobID							INTEGER				NOT NULL
	,intWorkerID						INTEGER				NOT NULL
	,intHoursWorked						INTEGER				NOT NULL
	,CONSTRAINT TCustomerJobWorkers_PK	PRIMARY KEY ( intJobWorkerID )
)

CREATE TABLE TWorkers
(
	  intWorkerID						INTEGER				NOT NULL
	 ,strFirstName						VARCHAR(50)			NOT NULL
	 ,strLastName						VARCHAR(50)			NOT NULL
	 ,strAddress						VARCHAR(50)			NOT NULL
	 ,strCity							VARCHAR(50)			NOT NULL
	 ,intStateID						INTEGER				NOT NULL
	 ,strZip							VARCHAR(50)			NOT NULL
	 ,strPhoneNumber					VARCHAR(50)			NOT NULL
	 ,dtmHireDate						DATETIME			NOT NULL
	 ,monHourlyRate						MONEY				NOT NULL
	 ,CONSTRAINT TWorkers_PK			PRIMARY KEY ( intWorkerID )
)

CREATE TABLE TWorkerSkills
(
	 intWorkerSkillID					INTEGER				NOT NULL
	,intWorkerID						INTEGER				NOT NULL
	,intSkillID							INTEGER				NOT NULL
	,CONSTRAINT	TWorkerSkills_PK		PRIMARY KEY ( intWorkerSkillID )
)

CREATE TABLE TSkills
(
	 intSkillID							INTEGER				NOT NULL
	,strSkill							VARCHAR(50)			NOT NULL
	,strDescription						VARCHAR(100)		NOT NULL
	,CONSTRAINT TSkills_PK				PRIMARY KEY ( intSkillID )
)

CREATE TABLE TStates
(
	 intStateID							INTEGER			NOT NULL
	,strStateDesc						Varchar(255)	NOT NULL
	,CONSTRAINT TStates_PK PRIMARY KEY ( intStateID )
)

-- --------------------------------------------------------------------------------
-- Identify and Create Foreign Keys
-- --------------------------------------------------------------------------------
--
-- #	Child												Parent							Column(s)
-- -	-----												------							---------
-- 1	TJobMaterials										TJobs							intJobID --
-- 2	TJobMaterials										TMaterials						intMaterialID --

-- 3	TJobWorkers											TJobs							intJobID --
-- 4	TJobWorkers											TWorkers						intWorkerID --

-- 5	TWorkerSkills										TWorkers						intWorkerID --
-- 6	TWorkerSkills										TSkills							intSkillID --

-- 7	TJobs												TCustomers						intCustomerID --
-- 8	TJobs												TStatuses						intStatusID --

-- 9	TMaterials											TVendors						intVendorID --

-- 10	TCustomers											TStates							intStateID --
-- 11	TVendors											TStates							intStateID --
-- 12	TWorkers											TStates							intStateID --

-- 1
ALTER TABLE TJobMaterials ADD CONSTRAINT TJobMaterials_TJobs_FK
FOREIGN KEY ( intJobID ) REFERENCES TJobs ( intJobID ) ON DELETE CASCADE

-- 2
ALTER TABLE TJobMaterials ADD CONSTRAINT TJobMaterials_TMaterials_FK
FOREIGN KEY ( intMaterialID ) REFERENCES TMaterials ( intMaterialID ) ON DELETE CASCADE

-- 3
ALTER TABLE TJobWorkers ADD CONSTRAINT TJobWorkers_TJobs_FK
FOREIGN KEY ( intJobID ) REFERENCES TJobs ( intJobID ) ON DELETE CASCADE

-- 4
ALTER TABLE TJobWorkers ADD CONSTRAINT TJobWorkers_TWorkers_FK
FOREIGN KEY ( intWorkerID ) REFERENCES TWorkers ( intWorkerID ) ON DELETE CASCADE

-- 5
ALTER TABLE TWorkerSkills ADD CONSTRAINT TWorkerSkills_TWorkers_FK
FOREIGN KEY ( intWorkerID ) REFERENCES TWorkers ( intWorkerID ) ON DELETE CASCADE

-- 6
ALTER TABLE TWorkerSkills ADD CONSTRAINT TWorkerSkills_TSkills_FK
FOREIGN KEY ( intSkillID ) REFERENCES TSkills( intSkillID ) ON DELETE CASCADE

-- 7
ALTER TABLE TJobs ADD CONSTRAINT TJobs_TCustomers_FK
FOREIGN KEY ( intCustomerID ) REFERENCES TCustomers ( intCustomerID ) ON DELETE CASCADE

-- 8
ALTER TABLE TJobs ADD CONSTRAINT TJobs_TStatuses_FK
FOREIGN KEY ( intStatusID ) REFERENCES TStatuses ( intStatusID ) ON DELETE CASCADE

-- 9
ALTER TABLE TMaterials ADD CONSTRAINT TMaterials_TVendors_FK
FOREIGN KEY ( intVendorID ) REFERENCES TVendors (intVendorID ) ON DELETE CASCADE

-- 10
ALTER TABLE TCustomers ADD CONSTRAINT TCustomers_TStates_FK
FOREIGN KEY ( intStateID ) REFERENCES TStates ( intStateID ) ON DELETE NO ACTION

-- 11
ALTER TABLE TVendors ADD CONSTRAINT TVendors_TStates_FK
FOREIGN KEY ( intStateID ) REFERENCES TStates ( intStateID ) ON DELETE NO ACTION

-- 12
ALTER TABLE TWorkers ADD CONSTRAINT TWorkers_TStates_FK
FOREIGN KEY ( intStateID ) REFERENCES TStates (intStateID ) ON DELETE NO ACTION


-- --------------------------------------------------------------------------------
-- Populate Each Table with Test Data
-- --------------------------------------------------------------------------------

INSERT INTO TStates ( intStateID, strStateDesc )
VALUES	 ( 1, 'Ohio' )
		,( 2, 'Kentucky' )
		,( 3, 'Indiana' )


INSERT INTO TCustomers( intCustomerID, strFirstName, strLastName, strAddress, strCity, intStateID, strZip, strPhoneNumber )
VALUES	 ( 1, 'Paula', 'Giel', '98 Sherman St.', 'Frankfort', 2, '41042', '8597506699' )
		,( 2, 'Donnie', 'Schorr', '439 College St.', 'Florence', 2, '41042', '8598882222' )
		,( 3, 'Estrella', 'Frazer', '323 Main St.', 'Hebron', 2, '41012', '8592021111' )
		,( 4, 'Myrl', 'Breigh', '7934 Young Dr.', 'Bloom', 3, '51003', '7704251379' )
		,( 5, 'Cory', 'Unruh', ' 911 Main St.' , 'Amelia', 1, '45018', '5132222403' )
		,( 6, 'Jules', 'Giles', '669 Snake Hill St.', 'Cincinnati', 1, '45012', '5133035113' )
		,( 7, 'Damon', 'Crouse', '7 Brew St.', 'Glendale', 3, '51018', '7708887722' )
		,( 8, 'Von', 'Lemay', '310 Main St.', 'Norwood', 1, '45018', '5136994141' )


INSERT INTO TStatuses ( intStatusID, strStatus )
VALUES	 ( 1, 'Open' )
		,( 2, 'In Process' )
		,( 3, 'Complete' )


INSERT INTO TJobs ( intJobID, intCustomerID, intStatusID, dtmStartDate, dtmEndDate, strJobDesc )
VALUES	 ( 1, 1, 3, '3/31/2020', '5/1/2020', 'Paint all bathrooms in house' )
		,( 2, 1, 2, '3/31/2020', '4/21/2020', 'Check leak behind Master toilet' )
		,( 3, 1, 2, '4/20/2020', '4/21/2020', 'Install new hot water heater' )
		,( 4, 1, 3, '4/20/2020', '4/23/2020', 'Paint basement living room and kitchen' )
		,( 5, 1, 1, '4/20/2020', '4/25/2020', 'Hang sheetrock upstairs hallway and guest bedroom' )
		,( 6, 3, 2, '3/31/2020', '4/21/2020', 'Install new hot water heater' )
		,( 7, 3, 3, '4/20/2020', '4/23/2020', 'Paint basement living room and kitchen' )
		,( 8, 4, 3, '4/20/2020', '4/25/2020', 'Hang sheetrock upstairs hallway and guest bedroom' )
		,( 9, 5, 3, '4/20/2020', '4/27/2020', 'Check plumbing issue in kitchen' )
		,( 10, 6, 2, '5/1/2020', '5/1/2020', 'Replace all existing light fixtures with ceiling fans' )
		,( 11, 7, 1, '4/20/2020', '5/1/2020', 'Inspect air conditioning unit' )
		,( 12, 8, 2, '5/1/2020', '5/1/2020', 'Check leak in basement bathroom' )
		,( 13, 8, 3, '4/20/2020', '4/20/2020', 'Install p-trap under kitchen sink')
		,( 14, 1, 3, '3/31/2020', '4/20/2020', 'Replace all existing light fixtures with ceiling fans' )

INSERT INTO TVendors( intVendorID, strVendorName, strAddress, strCity, intStateID, strZip, strPhoneNumber )
VALUES	 ( 1, 'Wilson Hopkins', '7740 Oxford Ln.', 'Cincinnati', 1, '45042', '5138642063' )
		,( 2, 'Darin Curtis', '880 Peg Dr.', 'Amelia', 1, '45042', '5134142222' )
		,( 3, 'Jeff Johnson', '85 Sutor St.', 'Fairfield', 1, '45012', '5138569333' )
		,( 4, 'Leona Bass', '31 Parker Rd.', 'Cincinnati', 1, '45018', '5135551263' )
		,( 5, 'Jody Garner', '7547 Belmont Rd.', 'Glendale', 3, '51022', '7702221063' )
		,( 6, 'Leslie Morris', '8285 East Lake Ave.', 'Ft. Thomas', 2, '41018', '8595481122' )
		

INSERT INTO TMaterials ( intMaterialID, intVendorID, strDescription, monCost )
VALUES	 ( 1, 6, 'Large Lumber', '$20' )
		,( 2, 6, 'Small Lumber', '$10' )
		,( 3, 4, 'PVC Pipe', '$10' )
		,( 4, 4, 'Liquid Cement', '$5' )
		,( 5, 3, 'Paint', '$50' )
		,( 6, 3, 'Paint Brushes', '$10' )
		,( 7, 1, 'Sheet Rock', '$25' )
		,( 8, 2, 'Freon', '$25' )
		,( 9, 2, 'Air Condition Unit', '$500' )
		,( 10, 5, 'Ceiling Fan', '$150' )


INSERT INTO TJobMaterials ( intJobMaterialID, intJobID, intMaterialID, intQuantity )
VALUES	 ( 1, 1, 5, '3' )
		,( 2, 1, 6, '1' )
		,( 3, 4, 5, '2' )
		,( 4, 5, 7, '4' )
		,( 5, 2, 3, '1' )
		,( 6, 7, 10, '5' )
		,( 7, 8, 9, '1' )
		,( 8, 9, 4, '1' )
		,( 9, 10, 3, '1' )
		,( 10, 11, 2, '1' )
		,( 11, 12, 3, '1' )
		,( 12, 14, 10, '3')
			
 
INSERT INTO TWorkers( intWorkerID, strFirstName, strLastName, strAddress, strCity, intStateID, strZip, strPhoneNumber, dtmHireDate, monHourlyRate ) 
VALUES	 (1, 'Bryant', 'Hampton', '814 Springs Rd.', 'Florence',  2, '41042', '8597601111', '1/5/2010', '$25.00' )
		,(2, 'Jimmy', 'Coleman', '75 Sulfur Dr.',  'Erlanger',  2, '41042', '8597608458', '3/2/2015', '$22.00' )
		,(3, 'Randy', 'Willis', '979 Lilac St.',  'Hebron', 2, '41012', '8597603333', '1/12/2012', '$24.00' )
		,(4, 'Patrick', 'Watkins', '92 New Dr.', 'Walton', 2, '41018', '8592222063', '4/1/2005', '$30.00' )
		,(5, 'Felix', 'Brooks', '7 Bridle St.', 'Cincinnati',  1, '45042', '5134252444', '4/12/2020', '$22.00'  )
		,(6, 'Maria', 'Robes', '29 Sunnyslope Rd.',  'Cincinnati',  1, '45042', '5137412589', '1/25/2010', '$25.00' )
		,(7, 'Jill', 'Gill', '3 Princeton Rd.',  'Fairfield', 1, '45012', '5136932581', '3/31/2007', '$28.00' )
		,(8, 'Brett', 'Soto', '13 Meadow Ln.', 'Amelia', 1, '45018', '5137523188', '1/29/2020', '$21.00' )


	INSERT INTO TJobWorkers ( intJobWorkerID, intJobID, intWorkerID, intHoursWorked )
VALUES	 ( 1, 1, 1, '50' )
		,( 2, 1, 2, '50' )
		,( 3, 1, 3, '50' )
		,( 4, 2, 1, '8' )
		,( 5, 3, 1, '14' )
		,( 6, 3, 6, '14' )
		,( 7, 4, 1, '40' )
		,( 8, 4, 2, '40' )
		,( 9, 5, 4, '40' )
		,( 10, 5, 8, '40' )
		,( 11, 6, 4, '8' )
		,( 12, 7, 7, '20' )
		,( 13, 8, 1, '8' )
		,( 14, 9, 4, '10' )
		,( 15, 10, 4, '4' )


INSERT INTO TSkills ( intSkillID, strSkill, strDescription ) 
VALUES	 (1, 'Carpenter', 'Master' )
		,(2, 'Carpenter', 'Apprentice' )
		,(3, 'Heating and Air Tech', 'Master' )
		,(4, 'Heating and Air Tech', 'Apprentice' )
		,(5, 'Electrician', 'Master' )
		,(6, 'Electrician', 'Apprentice' )
		,(7, 'Painter', 'Master' )
		,(8, 'Painter', 'Apprentice' )
		,(9, 'Plumber', 'Master' )
		,(10, 'Plumber', 'Apprentice' )


INSERT INTO TWorkerSkills( intWorkerSkillID, intWorkerID, intSkillID ) 
VALUES	 (1, 1, 1 )
		,(2, 1, 7 )
		,(3, 2, 7 )
		,(4, 3, 8 )
		,(5, 4, 9 )
		,(6, 5, 3 )
		,(8, 7, 5 )
		,(9, 7, 2 )
		,(10, 8, 1 )
		,(11, 8, 10 )
		,(12, 2, 6 )


-- --------------------------------------------------------------------------------
-- Create SQL to update the address for a specific customer. 
-- Include a select statement before and after the update. 
-- --------------------------------------------------------------------------------
		
SELECT * FROM Tcustomers
UPDATE
	 TCustomers
SET
	 strAddress = '121 Martin Ct.'
	,strCity = 'Norwood'
	,strZip = '45222'
	,intStateID = '1'
WHERE
	 TCustomers.strLastName = 'Frazer'
SELECT * FROM Tcustomers
	 

-- --------------------------------------------------------------------------------
-- Create SQL to increase the hourly rate by $2 for each worker that has 
-- been an employee for at least 1 year. Include a select before and after the update. 
-- Make sure that you have data so that some rows are updated and others are not. 
-- --------------------------------------------------------------------------------

SELECT * FROM TWorkers
UPDATE
	 TWorkers
SET
	 monHourlyRate = monHourlyRate + 2.00
WHERE
	 DATEDIFF(MONTH, dtmHireDate, GETDATE()) > 12;
SELECT * FROM TWorkers


-- --------------------------------------------------------------------------------
-- Create SQL to delete a specific job that has associated work hours 
-- and materials assigned to it. Include a select before and after the statement(s).  
-- --------------------------------------------------------------------------------

SELECT * FROM TJobs
DELETE 
	 TJobs
WHERE
	TJobs.intJobID = 9
SELECT * FROM TJobs


-- --------------------------------------------------------------------------------
-- Write a query to list all jobs that are in process. Include the Job 
-- ID and Description, Customer ID and name, and the start date. Order by the Job ID. 
-- --------------------------------------------------------------------------------

SELECT	 TJ.intJobID AS JobID
		,TJ.strJobDesc AS JobDescription
		,TJ.dtmStartDate AS StartDate
		,TC.intCustomerID AS CustomerID
		,TC.strLastName + ', ' + TC.strFirstName AS CustomerName
FROM
		 TCustomers AS TC LEFT JOIN TJobs AS TJ
			ON TC.intCustomerID = TJ.intCustomerID

		 LEFT JOIN TStatuses AS TS
			ON TS.intStatusID = TJ.intStatusID
WHERE
		 TS.intStatusID = 2
ORDER BY
		 TJ.intJobID
		
	 
-- --------------------------------------------------------------------------------
-- Write a query to list all complete jobs for a specific customer and 
-- the materials used on each job. Include the quantity, unit cost, and total cost 
-- for each material on each job. Order by Job ID and material ID. Note: Select a 
-- customer that has at least 3 complete jobs and at least 1 open job and 1 in process 
-- job. At least one of the complete jobs should have multiple materials. If needed, 
-- go back to your inserts and add data. 
-- --------------------------------------------------------------------------------

SELECT	 TJ.intJobID AS JobID
		,TJ.strJobDesc AS JobDescription
		,TS.strStatus AS JobStatus
		,TJM.intQuantity AS MaterialQuanity
		,TM.intMaterialID AS MaterialID
		,FORMAT(TM.monCost, 'c') AS UnitMaterialCost
		,FORMAT((TJM.intQuantity * TM.monCost), 'c') AS TotalMaterialCost
		,TC.strLastName + ', ' + TC.strFirstName AS CustomerName
		,COUNT(TJ.intCustomerID) AS CustomerIDTotalJobs
FROM
		 TJobMaterials AS TJM LEFT JOIN TJobs AS TJ
			ON TJ.intJobID = TJM.intJobID

		 LEFT JOIN TMaterials AS TM
			ON TM.intMaterialID = TJM.intMaterialID

		 LEFT JOIN TStatuses AS TS
			ON TS.intStatusID = TJ.intStatusID

		 LEFT JOIN TCustomers AS TC
			ON TC.intCustomerID = TJ.intCustomerID
WHERE
		 TS.intStatusID = 3
GROUP BY
		 TJ.intJobID
		,TJ.strJobDesc
		,TJ.intCustomerID
		,TS.strStatus
		,TJM.intQuantity
		,TM.intMaterialID
		,TM.monCost
		,TJM.intQuantity
		,TC.strLastName
		,TC.strFirstName
HAVING
		 TJ.intCustomerID = 1
ORDER BY
		 TJ.intJobID
		,TM.intMaterialID

-- --------------------------------------------------------------------------------
-- This step should use the same customer as in step 4.2. Write a query 
-- to list the total cost for all materials for each completed job for the customer. 
-- Use the data returned in previous step to validate your results. 
-- --------------------------------------------------------------------------------

SELECT	 TJ.intJobID AS JobID
		,TS.strStatus AS JobStatus
		,TC.strLastName + ', ' + TC.strFirstName AS CustomerName
		,FORMAT(SUM(TJM.intQuantity * TM.monCost), 'c') AS MaterialCost 
FROM
		 TJobMaterials AS TJM LEFT JOIN TJobs AS TJ
			ON TJ.intJobID = TJM.intJobID

		 LEFT JOIN TMaterials AS TM
			ON TM.intMaterialID = TJM.intMaterialID

		 LEFT JOIN TStatuses AS TS
			ON TS.intStatusID = TJ.intStatusID

		 LEFT JOIN TCustomers AS TC
			ON TC.intCustomerID = TJ.intCustomerID
WHERE
		 TJ.intCustomerID = 1
			AND TS.intStatusID = 3
GROUP BY
		 TJ.intJobID 
		,TS.strStatus 
		,TC.strLastName 
		,TC.strFirstName 
ORDER BY
		 TJ.intJobID
		

-- --------------------------------------------------------------------------------
-- Write a query to list all jobs that have work entered for them. 
-- Include the job ID, job description, and job status description. List the total 
-- hours worked for each job with the lowest, highest, and average hourly rate. Make 
-- sure that your data includes at least one job that does not have hours logged. 
-- This job should not be included in the query. Order by highest to lowest average 
-- hourly rate. 
-- --------------------------------------------------------------------------------

SELECT	 TJ.intJobID AS JobID, TJ.strJobDesc AS JobDescription
		,TS.strStatus AS JobStatus
		,COUNT(TJW.intWorkerID) * TJW.intHoursWorked AS TotalJobHours
		,FORMAT(MIN(TW.monHourlyRate), 'c') AS LowHourlyRate
		,FORMAT(MAX(TW.monHourlyRate), 'c') AS HighHourlyRate
		,FORMAT(AVG(TW.monHourlyRate), 'c') AS AverageHourlyRate
FROM
		 TWorkers AS TW LEFT JOIN TJobWorkers AS TJW
			ON TW.intWorkerID = TJW.intWorkerID

		 LEFT JOIN TJobs AS TJ
			ON TJ.intJobID = TJW.intJobID

		 LEFT JOIN TStatuses AS TS
			ON TS.intStatusID = TJ.intStatusID 
WHERE
		 TJW.intHoursWorked > 0
GROUP BY
		 TJ.intJobID
		,TJ.strJobDesc
		,TS.strStatus
		,TJW.intHoursWorked
ORDER BY 
		 AVG(TW.monHourlyRate) DESC

 

-- --------------------------------------------------------------------------------
-- Write a query that lists all materials that have not been used on 
-- any jobs. Include Material ID and Description. Order by Material ID. 
-- --------------------------------------------------------------------------------

SELECT	 TM.intMaterialID AS MaterialID
		,TM.strDescription AS Material													
FROM
		 TMaterials AS TM
WHERE
		 TM.intMaterialID NOT IN (SELECT TM.intMaterialID
									FROM TMaterials AS TM JOIN TJobMaterials AS TJM
										ON TM.intMaterialID = TJM.intMaterialID)


-- --------------------------------------------------------------------------------
-- Create a query that lists all workers that worked greater than 20 
-- hours for all jobs that they worked on. Include the Worker ID and name, number 
-- of hours worked, and number of jobs that they worked on. Order by Worker ID. 
-- --------------------------------------------------------------------------------

SELECT	 TW.intWorkerID AS WorkerID, TW.strLastName + ', ' + TW.strFirstName AS Name
		,COUNT(TJW.intWorkerID) AS JobsWorked 
		,ISNULL(SUM(TJW.intHoursWorked), 0) AS TotalHoursWorked

FROM
		 TWorkers AS TW LEFT JOIN TJobWorkers AS TJW
			ON TW.intWorkerID = TJW.intWorkerID

		 LEFT JOIN TJobs AS TJ
			ON TJ.intJobID = TJW.intJobID
GROUP BY
		 TW.intWorkerID
		,TW.strLastName
		,TW.strFirstName
HAVING
		 SUM(TJW.intHoursWorked)> 20

		

-- --------------------------------------------------------------------------------
-- Create a view that includes the labor costs associated with each 
-- job. Include Customer ID and Name. 
-- --------------------------------------------------------------------------------

GO

CREATE VIEW vJobLaborCosts
AS
SELECT	 TJ.intJobID AS JobID, TJ.strJobDesc AS JobDescription
		,TC.intCustomerID AS CustomerID, TC.strLastName + ', ' + TC.strFirstName AS CustomerName
		,ISNULL(SUM(TW.monHourlyRate * TJW.intHoursWorked), 0) AS LaborCost
FROM
		 TJobs AS TJ LEFT JOIN TJobWorkers AS TJW
			ON TJ.intJobID = TJW.intJobID

		 LEFT JOIN TCustomers AS TC
			ON TC.intCustomerID = TJ.intCustomerID

		 LEFT JOIN TWorkers AS TW
			ON TW.intWorkerID = TJW.intWorkerID
GROUP BY 
		 TJ.intJobID
		,TJ.strJobDesc
		,TC.intCustomerID
		,TC.strLastName
		,TC.strFirstName

GO

SELECT * FROM vJobLaborCosts


-- --------------------------------------------------------------------------------
-- Use the View created to write a query that includes the total 
-- labor cost for each customer. Order by Customer ID. 
-- --------------------------------------------------------------------------------

SELECT	 vJobLaborCosts.CustomerID
		,vJobLaborCosts.CustomerName
		,vJobLaborCosts.JobID						
		,vJobLaborCosts.JobDescription
		,FORMAT(ISNULL(SUM(vJobLaborCosts.LaborCost), 0), 'c') AS LaborCost
FROM
		 vJobLaborCosts
GROUP BY
		 vJobLaborCosts.CustomerID
		,vJobLaborCosts.CustomerName
		,vJobLaborCosts.JobID
		,vJobLaborCosts.JobDescription
ORDER BY
		 vJobLaborCosts.CustomerID

			
-- --------------------------------------------------------------------------------
-- Write a query that lists all customers who are located on 'Main Street'. 
-- Include the customer Id and full address. Order by Customer ID. Make sure that you 
-- have at least three customers on 'Main Street' each with different house numbers. 
-- Make sure that you also have customers that are not on 'Main Street'. 
-- --------------------------------------------------------------------------------

SELECT 	 TC.intCustomerID AS CustomerID
		,TC.strAddress AS StreetAddress  
		,TC.strCity AS City
		,TS.strStateDesc AS State
		,TC.strZip AS ZipCode
FROM
		 TStates AS TS JOIN TCustomers AS TC
			ON TS.intStateID = TC.intStateID
WHERE
		 TC.strAddress LIKE '%Main St.%' 									
ORDER BY 
		 TC.intCustomerID


-- --------------------------------------------------------------------------------
-- Write a query to list completed jobs that started and ended in the 
-- same month. List Job, Job Status, Start Date and End Date. 
-- --------------------------------------------------------------------------------

SELECT	 TJ.intJobID AS JobID
		,TS.strStatus AS JobStatus
		,TJ.dtmStartDate AS StartDate
		,TJ.dtmEndDate AS EndDate
FROM	 
		 TStatuses AS TS JOIN TJOBS AS TJ
			ON TS.intStatusID = TJ.intStatusID
WHERE
		 DATEPART(MONTH, TJ.dtmStartDate) = DATEPART(MONTH, TJ.dtmEndDate) 

-- --------------------------------------------------------------------------------
-- Create a query to list workers that worked on three or more jobs 
-- for the same customer. 
-- --------------------------------------------------------------------------------

Select	 TW.intWorkerID AS WorkerID
		,TW.strLastName + ', ' + TW.strFirstName AS WorkerName
		,TJ.intCustomerID AS CustomerID
		,TC.strLastName + ', ' + TC.strFirstName AS CustomerName
		,COUNT(TJW.intWorkerID) AS WorkedJobs
FROM	 
		 TJobs AS TJ LEFT JOIN TJobWorkers AS TJW
			ON TJ.intJobID = TJW.intJobID

		 LEFT JOIN TWorkers AS TW
			ON TW.intWorkerID = TJW.intWorkerID

		 LEFT JOIN TCustomers AS TC
			ON TC.intCustomerID = TJ.intCustomerID
GROUP BY
		 TW.intWorkerID
		,TW.strLastName
		,TW.strFirstName
		,TJ.intCustomerID
		,TC.strLastName
		,TC.strFirstName
		,TJW.intWorkerID
HAVING
		 COUNT(TJW.intWorkerID) >= 3
		


-- --------------------------------------------------------------------------------
-- Create a query to list all workers and their total # of skills. Make 
-- sure that you have workers that have multiple skills and that you have at least 1 
-- worker with no skills. The worker with no skills should be included with a total 
-- number of skills = 0. Order by Worker ID. 
-- --------------------------------------------------------------------------------
 
SELECT	 TW.intWorkerID AS WorkerID
		,TW.strLastName + ', ' + TW.strFirstName AS WorkerName
		,ISNULL(COUNT(TWS.intSkillID), 0) AS Skills
		,ISNULL(TS.intSkillID, 0) AS SkillID
		,ISNULL(TS.strSkill, 'N/A') AS Skill
		,ISNULL(TS.strDescription, 'N/A') AS SkillLevel 
FROM
		 TWorkers AS TW LEFT JOIN TWorkerSkills AS TWS
			ON TW.intWorkerID = TWS.intWorkerID

		 LEFT JOIN TSkills AS TS
			ON TS.intSkillID = TWS.intSkillID
GROUP BY
		 TW.intWorkerID
		,TW.strLastName
		,TW.strFirstName
		,TWS.intSkillID
		,TS.intSkillID
		,TS.strSkill
		,TS.strDescription
ORDER BY
		 TW.intWorkerID



-- --------------------------------------------------------------------------------
-- Write a query to list the total Charge to the customer for each job. 
-- Calculate the total charge to the customer as the total cost of materials + total 
-- Labor costs + 30% Profit. 
-- --------------------------------------------------------------------------------

SELECT	 TJ.intJobID AS JobID
		,FORMAT((ISNULL(SUM(TM.monCost * TJM.intQuantity), 0) + ISNULL(SUM(TW.monHourlyRate * TJW.intHoursWorked), 0)) * (1 + .30), 'c') AS TotalCustomerCharge
		,TC.intCustomerID, TC.strLastName + ', ' + TC.strFirstName AS CustomerName
FROM
		 TJobs AS TJ LEFT JOIN TJobMaterials AS TJM
			ON TJ.intJobID = TJM.intJobID

		 LEFT JOIN TMaterials AS TM
			ON TM.intMaterialID = TJM.intMaterialID

		 LEFT JOIN TJobWorkers AS TJW
			ON TJ.intJobID = TJW.intJobID

		 LEFT JOIN TWorkers AS TW
			ON TW.intWorkerID = TJW.intWorkerID

		 LEFT JOIN TCustomers AS TC
			ON TC.intCustomerID = TJ.intCustomerID
GROUP BY
		 TJ.intJobID
		,TC.intCustomerID
		,TC.strLastName
		,TC.strFirstName 
ORDER BY 
		 TJ.intJobID



-- --------------------------------------------------------------------------------
-- Write a query that totals what is owed to each vendor for a particular 
-- job. 
-- --------------------------------------------------------------------------------
 
SELECT	 TV.intVendorID AS VendorID
        ,ISNULL(CAST(TJ.intJobID AS VARCHAR), 'N/A') AS JobID		
		,ISNULL(TJ.strJobDesc, 'N/A') AS JobDescription
		,FORMAT(ISNULL(SUM(TM.monCost * TJM.intQuantity), 0), 'c') VendorCost
FROM
		 TVendors AS TV LEFT JOIN TMaterials AS TM
			ON TV.intVendorID = TM.intVendorID

		 LEFT JOIN TJobMaterials AS TJM
			ON TM.intMaterialID = TJM.intMaterialID

		 LEFT JOIN TJobs AS TJ
			ON TJ.intJobID = TJM.intJobID
GROUP BY
		 TV.intVendorID
		,TJ.intJobID
		,TJ.strJobDesc
ORDER BY
		 TV.intVendorID