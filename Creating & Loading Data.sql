CREATE DATABASE coffee_shop;

USE Coffee_shop;

-- CREATING TABLES for schema.
CREATE TABLE city(
	city_id int PRIMARY KEY,
    city_name varchar(100),
    population BIGINT,
    estimated_rent BIGINT,
    city_rank int);
    
    
CREATE TABLE Customer(
	Customer_id int PRIMARY KEY,
    customer_name varchar(100), 
    city_id int,
    FOREIGN KEY (city_id) REFERENCES city (city_id));
    
    
CREATE TABLE Product(
	product_id int PRIMARY KEY,
    Product_name varchar(100),
    product_price int);
    

CREATE TABLE Sales(
	sale_id int PRIMARY KEY,
    sale_date date,
    product_id int,
    customer_id int, 
    total bigint, 
    rating int,
    FOREIGN KEY (product_id) REFERENCES product (product_id),
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id));
    
    
-- Enabling loading data into the file.
SET GLOBAL local_infile=ON;   


-- Loading Data into City Table.
LOAD DATA LOCAL INFILE "D:/Projects/MySQL/8 - Monday Coffee/city.csv"
INTO TABLE city
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
IGNORE 1 ROWS ;
    
    
-- Loading Data into Customer Table.
LOAD DATA LOCAL INFILE "D:/Projects/MySQL/8 - Monday Coffee/customers.csv"
INTO TABLE customer
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
IGNORE 1 ROWS ;

-- Loading Data into Product Table.
LOAD DATA LOCAL INFILE "D:/Projects/MySQL/8 - Monday Coffee/products.csv"
INTO TABLE product
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
IGNORE 1 ROWS ;



-- Loading Data into Sales Table.
LOAD DATA LOCAL INFILE "D:/Projects/MySQL/8 - Monday Coffee/sales.csv"
INTO TABLE sales
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
IGNORE 1 ROWS ;