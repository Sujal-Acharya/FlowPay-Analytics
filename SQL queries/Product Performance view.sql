--View 3 Product performance
CREATE OR ALTER VIEW vw_product_performance AS

SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.monthly_fee,
    p.interest_rate,
    d.year_number,
    d.month_number,
    CONCAT(LEFT(d.month_name, 3), ' ', d.year_number)  AS month_year,
    COUNT(DISTINCT t.customer_id)   AS customers_using,
    COUNT(t.transaction_id)         AS total_transactions,
    SUM(t.amount)                   AS total_amount,
    SUM(t.revenue_amount)           AS total_revenue

FROM fact_transactions t
JOIN dim_products p ON t.product_id = p.product_id
JOIN dim_date d     ON t.date_id = d.date_id
WHERE t.is_successful = 1
GROUP BY
    p.product_id,
    p.product_name,
    p.category,
    p.monthly_fee,
    p.interest_rate,
    d.year_number,
    d.month_number,
    d.month_name;

SELECT TOP 5 * FROM vw_product_performance ORDER BY total_revenue DESC;