-- Show all orders.
SELECT * FROM order_details;

-- Count total orders.
SELECT COUNT(*) FROM order_details;

-- Find total sales.
SELECT ROUND(SUM(sales), -2) FROM order_details;

-- Find average profit.
SELECT ROUND(AVG(profit), 2) FROM order_details;

-- Find highest sale.
SELECT * FROM order_details
WHERE sales = (SELECT MAX(sales) FROM order_details);

-- Find lowest profit.
SELECT * FROM order_details
WHERE profit = (SELECT MIN(profit) FROM order_details);

-- Count customers.
SELECT COUNT(*) FROM customer;

-- Count products.
SELECT COUNT(*) FROM product;

-- Show all regions.
SELECT DISTINCT region FROM address;

-- Show orders after a certain date.
SELECT * FROM order_details
WHERE order_id IN (SELECT order_id FROM order_ WHERE order_date > '2014-06-21');
SELECT order_id, order_date FROM order_ WHERE order_date > '2014-06-21' ORDER BY order_date;

-- Sales by region.
DESCRIBE address;
DESCRIBE order_details;
SELECT region, ROUND(SUM(sales), -2) AS total_sales
FROM
	address a 
    JOIN order_ o ON a.id = o.address_id
    JOIN order_details od ON o.order_id = od.order_id
GROUP BY region;

-- Profit by category.
SELECT category, ROUND(SUM(profit), -2) AS total_profit
FROM
	product p JOIN order_details od ON p.product_id = od.product_id
GROUP BY category;

-- Average discount by category.
SELECT category, ROUND(AVG(discount), 2) AS average_discount
FROM
	product p JOIN order_details od ON p.product_id = od.product_id
GROUP BY category;

-- Top 10 customers by sales.
SELECT customer_name, ROUND(SUM(sales), -2) AS total_sales 
FROM
	customer c 
    JOIN order_ o ON c.customer_id = o.customer_id 
    JOIN order_details od ON o.order_id = od.order_id
GROUP BY customer_name
ORDER BY total_sales DESC LIMIT 10;

-- Top 10 customers by profit.
SELECT customer_name, ROUND(SUM(profit), -2) AS total_profit
FROM
	customer c 
    JOIN order_ o ON c.customer_id = o.customer_id 
    JOIN order_details od ON o.order_id = od.order_id
GROUP BY customer_name
ORDER BY total_profit DESC LIMIT 10;

-- Products with negative profit.
SELECT DISTINCT product_name
FROM
	product p JOIN order_details od ON p.product_id = od.product_id
WHERE profit < 0;

-- Monthly sales.
SELECT order_month, ROUND(SUM(sales), -2) AS total_sales
FROM
	order_ o JOIN order_details od ON o.order_id = od.order_id
GROUP BY order_month
ORDER BY order_month;
SELECT order_month, ROUND(SUM(sales), -2) AS total_sales
FROM
	order_ o JOIN order_details od ON o.order_id = od.order_id
GROUP BY order_month
ORDER BY total_sales DESC;

-- Monthly profit.
SELECT order_month, ROUND(SUM(profit), -2) AS total_profit
FROM
	order_ o JOIN order_details od ON o.order_id = od.order_id
GROUP BY order_month
ORDER BY order_month;
SELECT order_month, ROUND(SUM(profit), -2) AS total_profit
FROM
	order_ o JOIN order_details od ON o.order_id = od.order_id
GROUP BY order_month
ORDER BY total_profit DESC;

-- Best selling products.
SELECT product_name, ROUND(SUM(sales), -2) AS total_sales
FROM
	product p JOIN order_details od ON p.product_id = od.product_id
GROUP BY product_name
ORDER BY total_sales DESC;

-- Average shipping time.
SELECT ROUND(AVG(ship_date - order_date), 0) AS average_shiping_days FROM order_;
SELECT ship_mode, ROUND(AVG(ship_date - order_date), 0) AS average_shiping_days FROM order_
GROUP BY ship_mode;

-- Orders by ship mode.
SELECT ship_mode, COUNT(*) number_of_orders FROM order_
GROUP BY ship_mode;

-- Customer ranking using window functions.
SELECT customer_name, ROUND(SUM(sales) OVER(PARTITION BY customer_name), -2) AS total_sales
FROM
	customer c 
    JOIN order_ o ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
ORDER BY total_sales DESC;

SELECT customer_name, DENSE_RANK() OVER(ORDER BY sales DESC) AS customer_rank
FROM
	customer c 
    JOIN order_ o ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
ORDER BY customer_rank;

-- Running monthly sales total.
SELECT order_month, SUM(sales)
FROM
	order_ o JOIN order_details od ON o.order_id = od.order_id
GROUP BY order_month
ORDER BY order_month;

