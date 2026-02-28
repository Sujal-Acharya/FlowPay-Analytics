USE FINSIGHTDB
Go
--  VIEW 1: Monthly Revenue Summary
--  Shows total revenue, transactions, and active customers
--  broken down by month and year
CREATE OR ALTER VIEW vw_monthly_revenue AS

SELECT
    d.year_number,
    d.month_number,
    d.month_name,

    -- build 'Jan 2023' style label since we don't have month_year column
    CONCAT(LEFT(d.month_name, 3), ' ', d.year_number)  AS month_year,

    COUNT(DISTINCT t.customer_id)   AS active_customers,
    COUNT(t.transaction_id)         AS total_transactions,
    SUM(t.amount)                   AS total_amount,
    SUM(t.revenue_amount)           AS total_revenue,
    AVG(t.revenue_amount)           AS avg_revenue_per_txn

FROM fact_transactions t
JOIN dim_date d ON t.date_id = d.date_id
WHERE t.is_successful = 1
GROUP BY
    d.year_number,
    d.month_number,
    d.month_name;



SELECT TOP 5 * FROM vw_monthly_revenue ORDER BY year_number, month_number;
