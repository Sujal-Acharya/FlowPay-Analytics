--INSERT CHANNELS
INSERT INTO dim_channels (channel_name, channel_type, monthly_spend)
VALUES
    ('Social Media Ads',   'Digital',   45000),
    ('Google Search Ads',  'Digital',   38000),
    ('Email Campaign',     'Digital',    8500),
    ('Referral Program',   'Organic',    5000),
    ('Branch Walk-in',     'Physical',  12000),
    ('Mobile App Organic', 'Organic',       0),
    ('Partner Banks',      'Physical',  22000),
    ('TV / Radio',         'Physical',  60000);

--INSERT PRODUCTS
INSERT INTO dim_products (product_name, category, monthly_fee, interest_rate)
VALUES
    ('Basic Savings Account',    'Savings',    0,    2.50),
    ('Premium Savings Account',  'Savings',    5,    4.75),
    ('Standard Checking',        'Checking',   0,    NULL),
    ('Business Checking',        'Checking',  15,    NULL),
    ('Personal Loan',            'Loan',       0,   12.50),
    ('Home Mortgage',            'Loan',       0,    5.25),
    ('Business Loan',            'Loan',       0,    9.75),
    ('Classic Credit Card',      'Card',       5,   22.99),
    ('Premium Rewards Card',     'Card',      25,   19.99),
    ('Mutual Fund Portfolio',    'Investment',10,    NULL),
    ('Fixed Deposit 12M',        'Investment', 0,    6.50);

--INSERT DATE TABLE USING LOOP
DECLARE @start_date DATE = '2020-01-01';
DECLARE @end_date   DATE = '2025-12-31';
DECLARE @current    DATE = @start_date;

WHILE @current <= @end_date
BEGIN
    INSERT INTO dim_date (date_id, full_date, day_name, month_number, month_name, quarter_number, year_number, is_weekend)
    VALUES (
        CAST(FORMAT(@current, 'yyyyMMdd') AS INT),
        @current,
        DATENAME(WEEKDAY, @current),
        MONTH(@current),
        DATENAME(MONTH, @current),
        DATEPART(QUARTER, @current),
        YEAR(@current),
        CASE WHEN DATEPART(WEEKDAY, @current) IN (1, 7) THEN 1 ELSE 0 END
    );

    SET @current = DATEADD(DAY, 1, @current);
END;

-- Speed up queries that filter transactions by customer and date
CREATE INDEX IX_transactions_customer_date
ON fact_transactions (customer_id, date_id);

-- Speed up queries that filter transactions by product
CREATE INDEX IX_transactions_product
ON fact_transactions (product_id);

-- Speed up customer lookups by segment
CREATE INDEX IX_customers_segment
ON dim_customers (segment, is_active);