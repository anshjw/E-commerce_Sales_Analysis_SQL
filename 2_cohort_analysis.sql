--Title: Customer Revenue by Cohort (NOT adjusted for time in market)
SELECT
    cohort_year,
    SUM(total_net_revenue) AS total_revenue,
    COUNT(DISTINCT customerkey) AS total_customers,
    SUM(total_net_revenue) / COUNT(DISTINCT customerkey) AS customer_revenue
FROM cohort_analysis
GROUP BY 
    cohort_year;

-- Title: Customer Revenue by Cohort (Adjusted for time in market)
WITH purchase_days AS (
    SELECT
        customerkey,
        total_net_revenue,
        orderdate - MIN(orderdate) OVER (PARTITION BY customerkey) AS days_since_first_purchase
    FROM cohort_analysis
)

SELECT
    days_since_first_purchase,
    SUM(total_net_revenue) as total_revenue,
    SUM(total_net_revenue) / (SELECT SUM(total_net_revenue) FROM cohort_analysis) * 100 as percentage_of_total_revenue,
    SUM(SUM(total_net_revenue) / (SELECT SUM(total_net_revenue) FROM cohort_analysis) * 100) OVER (ORDER BY days_since_first_purchase) as cumulative_percentage_of_total_revenue
FROM purchase_days
GROUP BY days_since_first_purchase
ORDER BY days_since_first_purchase;

-- Title: Customer Revenue by Cohort (Adjusted for time in market) - Only First Purchase Date
SELECT
    cohort_year,
    SUM(total_net_revenue) AS total_revenue,
    COUNT(DISTINCT customerkey) AS total_customers,
    SUM(total_net_revenue) / COUNT(DISTINCT customerkey) AS customer_revenue
FROM cohort_analysis
WHERE orderdate = first_purchase_date
GROUP BY 
    cohort_year;