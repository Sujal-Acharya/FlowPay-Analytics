--View 4 Channel Performance
CREATE OR ALTER VIEW vw_channel_performance AS

SELECT
    ch.channel_id,
    ch.channel_name,
    ch.channel_type,
    ch.monthly_spend,
    COUNT(DISTINCT c.customer_id)   AS total_customers,
    SUM(t.revenue_amount)           AS total_revenue,
    ROUND(SUM(t.revenue_amount) / NULLIF(COUNT(DISTINCT c.customer_id), 0) , 2)   AS revenue_per_customer,
    ROUND( ch.monthly_spend / NULLIF(COUNT(DISTINCT c.customer_id), 0) , 2)        AS estimated_cac

FROM dim_channels ch
LEFT JOIN dim_customers c      ON ch.channel_id = c.acquisition_channel_id
LEFT JOIN fact_transactions t  ON c.customer_id = t.customer_id AND t.is_successful = 1
GROUP BY
    ch.channel_id,
    ch.channel_name,
    ch.channel_type,
    ch.monthly_spend;

SELECT * FROM vw_channel_performance ORDER BY total_revenue DESC;