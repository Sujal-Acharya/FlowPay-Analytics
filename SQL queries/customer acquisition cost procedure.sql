--procedure 5 calculating customer acquisition cost
--formula :- total marketing spend / No. of new customers
CREATE OR ALTER PROCEDURE sp_Calculate_CAC
    @year INT
AS
BEGIN

    SELECT
        ch.channel_name,
        ch.channel_type,
        ch.monthly_spend * 12               AS annual_spend,       -- yearly budget for this channel

        -- count customers who joined via this channel in the given year
        COUNT(c.customer_id)                AS new_customers,

        -- CAC = annual spend / new customers
        ROUND(
            (ch.monthly_spend * 12)
            / NULLIF(COUNT(c.customer_id), 0)
        , 2)                                AS cac

    FROM dim_channels ch
    LEFT JOIN dim_customers c
           ON ch.channel_id = c.acquisition_channel_id
           AND YEAR(c.join_date) = @year
    GROUP BY
        ch.channel_name,
        ch.channel_type,
        ch.monthly_spend
    ORDER BY cac ASC;    -- lowest CAC channel at the top (most efficient)

END;

EXEC sp_Calculate_CAC @year = 2023;