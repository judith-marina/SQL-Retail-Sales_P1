# SQL Project- Retail Sales Analytics

## Project Overview

- **Project Title**: Retail Sales Analytics
- **Database**: `sql_project_p1` 

This project focuses on building a comprehensive retail sales database to derive meaningful business insights. Using SQL, the sales data was structured, cleaned, and analyzed to address critical business questions. The project involved performing exploratory data analysis (EDA) identifying patterns in sales performance, customer behavior and product trends. The findings are aimed at enhancing decision-making and driving data-informed strategies for the retail business. 

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: Create a database named `sql_project_p1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project_p1;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```

## Findings

**Sales Analysis**: 
- Sales data for specific dates (e.g., 2022-11-05) revealed daily performance.
- High-value transactions (above 1000) indicated premium or bulk purchases.

 **Product Category Insights**:
- Categories such as Clothing and Beauty showed significant trends.
- Clothing saw high sales volumes in November.
- The average age of customers in the Beauty category was approximately 30-35 years.

**Top Customers**:
- The top 5 customers contributed significantly to total sales, showcasing customer concentration.

**Shift-based Performance**:
- Morning, afternoon, and evening shifts had distinct order volumes, with Afternoon showing the highest engagement.

**Customer Behavior**:
- Gender-based sales analysis revealed transaction patterns, enabling targeted marketing strategies.
- The number of unique customers per category highlighted category popularity.

**Monthly Trends**:
- The best-performing months in each year were identified, helping forecast seasonal trends.

## Reports

- **Sales by Category**: Identified the total sales and order volumes for each product category, highlighting high-performing categories.
- **Top Customers**: Ranked customers by their total purchases to identify top contributors to revenue.
- **Shift Performance**: Analyzed order volumes across different times of the day (morning, afternoon, evening) to determine peak business hours.
- **Unique Customers by Category**: Assessed customer diversity and popularity for each category.

## Conclusion

The retail sales analysis offered comprehensive insights into operational performance, customer behavior, and product trends. High-performing categories, such as Clothing and Electronics, were identified as key revenue drivers, while customer segmentation revealed distinct preferences by age and gender, particularly for categories like Beauty. Shift-based analysis highlighted peak sales periods during the afternoon, helping to pinpoint optimal times for engagement. Additionally, unique customer counts and high-value transactions underscored the significance of targeting both repeat and premium buyers. Seasonal trends, revealed through monthly sales analysis, further emphasized the importance of aligning strategies with customer demand cycles. Together, these findings provide a robust foundation for optimizing sales and enhancing business outcomes.

## Author - Judith Marina

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. I developed this project by following Zero Analyst. I learned how to create and manage databases, clean data, and perform exploratory data analysis. By applying these skills to real-world data, I was able to generate business insights, which deepened my understanding of data-driven decision-making. This experience has not only strengthened my SQL proficiency but also demonstrated my ability to independently learn and apply technical skills to solve business problems.

To connect with me,
- Email: judithmf04@gmail.com
- LinkedIn: https://www.linkedin.com/in/judith-marina-8b4410246/
