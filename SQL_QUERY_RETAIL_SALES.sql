--SQL_RETAIL DATA ANALYSIS P0
CREATE DATABASE sql_project_p1
--CREATE A TABLE
CREATE TABLE retail_sales_table(
        transactions_id	INT PRIMARY KEY,
        sale_date DATE,	
        sale_time TIME,	
        customer_id	INT,
        gender	VARCHAR(15),
        age	INT,
		category VARCHAR(15),	
        quantiy	VARCHAR(15),
        price_per_unit FLOAT,
        cogs FLOAT,
        total_sale FLOAT
);
SELECT 
      COUNT(*)
FROM retail_sales_table

SELECT * FROM retail_sales_table
--Change column name from quantiy to quantity
ALTER TABLE retail_sales_table
RENAME COLUMN quantiy TO quantity;

--Data Cleaning
SELECT * FROM retail_sales_table
WHERE 
    transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
DELETE FROM retail_sales_table
WHERE 
    transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
--Data Exploration

--How Many Sales are there.
SELECT COUNT(*) AS total_sale FROM retail_sales_table

--How many customers are there.
SELECT COUNT(*) AS customer_id FROM retail_sales_table

--How many  unique customers are there.
SELECT COUNT(DISTINCT customer_id ) FROM retail_sales_table

--What are the unique categories of items purchased
SELECT DISTINCT category  FROM retail_sales_table

--Data Analysis, problem and answers
--Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales_table
WHERE SALE_DATE = '2022-11-05'

--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
FROM retail_sales_table
WHERE category = 'Clothing'
     AND 
      TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
     AND 
	 CAST(quantity AS INTEGER) >= 4;

--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT
      category,
	  SUM(total_sale) AS net_sale
FROM retail_sales_table 
GROUP BY 1;

--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 
     ROUND (AVG(age),2) AS avg_age
FROM retail_sales_table
WHERE category = 'Beauty';

--Q.5 Write a SQL query to find all transactions and category where the total_sale is greater than 1000.:
SELECT 
     transactions_id, category, total_sale
FROM retail_sales_table
WHERE total_sale > 1000

--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT gender,
      COUNT(*)AS total_transactions
FROM retail_sales_table
GROUP BY 1;

--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT 
     year,
	 month,
	 avg_sale

FROM 
(
SELECT 
       EXTRACT(YEAR FROM sale_date) AS year,
       EXTRACT(MONTH FROM sale_date) AS month,
       AVG(total_sale) AS avg_sale,
	   RANK()OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC )AS RANK
FROM retail_sales_table
GROUP BY 1,2)
            AS t1
			WHERE RANK=1


--ORDER BY 1,3 DESC

--Q.8  Write a SQL query to find the top 5 customers based on the highest total sales **:


SELECT 
       customer_id,
       SUM (total_sale) AS total_sales_per_customer
FROM retail_sales_table
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q.9  Write a SQL query to find the number of unique customers who purchased items from each category
SELECT 
     category,
	 COUNT(DISTINCT customer_id) AS cnt_unique_customers
FROM retail_sales_table
GROUP BY category

--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale
AS
(
SELECT *,
       CASE
	       WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		   WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17  THEN 'Afternoon'
		   ELSE 'Evening'
	   END AS shift 
FROM retail_sales_table)
SELECT 
      shift,   
	  COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

--END OF THE PROJECT
