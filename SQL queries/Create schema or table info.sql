--Fintech SQL Project
CREATE DATABASE FINSIGHTDB;
GO

USE FINSIGHTDB;
GO


--DIMENSION TABLE
--TABLE 1 : CHANNELS (STORES HOW CUSTOMERS FOUND US)
CREATE TABLE dim_channels 
(
	channel_id INT PRIMARY KEY IDENTITY(1,1),
	channel_name NVARCHAR(100),
	channel_type NVARCHAR(50),  --DIGITAL, PHYSICAL, ORGANIC
	monthly_spend DECIMAL(10,2) --how much we spend on this channel per month
);

--TABLE 2: PRODUCTS (STORES ALL BANKING PRODUCTS)
CREATE TABLE dim_products 
(
	product_id INT PRIMARY KEY IDENTITY(1,1),
	product_name NVARCHAR(150),
	category NVARCHAR(50),  --SAVINGS,LOAN, CARD, INVESTMENT
	monthly_fee DECIMAL(10,2),
	interest_rate DECIMAL(5,2)
);

--TABLE 3: DATE (FROM 2020-2025)
CREATE TABLE dim_date (
    date_id         INT PRIMARY KEY,  -- format: YYYYMMDD  e.g. 20240115
    full_date       DATE,
    day_name        NVARCHAR(10),     -- Monday, Tuesday, etc.
    month_number    INT,
    month_name      NVARCHAR(10),
    quarter_number  INT,
    year_number     INT,
    is_weekend      BIT      -- 1 = weekend, 0 = weekday
);

--TABLE 4: CUSTOMERS (stores all customer info)
CREATE TABLE dim_customers 
(
	customer_id INT PRIMARY KEY IDENTITY(1,1),
	full_name NVARCHAR(150),
	email NVARCHAR(200),
	city NVARCHAR(100),
	segment NVARCHAR(50), --premium, standard, basic
	annual_income	DECIMAL(14,2),
	acquisition_channel_id INT,
	join_date DATE,
	is_active BIT, --1=still a customer, 0 = churned
	nps_score INT,  -- 0 to 10 , how likely they recommend our product
	FOREIGN KEY(acquisition_channel_id) REFERENCES dim_channels(channel_id)
);


--FACT TABLES
--TABLE 5: TRANSACTIONS (transaction made by any customer)
CREATE TABLE fact_transactions
(
	transaction_id BIGINT PRIMARY KEY IDENTITY(1,1),
	customer_id INT,
	product_id INT,
	date_id INT,
	transaction_type NVARCHAR(50), --deposit, withdrawal, fee, interest, payment
	amount	DECIMAL(18,2), --transaction value
	revenue_amount DECIMAL(18,2), --bank actually earned from this transaction
	is_successful BIT,  --1 = completed, 0 = failed

	FOREIGN KEY (customer_id) REFERENCES dim_customers(customer_id),
	FOREIGN KEY (product_id) REFERENCES dim_products(product_id),
	FOREIGN KEY (date_id) REFERENCES dim_date(date_id)
);

--TABLE 6: MONTHLY CUSTOMER METRICS (KPI)
CREATE TABLE fact_customer_metrics (
    metric_id           INT PRIMARY KEY IDENTITY(1,1),
    customer_id         INT,
    snapshot_year       INT,
    snapshot_month      INT,
    total_revenue       DECIMAL(14,2),   -- how much this customer earned us this month
    total_transactions  INT,
    is_churned          BIT,             -- did they leave this month?
    ltv_to_date         DECIMAL(14,2),   -- total revenue since they joined

    FOREIGN KEY (customer_id) REFERENCES dim_customers(customer_id)
);




