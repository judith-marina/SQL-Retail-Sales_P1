CREATE TABLE retail_sales
 (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

Select * FROM retail_sales
LIMIT 30;

--Data Cleaning
SELECT COUNT(*)
       FROM retail_sales;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

--Data Exploration
--How many sales do we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

--How many unique customer_ids are there?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

--How many categories are there?
SELECT DISTINCT category FROM retail_sales;


--Data Analysis

--To retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4

--calculate the total sales (total_sale) for each category
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

--find the average age of customers who purchased items from the 'Beauty' category
SELECT
    ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

--find all transactions where the total_sale is greater than 1000
SELECT * FROM retail_sales
WHERE total_sale > 1000;

--find the total number of transactions (transaction_id) made by each gender in each category
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1;

--calculate the average sale for each month. Find out best selling month in each year

SELECT 
      year, month, avg_sale
FROM
(
SELECT 
  EXTRACT(YEAR FROM sale_date) as year,
  EXTRACT(MONTH FROM sale_date) as month,
  AVG(total_sale) as avg_sale,
  RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
  GROUP BY 1,2
  ) as t1
WHERE rank=1;  
--ORDER   BY 1,3 DESC;

-- find the top 5 customers based on the highest total sales
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--find the number of unique customers who purchased items from each category
SELECT 
    category, 
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

 --create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

--SELECT EXTRACT(HOUR FROM CURRENT_TIME);

WITH Hourly_sale
AS
(
SELECT *,
    CASE
	    WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
    FROM retail_sales
)
SELECT shift,
       COUNT(*) AS total_orders
	   FROM Hourly_sale
	   GROUP BY shift;

--END OF PROJECT