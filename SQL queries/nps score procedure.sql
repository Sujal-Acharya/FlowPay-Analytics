--procedure 4 calculate nps score
CREATE OR ALTER PROCEDURE sp_Calculate_NPS
AS
BEGIN

    SELECT
        -- count each group
        SUM(CASE WHEN nps_score >= 9              THEN 1 ELSE 0 END)  AS promoters,
        SUM(CASE WHEN nps_score BETWEEN 7 AND 8   THEN 1 ELSE 0 END)  AS passives,
        SUM(CASE WHEN nps_score <= 6              THEN 1 ELSE 0 END)  AS detractors,
        COUNT(*)                                                       AS total_responses,

        -- % of each group
        ROUND(SUM(CASE WHEN nps_score >= 9            THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 1) AS promoter_percent,
        ROUND(SUM(CASE WHEN nps_score BETWEEN 7 AND 8 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 1) AS passive_percent,
        ROUND(SUM(CASE WHEN nps_score <= 6            THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 1) AS detractor_percent,

        -- final NPS score
        ROUND(
            (SUM(CASE WHEN nps_score >= 9  THEN 1.0 ELSE 0 END) / COUNT(*) * 100)
            -
            (SUM(CASE WHEN nps_score <= 6  THEN 1.0 ELSE 0 END) / COUNT(*) * 100)
        , 1)                                                           AS nps_score

    FROM dim_customers
    WHERE nps_score IS NOT NULL;

END;

EXEC sp_Calculate_NPS;