SELECT DISTINCT order_month, SUM(sales) OVER(ORDER BY order_month) AS running_total
FROM
	order_ o JOIN order_details od ON o.order_id = od.order_id
WHERE order_year = 2015;

-- Products above average sales (subquery).
SELECT product_name, ROUND(SUM(sales), -1) AS total_sales
FROM
	product p
    JOIN order_details od ON p.product_id = od.product_id
WHERE sales > (SELECT AVG(sales) FROM order_details)
GROUP BY product_name;
SELECT DISTINCT product_name
FROM
	product p
    JOIN order_details od ON p.product_id = od.product_id
WHERE sales > (SELECT AVG(sales) FROM order_details);

-- Regions with above-average profit.(I guess It means the average among reigons not orders, I will do both any ways)
SELECT DISTINCT region
FROM
	address a
    JOIN order_ o ON a.id = o.address_id
    JOIN order_details od ON o.order_id = od.order_id
WHERE profit > (SELECT AVG(profit) FROM order_details); -- regarding the average of all orders

SELECT
	DISTINCT region,
    ROUND(SUM(profit) OVER(PARTITION BY region), -2) AS total_sales
    FROM
		address a
		JOIN order_ o ON a.id = o.address_id
		JOIN order_details od ON o.order_id = od.order_id ORDER BY region;

SELECT region, tp FROM (
SELECT region, SUM(profit) AS tp
FROM
	address a
    JOIN order_ o ON a.id = o.address_id
    JOIN order_details od ON o.order_id = od.order_id
GROUP BY region ORDER BY region) AS rp
WHERE tp > (SELECT AVG(tp) FROM (
SELECT region, SUM(profit) AS tp
FROM
	address a
    JOIN order_ o ON a.id = o.address_id
    JOIN order_details od ON o.order_id = od.order_id
GROUP BY region ORDER BY region) AS rp);

-- CASE statement to classify profit.
DESCRIBE order_details;
SELECT DISTINCT
product_name,
CASE
	WHEN profit_margin <= 0 THEN 'Loss'
	WHEN profit_margin <= 0.05 THEN 'Low profit'
    WHEN profit_margin <= 0.10 THEN 'Average profit'
    WHEN profit_margin <= 0.2 THEN 'Good profit'
    WHEN profit_margin <= 0.3 THEN 'High profit'
    WHEN profit_margin > 0.3 THEN 'Very High profit'
END AS profit_class,
profit_margin
FROM 
	product p
    JOIN order_details od ON p.product_id = od.product_id;

-- CTE for monthly summary.
WITH monthly_summary AS
(
SELECT
DISTINCT
order_year,
order_month,
o.order_id,
SUM(sales) OVER(PARTITION BY o.order_year, o.order_month) AS total_sales,
SUM(profit) OVER(PARTITION BY o.order_year, o.order_month) AS totala_profit,
COUNT(o.order_id) OVER(PARTITION BY o.order_year, o.order_month) AS number_of_orders,
SUM(sales) OVER(PARTITION BY o.order_year, o.order_month, o.order_id) total_order_value
FROM
	order_ o
    JOIN order_details od ON o.order_id = od.order_id
)
SELECT order_year, order_month, AVG(total_order_value) AS average_order_value FROM monthly_summary
GROUP BY order_year, order_month;
SELECT AVG(total) FROM(
SELECT o.order_id, SUM(sales) as total
FROM
	order_ o
    JOIN order_details od ON o.order_id = od.order_id
WHERE order_year = 2016 AND order_month = 6
GROUP BY o.order_id) AS tb; -- checking if the last column in the upove query is right ("IT IS :)" )

-- Create sales summary view.
CREATE VIEW sales_summary AS
SELECT
ROUND(SUM(sales), -2) AS total_sales,
COUNT(DISTINCT order_id) total_orders,
SUM(quantity) AS total_quantity_sold,
ROUND(SUM(sales)/COUNT(DISTINCT order_id), 0) AS average_order_value,
ROUND(SUM(profit), -2) AS total_profit,
ROUND(SUM(profit)/SUM(sales), 2) AS profit_margin
FROM retail;
SELECT * FROM sales_summary;

-- Join all tables to create a business report.
CREATE VIEW address_ AS
SELECT
id AS aid,
postal_code,
city, state, region, country FROM address;

CREATE VIEW report_table AS
SELECt
*
FROM
order_ o 
JOIN address_ a ON o.address_id = a.aid
JOIN customer c USING (customer_id)
JOIN order_details od USING (order_id)
JOIN product p USING (product_id);

SELECT * FROM report_table;

-- Find each customer's first purchase date.
SELECT customer_name, MIN(order_date)
FROM
	order_ o JOIN customer USING (customer_id)
GROUP BY customer_name;










