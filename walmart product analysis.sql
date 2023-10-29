-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

-- Create table
use walmartsales;
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct double(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct double(11,9),
    gross_income DECIMAL(12, 4),
    rating double(2, 1)
);

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);


-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);


/* 1.How many unique product lines does the data have?*/

select distinct count(product_line) ,product_line 
from sales
group by product_line;

/* 2.What is the most common payment method?*/
select distinct count(payment),payment 
from sales
group by payment
order by count(payment) DESC;

/*3.What is the most selling product line?*/
SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;

/*4.What is the total revenue by month?*/
select 
sum(total) as total_revenue,month_name from sales
group by month_name
order by total_revenue DESC;

/*5.Which month has largest COGS*/
SELECT
	month_name,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs,month_name DESC;

-- 6.What product line had the largest revenue?
SELECT
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- 7.What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;


-- 8.What product line had the largest VAT?
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;


-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


-- 10.Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- 11.What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- 12.What is the average rating of each product line
SELECT
	product_line,ROUND(AVG(rating), 2) as avg_rating
    FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;









