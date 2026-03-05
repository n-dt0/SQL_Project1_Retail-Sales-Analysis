----SQLProject1--
----_retail_sales_analysis----

CREATE DATABASE SQL_Project_1
GO
---very important to use corrct name otherwise the table will be created in the master data
USE SQL_Project_1

ALTER DATABASE [SQL_Project_1] MODIFY NAME = SQL_Project1_RetailSales

USE SQL_Project1_RetailSales
--how to import csv or any flat file into SSMS (add this step in project discription)
--create table retail_sales (we do not need to create table we can directly import file & table will be created)
---below table is just to make sure we use correct data types_change data types while importing data into sql)
--we use below datatypes 

/*CREATE TABLE dbo.retail_sales
(
transactions_id	int not null primary key,
sale_date	date,
sale_time	time(7),
customer_id	int,
gender	varchar(50),
age	 int,
category varchar(50),	
quantiy	int,
price_per_unit	float,
cogs	float,
total_sale float
)
*/
SELECT * FROM [dbo].[retail_sales_]

SELECT COUNT(*) FROM [dbo].[retail_sales_]
--- ALTER query written to change the data type for sale_time
ALTER TABLE [dbo].[retail_sales_]
ALTER COLUMN [sale_time] TIME;

SELECT * FROM [dbo].[retail_sales_]
WHERE [transactions_id] IS NULL;

SELECT * FROM [dbo].[retail_sales_]
WHERE sale_date IS NULL;


SELECT * FROM [dbo].[retail_sales_]
WHERE
	([transactions_id] IS NULL
	OR
	[sale_date] IS NULL
	OR
	[sale_time] IS NULL
	OR
	[customer_id] IS NULL
	OR
	gender IS NULL
	OR 
	[age]IS NULL
	OR
	[category] IS NULL
	OR
	[quantiy] IS NULL 
	OR
	[price_per_unit] IS NULL
	OR
	[cogs] IS NULL
	OR
	[total_sale] IS NULL
	);

	DELETE FROM [dbo].[retail_sales_]
WHERE
	([transactions_id] IS NULL
	OR
	[sale_date] IS NULL
	OR
	[sale_time] IS NULL
	OR
	[customer_id] IS NULL
	OR
	gender IS NULL
	OR 
	[age]IS NULL
	OR
	[category] IS NULL
	OR
	[quantiy] IS NULL 
	OR
	[price_per_unit] IS NULL
	OR
	[cogs] IS NULL
	OR
	[total_sale] IS NULL
	);

	SELECT COUNT(*) FROM [dbo].[retail_sales_]

--1.	Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM [dbo].[retail_sales_]
WHERE [sale_date] = '2022-11-05';

--2.	Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 4 in the month of Nov-2022:
SELECT * FROM [dbo].[retail_sales_]
WHERE [category] = 'Clothing' AND [quantiy] >= 4 AND YEAR([sale_date]) = '2022' AND MONTH(sale_date) = '11';


--3.	Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category , SUM([total_sale]) AS total_sales, COUNT(*) AS total_order FROM [dbo].[retail_sales_]
GROUP BY [category];

--4.	Write a SQL query to find the average age of customers who purchased items 
--from the 'Beauty' category.:

SELECT AVG(age) AS avg_age FROM [dbo].[retail_sales_]
WHERE category= 'Beauty';

--5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * FROM [dbo].[retail_sales_] 
WHERE [total_sale] > 1000;

--6.Write a SQL query to find the total number of transactions (transaction_id) 
--made by each gender in each category.:
SELECT COUNT([transactions_id]) AS total_no_of_transactions, gender, category FROM [dbo].[retail_sales_]
GROUP BY gender, category;

--7.	Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year:
--- we use commmontable expression 
WITH monthly_sales AS (
	SELECT YEAR([sale_date]) sale_year, MONTH([sale_date]) AS sale_month, AVG([total_sale]) AS avg_sales,  
		   RANK()OVER(PARTITION BY YEAR([sale_date]) ORDER BY AVG([total_sale])DESC
		   ) AS _rank
	FROM [dbo].[retail_sales_]
	GROUP BY 
		YEAR([sale_date]) ,
		MONTH([sale_date])
)
SELECT 
	sale_year,
	sale_month,
	avg_sales
FROM monthly_sales
WHERE 
	_rank = 1
ORDER BY 
	sale_year;

--8.	**Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT TOP 5 customer_id AS top5_customer, SUM([total_sale]) AS total_sales
FROM [dbo].[retail_sales_]
GROUP BY customer_id
ORDER BY total_sales DESC;

--9.	Write a SQL query to find the number of unique customers 
--who purchased items from each category.:

SELECT COUNT(DISTINCT([customer_id])) AS _unique_customers_count, [category]
FROM [dbo].[retail_sales_]
GROUP BY [category];

--10.	Write a SQL query to create each shift and number of orders 
--(Example Morning <12, Afternoon Between 12 & 17, Evening >17):
--each = ORDER BY, no_of_orders = COUNT, GROUP BY , need to create shift with CASE , use CTE to create CASE WHEN 

WITH an_hourly_Sale AS(
	SELECT *, 
		CASE WHEN DATEPART(hour,[sale_time]) < 12 THEN 'Morning'
			  WHEN DATEPART(hour, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		      ELSE'Evening'
		END AS _shift_time
	FROM [dbo].[retail_sales_]
)	
SELECT _shift_time, COUNT(*) AS total_orders
FROM an_hourly_Sale
GROUP BY _shift_time
ORDER BY CASE _shift_time
        WHEN 'Morning' THEN 1
        WHEN 'Afternoon' THEN 2
        WHEN 'Evening' THEN 3
    END;