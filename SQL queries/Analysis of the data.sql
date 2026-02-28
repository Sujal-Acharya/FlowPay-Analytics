--Analysis of the data
--MoM revenue growth (Month wise)
SELECT
    year_number,
    month_number,
    month_year,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY year_number, month_number)  AS last_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY year_number, month_number))
        / NULLIF(LAG(total_revenue) OVER (ORDER BY year_number, month_number), 0) * 100
    , 2)                                                           AS mom_growth_percent
FROM vw_monthly_revenue
ORDER BY year_number, month_number;


--Customer segmentation by revenue
SELECT
    customer_id,
    full_name,
    segment,
    city,
    total_revenue,
    RANK() OVER (PARTITION BY segment ORDER BY total_revenue DESC) AS rank_in_segment,
    CASE
        WHEN total_revenue >= 5000  THEN 'High Value'
        WHEN total_revenue >= 1000  THEN 'Medium Value'
        ELSE                             'Low Value'
    END AS value_bucket
FROM vw_customer_summary
ORDER BY total_revenue DESC;

--nps breakdown
SELECT
    SUM(CASE WHEN nps_score >= 9                THEN 1 ELSE 0 END) AS promoters,
    SUM(CASE WHEN nps_score BETWEEN 7 AND 8     THEN 1 ELSE 0 END) AS passives,
    SUM(CASE WHEN nps_score <= 6                THEN 1 ELSE 0 END) AS detractors,
    COUNT(*)                                                        AS total_customers,
    ROUND(
        (SUM(CASE WHEN nps_score >= 9  THEN 1.0 ELSE 0 END) / COUNT(*) * 100)
        -
        (SUM(CASE WHEN nps_score <= 6  THEN 1.0 ELSE 0 END) / COUNT(*) * 100)
    , 1)                                                            AS nps_score
FROM dim_customers
WHERE nps_score IS NOT NULL;


--Top 10 customers by revenue
SELECT TOP 10
    customer_id,
    full_name,
    segment,
    city,
    total_revenue,
    total_transactions,
    months_as_customer,
    ROUND(total_revenue / NULLIF(months_as_customer, 0), 2) AS monthly_revenue_rate
FROM vw_customer_summary
ORDER BY total_revenue DESC;

--Churn rate by segment
SELECT
    segment,
    COUNT(*)                                                        AS total_customers,
    SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END)                 AS active_customers,
    SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END)                 AS churned_customers,
    ROUND(SUM(CASE WHEN is_active = 0 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 1)   AS churn_rate_percent
FROM dim_customers
GROUP BY segment
ORDER BY churn_rate_percent DESC;

--revenue by city
SELECT
    c.city,
    COUNT(DISTINCT c.customer_id)   AS total_customers,
    SUM(t.revenue_amount)           AS total_revenue,
    ROUND(AVG(t.revenue_amount), 2) AS avg_revenue_per_txn
FROM dim_customers c
JOIN fact_transactions t ON c.customer_id = t.customer_id
WHERE t.is_successful = 1
GROUP BY c.city
ORDER BY total_revenue DESC;




