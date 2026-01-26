CREATE DATABASE streaming_services;

USE streaming_services;

SELECT * FROM stream_services
LIMIT 10;
-- gauging data from tables

SELECT service_name, monthly_price_usd, annual_price_usd, subscribers_millions FROM stream_services;
-- pull columns of interest 

SELECT service_name, monthly_price_usd, annual_price_usd, subscribers_millions FROM stream_services
ORDER BY subscribers_millions desc;
-- Determining the subscriber count of each streaming service in descending order

SELECT service_name, monthly_price_usd, annual_price_usd, subscribers_millions FROM stream_services
ORDER BY monthly_price_usd desc;
-- Determining the highest monthly price for each subscription

SELECT service_name, monthly_price_usd, subscribers_millions, monthly_price_usd * subscribers_millions as Monthly_revenue_millions FROM stream_services
ORDER BY monthly_revenue_millions desc;
-- Determining which companies make the most monthly revenue 

SELECT service_name, annual_price_usd, subscribers_millions, annual_price_usd * subscribers_millions as annual_revenue_millions FROM Stream_services
ORDER BY annual_revenue_millions desc;
-- Determining which companies make the most annual revenue 

SELECT service_name, 
annual_price_usd, monthly_price_usd, 
subscribers_millions, 
(monthly_price_usd * subscribers_millions)*12 as Annual_Monthly_revenue_millions, 
annual_price_usd * subscribers_millions as annual_revenue_millions FROM Stream_services
ORDER BY annual_revenue_millions desc;
-- Comparing the annual monthly revenue services get if their monthly revnue was annual, and annual revenue itself. 

SELECT service_name, 
annual_price_usd, monthly_price_usd, 
subscribers_millions, 
(monthly_price_usd * subscribers_millions)*12 as Annual_Monthly_revenue_millions, 
annual_price_usd * subscribers_millions as annual_revenue_millions,
churn_rate_pct FROM Stream_services
ORDER BY churn_rate_pct asc;
-- Observing churn rates for streaming services with comparisons to annual revenue and monthly million annual revenue

SELECT service_name, 
annual_price_usd, monthly_price_usd, 
subscribers_millions, 
(monthly_price_usd * subscribers_millions)*12 as Annual_Monthly_revenue_millions, 
annual_price_usd * subscribers_millions as annual_revenue_millions,
annual_price_usd * subscribers_millions  - (monthly_price_usd * subscribers_millions)*12 as difference_in_revenue_millions,
churn_rate_pct FROM Stream_services
ORDER BY churn_rate_pct asc;
-- Determing the difference in revenue services gain by offering annual plan

SELECT service_name, 
    annual_price_usd, 
    monthly_price_usd, 
    -- This calculates the exact months then rounds DOWN
    FLOOR(annual_price_usd / monthly_price_usd) as full_months_to_breakeven,
    churn_rate_pct 
FROM Stream_services
ORDER BY churn_rate_pct ASC;
-- determining how many months it takes for services to break even with annual revenue. 

SELECT service_name, 
    annual_price_usd, 
    monthly_price_usd, 
     churn_rate_pct,
   ROUND(subscribers_millions / (SELECT SUM(subscribers_millions) FROM stream_services) * 100, 
    2) AS market_share_percent
    FROM stream_services
    ORDER BY market_share_percent DESC;
-- Determing market share of each streaming service in descending order

SELECT service_name, 
       subscribers_millions * (churn_rate_pct / 100) AS monthly_subs_lost_millions,
       (subscribers_millions * (churn_rate_pct / 100)) * monthly_price_usd AS monthly_revenue_lost_millions
FROM stream_services
ORDER BY monthly_revenue_lost_millions DESC;

SELECT service_name, 
       churn_rate_pct,
       CASE 
           WHEN churn_rate_pct < 2.0 THEN 'Market Leader (High Retention)'
           WHEN churn_rate_pct BETWEEN 2.0 AND 2.5 THEN 'Stable'
           ELSE 'High Risk (Churn Heavy)'
       END AS retention_category
FROM stream_services;

CREATE OR REPLACE VIEW stream_services_vis AS
SELECT 
    service_name,
    subscribers_millions,
    churn_rate_pct,
    annual_price_usd, 
    (monthly_price_usd * 12 * subscribers_millions) AS potential_12_month_monthly_revenue,
    (annual_price_usd - (monthly_price_usd * 12)) AS annual_discount_amount,
    ROUND(((monthly_price_usd * 12 - annual_price_usd) / (monthly_price_usd * 12)) * 100, 2) AS discount_percentage,
    (subscribers_millions * annual_price_usd) AS guaranteed_annual_revenue,
    ROUND(subscribers_millions * (churn_rate_pct / 100) * monthly_price_usd, 2) AS monthly_churn_revenue_loss
    FROM stream_services;
    
SHOW FULL TABLES
WHERE Table_type = 'VIEW';



