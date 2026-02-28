--Procedure calculate lifetime value
--  Formula: Avg monthly revenue per customer * avg months as customers
CREATE OR ALTER PROCEDURE sp_Calculate_LTV
AS
BEGIN

    -- first build a summary per customer
    WITH customer_revenue AS (
        SELECT
            c.customer_id,
            c.segment,
            c.join_date,
            DATEDIFF(MONTH, c.join_date, GETDATE())     AS months_as_customer,
            COALESCE(SUM(t.revenue_amount), 0)          AS total_revenue
        FROM dim_customers c
        LEFT JOIN fact_transactions t
               ON c.customer_id = t.customer_id AND t.is_successful = 1
        GROUP BY
            c.customer_id,
            c.segment,
            c.join_date
    )

    SELECT
        segment,
        COUNT(customer_id)                              AS total_customers,

        -- average total revenue per customer
        ROUND(AVG(total_revenue), 2)                    AS avg_revenue_per_customer,

        -- average months they stay with us
        ROUND(AVG(CAST(months_as_customer AS FLOAT)), 1) AS avg_months_as_customer,

        -- LTV = avg monthly revenue * avg lifespan in months
        ROUND(
            AVG(total_revenue / NULLIF(months_as_customer, 0))   -- avg monthly revenue
            * AVG(CAST(months_as_customer AS FLOAT))              -- * avg lifespan
        , 2)                                            AS estimated_ltv

    FROM customer_revenue
    GROUP BY segment
    ORDER BY estimated_ltv DESC;

END;

EXEC sp_Calculate_LTV;
