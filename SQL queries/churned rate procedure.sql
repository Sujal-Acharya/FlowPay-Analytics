--Procedure for calculating churn rate
--churn rate = churned customers / total customers * 100
CREATE OR ALTER PROCEDURE sp_Calculate_Churn
AS
BEGIN

    SELECT
        segment,
        COUNT(*)                                                        AS total_customers,
        SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END)                 AS active_customers,
        SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END)                 AS churned_customers,

        -- churn rate as a percentage
        ROUND(
            SUM(CASE WHEN is_active = 0 THEN 1.0 ELSE 0 END)
            / COUNT(*) * 100
        , 2)                                                            AS churn_rate_percent

    FROM dim_customers
    GROUP BY segment
    ORDER BY churn_rate_percent DESC;

END;

EXEC sp_Calculate_Churn;