CREATE DATABASE IF NOT EXISTS WalmartSalesData;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

--------------------------------------------------- Attribute Engineering--------------------------------------------------
-- Time_of_Day 
SELECT
	time ,
    (CASE
    WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
    END) AS transaction_time
FROM sales; 

    ALTER TABLE sales ADD COLUMN transaction_time VARCHAR(20);
    
UPDATE sales
SET transaction_time = (
CASE
    WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
    END

);
    

----- day_of_Week----
SELECT 
	date,
    DAYNAME(date)
FROM Sales;
ALTER TABLE sales ADD COLUMN day_of_wk VARCHAR(10);

UPDATE sales
SET day_of_wk = DAYNAME(date);

----- month_name ---
SELECT 
	date,
    MONTHNAME(date)
FROM Sales;


ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

--------------------------------- ##How many Unique cities does the city have ---------------------
SELECT 
	DISTINCT city
FROM sales;

SELECT 
	DISTINCT branch,
    city
FROM sales;

---------- ### Product Analysis ---------
-- Determine unique product lines -----
SELECT 
	COUNT(DISTINCT product_line) 
FROM sales;

SELECT 
	payment,
    COUNT(payment) AS cnt
FROM sales
GROUP BY payment
ORDER BY cnt DESC;

-- What is the most selling product line? --
SELECT 
	product_line,
    COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- what is the total revenue by month? --
SELECT 
	month_name AS month,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest COGS ---
SELECT 
	month_name AS month,
    SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs DESC;
## March had the highest sales 

-- What product line had the largest revenue?
SELECT 
	product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

## Food and Beverages has the highest Revenue
-- What is the city with the largest revenue?
SELECT 
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT 
	product_line,
	AVG(tax_pct) AS average_tax
FROM sales
GROUP BY product_line
ORDER BY average_tax DESC;
## Home and life style has the highest VA

-- which branch sold more products than average product sold?
SELECT 
	branch,
    SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);
## Branch A

-- most common product line by gender? --
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;
## Female Fahion Accessories

-- What is the average rating of each product line?
SELECT
	ROUND(AVG(rating), 2) AS avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


