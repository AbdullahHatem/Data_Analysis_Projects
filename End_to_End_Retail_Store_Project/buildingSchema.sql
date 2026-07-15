/*
['row_id', 'order_id', 'order_date', 'ship_date', 'ship_mode', 'customer_id', 'customer_name', 'segment', 'country', 'city',
'state', 'postal_code', 'region', 'product_id', 'category', 'sub_category', 'product_name', 'sales', 'quantity', 'discount',
'profit', 'order_year', 'order_month', 'order_month_name', 'order_day', 'order_day_name', 'ship_year', 'ship_month',
'ship_month_name', 'ship_day', 'ship_day_name', 'quarter', 'profit_margin', 'order_value_category', 'discount_level']
Normalizing the table into multiple tables
order table [order_id, order_date, order_year, order_month, order_month_name, order_day, order_day_name,
					     ship_date, ship_year, ship_month,  ship_month_name,  ship_day,  ship_day_name,
                         ship_mode, customer_id, address_id, quarter]
customer table [customer_id, customer_name, segment, address_id]
address table [id, postal_code, city, state, region, country]
product table [ product_id, product_name, category, sub_category]
order_details table [row_id, order_id, address_id, product_id, sales, quantity, discount, profit, profit_margin,
                     order_value_category, discount_level]
.
['row_id', 'order_id', 'order_date', 'ship_date', 'ship_mode', 'customer_id', 'customer_name', 'segment', 'country', 'city',
'state', 'postal_code', 'region', 'product_id', 'category', 'sub_category', 'product_name', 'sales', 'quantity', 'discount',
'profit', 'order_year', 'order_month', 'order_month_name', 'order_day', 'order_day_name', 'ship_year', 'ship_month',
'ship_month_name', 'ship_day', 'ship_day_name', 'quarter', 'profit_margin', 'order_value_category', 'discount_level']
*/
SELECT DATABASE();
SHOW DATABASES;
CREATE DATABASE retail;
USE retail;
SHOW TABLES;
CREATE TABLE retail(
id INT AUTO_INCREMENT PRIMARY KEY, order_id VARCHAR(50),
order_date DATE, order_year INT, order_month INT, order_month_name VARCHAR(10), order_day INT, order_day_name VARCHAR(10),
ship_date DATE, ship_year INT, ship_month INT, ship_month_name VARCHAR(10), ship_day INT, ship_day_name VARCHAR(10),
ship_mode VARCHAR(50), customer_id VARCHAR(50), customer_name VARCHAR(100), segment VARCHAR(50), country VARCHAR(50),
city VARCHAR(50), state VARCHAR(50), postal_code VARCHAR(50), region VARCHAR(50), product_id VARCHAR(50), category VARCHAR(50),
sub_category VARCHAR(50), product_name VARCHAR(200), sales FLOAT, quantity INT, discount FLOAT, profit FLOAT, quarter_ INT,
profit_margin FLOAT);
DROP TABLE retail;
LOAD DATA LOCAL INFILE "C:\\Users\\Abdullah\\Desktop\\retail_sales_project\\retail_clean.csv"
INTO TABLE retail
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@skip, @skip, order_id, order_date, ship_date, ship_mode,
       customer_id, customer_name, segment, country, city, state,
       postal_code, region, product_id, category, sub_category,
       product_name, sales, quantity, discount, profit, order_year,
       order_month, order_month_name, order_day, order_day_name,
       ship_year, ship_month, ship_month_name, ship_day,
       ship_day_name, quarter_, profit_margin, @skip,
       @skip);

CREATE TABLE order_
(order_id VARCHAR(50) PRIMARY KEY, 
order_date DATE, order_year INT, order_month INT, order_month_name VARCHAR(10), order_day INT, order_day_name VARCHAR(10),
ship_date DATE, ship_year INT, ship_month INT,  ship_month_name VARCHAR(10),  ship_day INT,  ship_day_name VARCHAR(10),
ship_mode VARCHAR(50), customer_id VARCHAR(50), address_id INT, quarter_ INT);
INSERT INTO order_(order_id, order_date, order_year, order_month, order_month_name, order_day, order_day_name,
							 ship_date, ship_year, ship_month, ship_month_name, ship_day, ship_day_name,
                             ship_mode, customer_id, quarter_)
