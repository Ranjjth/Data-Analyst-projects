CREATE DATABASE ecommerce_db;
USE ecommerce_db;
SELECT * FROM orders LIMIT 5;
SELECT COUNT(*) FROM orders;
SELECT `Order Date` FROM orders;

-- checking for null values

select count(*) as Total_Rows,
sum(case when Sales is NULL then 1 else 0 end) as null_sales,
sum(case when Profit is null then 1 else 0 end) as null_profits from orders;

-- checking for duplicates 

select count(*) from orders;
SELECT COUNT(DISTINCT `Row ID`) FROM orders;

describe orders;

alter table orders rename column `Order Date` to Order_Date;
alter table orders rename column `Sub-Category` to Sub_Category;

SELECT * FROM orders
WHERE Sales < 0 OR Profit < -1000;

ALTER TABLE orders
MODIFY Sales DECIMAL(10,2),
MODIFY Profit DECIMAL(10,2);

UPDATE orders SET Order_Date = STR_TO_DATE(Order_Date, '%d/%m/%Y');
ALTER TABLE orders 
MODIFY Order_Date date;

SELECT MIN(Quantity), MAX(Quantity)
FROM orders;

SELECT sum(Sales) as Total_Sales from orders; -- 1912695.35;

SELECT COUNT(*) AS Total_Orders FROM orders; -- 8095;

SELECT sum(Profit) as Total_Profits from orders; -- 238173.68

-- Sales by Category
select Category, sum(Sales) as Total_Sales,sum(Profit) AS Total_Profit
from orders
group by Category
order by Total_sales desc;

-- Top 10 Products
select `Product Name`,sum(Sales) as Total_Sales,sum(Profit) AS Total_Profit
from orders
group by `Product Name`
order by Total_sales desc
limit 10;

-- Region-wise Performance
select Region,sum(Sales) as Total_Sales,sum(Profit) AS Total_Profit
from orders
group by Region
order by Total_sales desc;

-- Discount Impact 
SELECT Discount, AVG(Profit) AS avg_profit
FROM orders
GROUP BY Discount
ORDER BY Discount;      -- products above 0.2 discounts results in profit loss

-- Monthly Sales Trend
select date_format(STR_TO_DATE(Order_Date, '%m/%d/%Y'),'%Y-%M') as Month, sum(Sales) as Monthly_Sales
from orders
group by Month
order by Month;

-- Top Customers
SELECT `Customer Name`, SUM(Sales) AS total_spent,count(`Order ID`) as Total_orders
FROM orders
GROUP BY `Customer Name`
ORDER BY total_spent DESC
LIMIT 10;

ALTER TABLE orders ADD COLUMN Order_Date_Clean DATE;
SET SQL_SAFE_UPDATES = 0;
UPDATE orders
SET Order_Date_Clean =
    CASE
        WHEN Order_Date LIKE '%/%' THEN STR_TO_DATE(Order_Date, '%m/%d/%Y')
        WHEN Order_Date LIKE '%-%' THEN STR_TO_DATE(Order_Date, '%d-%m-%Y')
        ELSE NULL
    END;

ALTER TABLE orders ADD COLUMN Ship_Date_Clean DATE;
UPDATE orders
SET Ship_Date_Clean =
    CASE
        WHEN `Ship Date` LIKE '%/%' THEN STR_TO_DATE(`Ship Date`, '%m/%d/%Y')
        WHEN `Ship Date` LIKE '%-%' THEN STR_TO_DATE(`Ship Date`, '%d-%m-%Y')
        ELSE NULL
    END;
