--procedure 1 calculate the average revenue per users
--formula:- total revenue / No of active users
CREATE OR ALTER PROCEDURE sp_Calculate_ARPU
    @year  INT,
    @month INT
AS
BEGIN

    SELECT
        @year                           AS report_year,
        @month                          AS report_month,

        -- how many unique customers had transactions this month
        COUNT(DISTINCT t.customer_id)   AS active_customers,

        -- total revenue this month
        ROUND(SUM(t.revenue_amount), 2) AS total_revenue,

        -- ARPU = total revenue divided by active customers
        ROUND(
            SUM(t.revenue_amount) / NULLIF(COUNT(DISTINCT t.customer_id), 0)
        , 2)                            AS arpu

    FROM fact_transactions t
    JOIN dim_date d ON t.date_id = d.date_id
    WHERE
        t.is_successful = 1
        AND d.year_number  = @year
        AND d.month_number = @month;

END;

EXEC sp_Calculate_ARPU @year = 2023, @month = 1;
EXEC sp_Calculate_ARPU @year = 2024,@month= 1;