SELECT DISTINCT order_id, order_date, order_year, order_month, order_month_name, order_day, order_day_name,
							 ship_date, ship_year, ship_month, ship_month_name, ship_day, ship_day_name,
                             ship_mode, customer_id, quarter_
FROM retail;
UPDATE order_ o
JOIN retail r ON o.order_id = r.order_id
JOIN address a ON r.postal_code = a.postal_code
SET o.address_id = a.id;
SELECT * FROM order_;

CREATE TABLE customer(customer_id VARCHAR(50) PRIMARY KEY, customer_name VARCHAR(100), segment VARCHAR(50), address_id INT);
INSERT INTO customer(customer_id, customer_name, segment)
SELECT DISTINCT customer_id, customer_name, segment FROM retail;
UPDATE customer c
JOIN retail r ON c.customer_id = r.customer_id
JOIN address a ON r.postal_code = a.postal_code
SET c.address_id = a.id;
SELECT * FROM customer LIMIT 40;


CREATE TABLE address(
id INT AUTO_INCREMENT PRIMARY KEY, 
postal_code VARCHAR(50), city VARCHAR(50), state VARCHAR(50), region VARCHAR(50), country VARCHAR(50));

INSERT INTO address(postal_code, city, state, region, country)  -- multiple addresses could have the same postalcode but here postal code will be treated as unique
SELECT DISTINCT postal_code, city, state, region, country FROM retail;
SELECT * FROM address;

CREATE TABLE product(
product_id VARCHAR(50) PRIMARY KEY,
product_name VARCHAR(200), category VARCHAR(50), sub_category VARCHAR(50));
INSERT INTO product (product_id, product_name, category, sub_category)
SELECT product_id, product_name, category, sub_category
FROM
	(SELECT product_id, product_name, category, sub_category, ROW_NUMBER() OVER(PARTITION BY product_id) as rnum
    FROM retail) AS distinct_retail WHERE distinct_retail.rnum =1;
SELECT * FROM product;

CREATE TABLE order_details(
id INT AUTO_INCREMENT PRIMARY KEY, 
order_id VARCHAR(50), address_id INT, product_id VARCHAR(50), sales FLOAT, quantity INT, discount FLOAT, profit FLOAT,
profit_margin FLOAT);
INSERT INTO order_details (order_id, product_id, sales, quantity, discount, profit, profit_margin)
SELECT order_id, product_id, sales, quantity, discount, profit, profit_margin FROM retail;
SET SQL_SAFE_UPDATES = 0;
UPDATE order_details od
JOIN order_ o ON od.order_id = o.order_id
SET od.address_id = o.address_id;
SET SQL_SAFE_UPDATES = 1;
ALTER TABLE order_details DROP COLUMN address_id;
SELECT * FROM order_details;
-- -------------------------------------------------------------------
SELECT * FROM order_;
ALTER TABLE order_
ADD CONSTRAINT frnkc
FOREIGN KEY (customer_id)
REFERENCES customer(customer_id),
ADD CONSTRAINT frnka
FOREIGN KEY (address_id)
REFERENCES address(id);

DESCRIBE order_details;
ALTER TABLE order_details
ADD CONSTRAINT frnko
FOREIGN KEY (order_id)
REFERENCES order_(order_id),
ADD CONSTRAINT frnkp
FOREIGN KEY (product_id)
REFERENCES product(product_id);

DESCRIBE customer;
ALTER TABLE customer
ADD CONSTRAINT frnkac
FOREIGN KEY (address_id)
REFERENCES address(id);

DESCRIBE address;

DESCRIBE product;

ALTER TABLE customer
DROP FOREIGN KEY  frnkac, 
DROP COLUMN address_id;

DESCRIBE customer;


