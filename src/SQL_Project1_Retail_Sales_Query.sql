----SQLProject1--
----_retail_sales_analysis----

Create database SQL_Project_1
go
---very important to use corrct name otherwise the table will be created in the master data
use SQL_Project_1

Alter database [SQL_Project_1] Modify Name = SQL_Project1_RetailSales

use SQL_Project1_RetailSales
--how to import csv or any flat file into SSMS (add this step in project discription)
--create table retail_sales (we do not need to create table we can directly import file & table will be created)
---below table is just to make sure we use correct data types_change data types while importing data into sql)
--we use below datatypes 

/*Create Table dbo.retail_sales
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
select * from [dbo].[retail_sales_]

SELECT COUNT(*) FROM [dbo].[retail_sales_]
--- alter query written to change the data type for sale_time
alter table [dbo].[retail_sales_]
alter column [sale_time] time;

select * from [dbo].[retail_sales_]
where [transactions_id] is null;

select * from [dbo].[retail_sales_]
where sale_date is null;


SELECT * FROM [dbo].[retail_sales_]
WHERE
	([transactions_id] is null
	or
	[sale_date] is null
	or
	[sale_time] is null
	or
	[customer_id] is null
	or
	gender is null
	or 
	[age]is null
	or
	[category] is null
	or
	[quantiy] is null 
	or
	[price_per_unit] is null
	or
	[cogs] is null
	or
	[total_sale] is null
	);

	DELETE FROM [dbo].[retail_sales_]
WHERE
	([transactions_id] is null
	or
	[sale_date] is null
	or
	[sale_time] is null
	or
	[customer_id] is null
	or
	gender is null
	or 
	[age]is null
	or
	[category] is null
	or
	[quantiy] is null 
	or
	[price_per_unit] is null
	or
	[cogs] is null
	or
	[total_sale] is null
	);

	SELECT COUNT(*) FROM [dbo].[retail_sales_]

--1.	Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM [dbo].[retail_sales_]
WHERE [sale_date] = '2022-11-05';

--2.	Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 4 in the month of Nov-2022:
SELECT * FROM [dbo].[retail_sales_]
WHERE [category] = 'Clothing' AND [quantiy] >= 4 and year([sale_date]) = '2022' AND month(sale_date) = '11';


--3.	Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category , sum([total_sale]) as total_sales, count(*) as total_order FROM [dbo].[retail_sales_]
group by [category];

--4.	Write a SQL query to find the average age of customers who purchased items 
--from the 'Beauty' category.:

SELECT avg(age) as avg_age FROM [dbo].[retail_sales_]
WHERE category= 'Beauty';

--5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * from [dbo].[retail_sales_] 
WHERE [total_sale] > 1000;

--6.Write a SQL query to find the total number of transactions (transaction_id) 
--made by each gender in each category.:
SELECT count([transactions_id]) as total_no_of_transactions, gender, category FROM [dbo].[retail_sales_]
Group by gender, category;

--7.	Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year:
--- we use commmontable expression 
with monthly_sales as (
	Select Year([sale_date]) sale_year, month([sale_date]) as sale_month, avg([total_sale]) as avg_sales,  
		   rank()over(partition by Year([sale_date]) Order by avg([total_sale])DESC
		   ) as _rank
	from [dbo].[retail_sales_]
	group by 
		Year([sale_date]) ,
		month([sale_date])
)
Select 
	sale_year,
	sale_month,
	avg_sales
FROM monthly_sales
Where 
	_rank = 1
Order by 
	sale_year;

--8.	**Write a SQL query to find the top 5 customers based on the highest total sales **:

Select top 5 customer_id as top5_customer, sum([total_sale]) as total_sales
from [dbo].[retail_sales_]
group by customer_id
order by total_sales desc;

--9.	Write a SQL query to find the number of unique customers 
--who purchased items from each category.:

Select count(distinct([customer_id])) as _unique_customers_count, [category]
From [dbo].[retail_sales_]
group by [category];

--10.	Write a SQL query to create each shift and number of orders 
--(Example Morning <12, Afternoon Between 12 & 17, Evening >17):
--each = order by, no_of_orders = count, group by , need to create shift with CASE , use CTE to create CASE WHEN 

With an_hourly_Sale AS(
	Select *, 
		CASE When datepart(hour,[sale_time]) < 12 Then 'Morning'
			  When datepart(hour, sale_time) between 12 AND 17 Then 'Afternoon'
		      Else'Evening'
		END as _shift_time
	from [dbo].[retail_sales_]
)	
Select _shift_time, count(*) as total_orders
FROM an_hourly_Sale
Group by _shift_time
Order by CASE _shift_time
        WHEN 'Morning' THEN 1
        WHEN 'Afternoon' THEN 2
        WHEN 'Evening' THEN 3
    END;