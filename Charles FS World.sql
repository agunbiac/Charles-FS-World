-- CHARLES FS WORLD PROJECT

-- CREATE TABLES
DROP TABLE Current_Account

CREATE TABLE Current_Account (ID int, Balance DECIMAL (10,2));
CREATE TABLE Customer_Data (ID int, First_Name varchar (255), Last_Name varchar (255), Contact_No varchar (255), Email varchar (255), Cust_Address varchar (255) );


BULK INSERT Savings_Account
FROM 'C:\Users\CA\Documents\Charles FS World\Savings Account Data.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
TABLOCK
);

BULK INSERT Current_Account
FROM 'C:\Users\CA\Documents\Charles FS World\Current Account Data.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
TABLOCK
);

BULK INSERT Customer_Data
FROM 'C:\Users\CA\Documents\Charles FS World\Customer Data.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
TABLOCK
);



SELECT *
FROM Savings_Account

SELECT *
FROM Current_Account

SELECT *
FROM Customer_Data

CREATE TABLE Customer_Transaction_Hist (ID int, Amount decimal (10,2), Account_Type varchar (255), Trans_Description varchar(255), Amt_date datetime)
DROP TABLE Customer_Transaction_Hist


SELECT * 
FROM Customer_Transaction_Hist
WHERE ID = 10089

-- CREATE TRANSACTIONS MANUALLY

INSERT INTO Customer_Transaction_Hist  (ID, Amount, Account_Type, Trans_Description, Amt_date)
VALUES (10089,-36,'Current Account', 'TESCO', '07/22/2025')
--,(10011,200,'Savings Account', 'DEPOSIT', '05/27/2025')
--,(10011,-150,'Current Account', 'WITHDRAWAL', '05/30/2025')


-- CREATE TEMP TABLE FOR TRANSACTION PROCESSING

DROP TABLE #Customer_Transaction
CREATE TABLE #Customer_Transaction (ID int, Amount decimal (10,2), Account_Type varchar (255))

INSERT INTO #Customer_Transaction
SELECT  ID, sum(Amount) as 'Amount', Account_Type
FROM Customer_Transaction_Hist
WHERE 
Amt_date > '07/21/2025'
--and Trans_Description = 'TESCO'
--Amt_ID = ''
GROUP BY  ID, Account_Type

SELECT * 
FROM #Customer_Transaction


-- COMMIT / REVIEW TRANSACTION PROCESSING (SAVINGS/CURRENT)

-- SAVINGS ACCOUNT
BEGIN TRANSACTION
UPDATE Savings_Account 
SET Savings_Account.Balance = Savings_Account.Balance + #Customer_Transaction.Amount 
FROM Savings_Account, #Customer_Transaction
WHERE Savings_Account.ID = #Customer_Transaction.ID
AND Account_Type = 'Savings Account'
COMMIT;
ROLLBACK;

-- CURRENT ACCOUNT
BEGIN TRANSACTION
UPDATE Current_Account 
SET Current_Account.Balance = Current_Account.Balance + #Customer_Transaction.Amount 
FROM Current_Account, #Customer_Transaction
WHERE Current_Account.ID = #Customer_Transaction.ID
AND Account_Type = 'Current Account'
COMMIT;
ROLLBACK;


-- REVIEW ALL RECORDS

SELECT Customer_Data.ID, First_Name, Last_Name, Current_Account.Balance as 'Current Account Balance', Savings_Account.Balance as 'Savings Account Balance'
From Customer_Data
LEFT JOIN Current_Account 
ON Current_Account.ID = Customer_Data.ID
LEFT JOIN Savings_Account
ON Savings_Account.ID = Customer_Data.ID;




-- MISC
SELECT Customer_Data.ID, First_Name, Last_Name, Current_Account.Balance as 'Current Account Balance', Savings_Account.Balance as 'Savings Account Balance'
From Customer_Data
LEFT JOIN Current_Account 
ON Current_Account.ID = Customer_Data.ID
LEFT JOIN Savings_Account
ON Savings_Account.ID = Customer_Data.ID
WHERE Customer_Data.ID IN (SELECT ID
                 FROM Current_Account
                 WHERE First_Name = 'Aretha');



-- Transaction Create

CREATE TABLE Customer_Transaction_Hist (ID int, Amount decimal (10,2), Account_Type varchar (255), Trans_Description varchar(255), Amt_date datetime)
DROP TABLE Customer_Transaction_Hist


SELECT * 
FROM Customer_Transaction_Hist

BULK INSERT Customer_Transaction_Hist
FROM 'C:\Users\CA\Documents\Charles FS World\Transaction History Load.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n',
TABLOCK
);

