USE amazon_sales;
SELECT * FROM amazon_sales.amazon_sales_raw_data;

-- Check duplicate values
SELECT `Order ID`, COUNT(*) 
FROM amazon_sales_raw_data
GROUP BY `Order ID` 
HAVING COUNT(*) > 1;

-- checking missing values
SELECT * FROM amazon_sales_raw_data WHERE Category = '';
SELECT * FROM amazon_sales_raw_data WHERE `Customer Name` = '';
SELECT * FROM amazon_sales_raw_data WHERE `Payment Method` = '';

-- Mode of payment method
SELECT `Payment Method`, COUNT(*) AS count 
FROM amazon_sales_raw_data 
GROUP BY `Payment Method`;

-- Unique payment methods
SELECT DISTINCT `Payment Method` FROM amazon_sales_raw_data;

-- To update data
SET SQL_SAFE_UPDATES = 0;

-- Cleaning missing values
UPDATE amazon_sales_raw_data SET `Payment Method` = 'COD' WHERE `Payment Method` = '';
UPDATE amazon_sales_raw_data SET `Customer Name` = 'Unknown' WHERE `Customer Name` = '';
UPDATE amazon_sales_raw_data SET Category = 'Unknown' WHERE Category = '';

-- Fixing wrong payment method 
UPDATE amazon_sales_raw_data SET `Payment Method` = 'COD' WHERE LOWER(`Payment Method`) = 'cod';
UPDATE amazon_sales_raw_data SET `Payment Method` = 'UPI' WHERE LOWER(`Payment Method`) = 'upi';
UPDATE amazon_sales_raw_data SET `Payment Method` = 'Debit Card' WHERE LOWER(`Payment Method`) IN ('debit card', 'debitcard');

-- New Order_Date column
ALTER TABLE amazon_sales_raw_data ADD Order_Date DATE;

-- Convert data type of Order_Date column
UPDATE amazon_sales_raw_data
SET Order_Date = STR_TO_DATE(TRIM(`Order Date`), '%Y-%m-%d');
-- Droping old Order Date column
ALTER TABLE amazon_sales_raw_data DROP COLUMN `Order Date`;

SET SQL_SAFE_UPDATES = 1;

SHOW COLUMNS FROM amazon_sales_raw_data;

