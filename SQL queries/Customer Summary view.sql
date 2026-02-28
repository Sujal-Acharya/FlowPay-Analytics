--View 2 Customer Summary
CREATE OR ALTER VIEW vw_customer_summary AS

SELECT
    c.customer_id,
    c.full_name,
    c.email,
    c.city,
    c.segment,
    c.annual_income,
    c.join_date,
    c.is_active,
    c.nps_score,
    ch.channel_name                         AS acquisition_channel,
    COUNT(t.transaction_id)                 AS total_transactions,
    SUM(t.revenue_amount)                   AS total_revenue,
    AVG(t.revenue_amount)                   AS avg_revenue_per_txn,
    MAX(d.full_date)                        AS last_transaction_date,
    DATEDIFF(MONTH, c.join_date, GETDATE()) AS months_as_customer

FROM dim_customers c
LEFT JOIN fact_transactions t  ON c.customer_id = t.customer_id AND t.is_successful = 1
LEFT JOIN dim_date d           ON t.date_id = d.date_id
LEFT JOIN dim_channels ch      ON c.acquisition_channel_id = ch.channel_id
GROUP BY
    c.customer_id,
    c.full_name,
    c.email,
    c.city,
    c.segment,
    c.annual_income,
    c.join_date,
    c.is_active,
    c.nps_score,
    ch.channel_name;

SELECT * FROM vw_monthly_revenue;