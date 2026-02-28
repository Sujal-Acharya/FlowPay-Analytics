--procedure 6 monthly report
CREATE OR ALTER PROCEDURE sp_Monthly_Report
    @year  INT,
    @month INT
AS
BEGIN

    PRINT '------------------------------------------------';
    PRINT 'Monthly KPI Report';
    PRINT 'Year : ' + CAST(@year  AS VARCHAR);
    PRINT 'Month: ' + CAST(@month AS VARCHAR);
    PRINT '-------------------------------------------------';

    PRINT '';
    PRINT '--- ARPU (Average Revenue Per User) ---';
    EXEC sp_Calculate_ARPU @year = @year, @month = @month;

    PRINT '';
    PRINT '--- Churn Rate by Segment ---';
    EXEC sp_Calculate_Churn;

    PRINT '';
    PRINT '--- LTV (Lifetime Value) by Segment ---';
    EXEC sp_Calculate_LTV;

    PRINT '';
    PRINT '--- NPS Score ---';
    EXEC sp_Calculate_NPS;

    PRINT '';
    PRINT '--- CAC (Customer Acquisition Cost) ---';
    EXEC sp_Calculate_CAC @year = @year;

    PRINT '';
    PRINT 'Report complete.';

END;

EXEC sp_Monthly_Report @year = 2024, @month = 3;