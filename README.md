# FlowPay Analytics — Financial KPI Dashboard & Reporting Suite

A complete end-to-end business intelligence project built for a fictional fintech company.
Covers data modeling, KPI calculation, and interactive dashboards.

---

## Project Overview

This project builds a full analytics stack for a fintech company — starting from database
design all the way to an interactive Power BI dashboard. It covers synthetic data generation,
SQL data modeling, KPI calculations using stored procedures, and a multi-page dashboard
that business stakeholders can use to monitor financial performance in real time.

**The business questions this project answers:**
- How much revenue is the company generating per customer (ARPU)?
- Which customer segments are churning the most?
- Which acquisition channels give the best return on investment (CAC)?
- How loyal are our customers (NPS)?
- Which products are driving the most revenue?

---

## Tech Stack

| Tool | Used For |
|---|---|
| SQL Server | Database, schema design, stored procedures |
| Power BI | Interactive dashboards, DAX measures |
| Python | Synthetic data generation |
| T-SQL | Analytical views, window functions, KPI logic |

---

## Project Structure

```
flowpay-analytics/
│
├── sql/
│   ├── Phase1_Schema.sql              -- database schema, all 6 tables
│   ├── Phase3_Views_and_Queries.sql   -- 4 analytical views + 6 SQL queries
│   └── Phase4_Stored_Procedures.sql   -- 6 KPI stored procedures
│
├── python/
│   └── Phase2_Data_Generation.ipynb   -- synthetic data generation notebook
│
├── powerbi/
│   └── FlowPay_Dashboard.pbix         -- Power BI dashboard file
│
└── README.md
```

---

## Database Schema

Star schema design with 4 dimension tables and 1 fact table.
Database name: **FinSightDB**

```
                      dim_date
                         |
dim_channels --- fact_transactions --- dim_products
                         |
                    dim_customers
```

### dim_customers
| Column | Description |
|---|---|
| customer_id | Primary key |
| full_name | Customer full name |
| email | Email address |
| city | City of residence |
| annual_income | Yearly income |
| acquisition_channel_id | Links to dim_channels |
| join_date | Date they joined |
| is_active | 1 = active, 0 = churned |
| is_active_int | Integer version of is_active (used in Power BI) |

### dim_products
| Column | Description |
|---|---|
| product_id | Primary key |
| product_name | Name of the product |
| category | Savings, Loan, Card, Investment |
| monthly_fee | Monthly charge |
| interest_rate | Annual interest rate % |

### dim_channels
| Column | Description |
|---|---|
| channel_id | Primary key |
| channel_name | e.g. Social Media, Referral |
| channel_type | Digital, Physical, Organic |
| monthly_spend | Monthly marketing budget |

### dim_date
| Column | Description |
|---|---|
| date_id | Primary key (format YYYYMMDD) |
| full_date | Actual date value |
| day_name | Monday, Tuesday etc. |
| month_name | January, February etc. |
| month_number | 1 to 12 |
| quarter_number | 1 to 4 |
| year_number | e.g. 2023 |
| is_weekend | 1 = weekend, 0 = weekday |

### fact_transactions
| Column | Description |
|---|---|
| transaction_id | Primary key |
| customer_id | Links to dim_customers |
| product_id | Links to dim_products |
| date_id | Links to dim_date |
| amount | Transaction amount |
| revenue_amount | Bank's net revenue from this transaction |
| is_successful | TRUE/FALSE — whether transaction completed |
| is_successful_int | Integer version of is_successful (used in Power BI) |

---

## KPIs Tracked

| KPI | Formula | Purpose |
|---|---|---|
| ARPU | Total Revenue / Active Customers | Revenue efficiency |
| CAC | Marketing Spend / New Customers | Acquisition efficiency |
| LTV | Avg Monthly Revenue × Avg Lifespan | Customer lifetime value |
| Churn Rate | Churned / Total × 100 | Retention health |
| NPS | % Promoters − % Detractors | Customer satisfaction |
| MoM Growth | (This Month − Last Month) / Last Month | Revenue growth |

---

## SQL Highlights

**Window function — Month on Month revenue growth:**
```sql
SELECT
    month_year,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY year_number, month_number) AS last_month,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY year_number, month_number))
        / NULLIF(LAG(total_revenue) OVER (ORDER BY year_number, month_number), 0) * 100
    , 2) AS mom_growth_percent
FROM vw_monthly_revenue
ORDER BY year_number, month_number;
```

**Stored procedure — run full monthly KPI report with one command:**
```sql
EXEC sp_Monthly_Report @year = 2024, @month = 3;
```

---

## Power BI Dashboard

Two report pages built in Power BI Desktop:

**Page 1 — Executive Overview**
- 4 KPI cards: Total Revenue, ARPU, Churn Rate, NPS Score
- Monthly revenue trend line chart
- Revenue by customer segment bar chart
- Slicers for year and segment filtering

**Page 2 — Customer Analytics**
- Churned customers by segment donut chart
- Active customers by city bar chart
- Revenue by product bar chart
- Top 10 customers table

**DAX Measures written:**
```
Total Revenue, Total Transactions, Active Customers,
ARPU, Churn Rate %, NPS Score, MoM Growth %,
YTD Revenue, Avg Transaction Value, Churned Customers
```

---

## How to Run This Project

**Step 1 — Set up the database**
```sql
-- Open SQL Server Management Studio
-- Run: sql/Phase1_Schema.sql
-- This creates FinSightDB with all tables and seed data
```

**Step 2 — Load the data**
```sql
-- Run: insert_customers.sql    (2,000 customers)
-- Run: insert_transactions.sql (25,232 transactions)
```

**Step 3 — Create views and KPI procedures**
```sql
-- Run: sql/Phase3_Views_and_Queries.sql
-- Run: sql/Phase4_Stored_Procedures.sql
```

**Step 4 — Open the dashboard**
```
-- Open powerbi/FlowPay_Dashboard.pbix in Power BI Desktop
-- Update the SQL Server connection to your server name
-- Refresh the data
```

---

## Key Learnings

- Designed a star schema from scratch following data warehouse best practices
- Wrote complex analytical SQL using window functions (LAG, RANK, PARTITION BY)
- Built reusable stored procedures that calculate all KPIs automatically
- Created an interactive Power BI dashboard with 10 DAX measures
- Worked with realistic fintech data — transactions, segments, acquisition channels

---

## Author

**[Your Name]**
- LinkedIn: [your linkedin url]
- Email: [your email]
