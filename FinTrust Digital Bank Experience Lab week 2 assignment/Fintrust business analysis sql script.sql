-- ================================================================
-- SQL Business Analysis
-- ==========================================================
-- ================================================================
-- BUSINESS QUESTION 1
-- ================================================================
-- Which customer segments, income bands and cities produce the most transaction volume and value?
SELECT 
customer_segment,
monthly_income_band,
city,
SUM(amount_NGN) AS total_transaction_value,
COUNT(transaction_id) AS total_transaction_volume
FROM fintrust_customers_data AS cd
JOIN fintrust_transaction_data AS td
	ON cd.customer_id = td.customer_id
GROUP BY customer_segment, monthly_income_band, city
ORDER BY total_transaction_value DESC, total_transaction_volume DESC;

-- ================================================================
-- BUSINES QUESTION 2
-- ================================================================
-- How do transaction volume and value change by month, day of week and hour of day?
SELECT
    YEAR(transaction_date) AS year,
    MONTH(transaction_date) AS month,
    DAYNAME(transaction_date) AS day_name,
    DAYOFWEEK(transaction_date) AS day_of_week, 
    SUM(amount_NGN) AS total_transaction_value,
    COUNT(transaction_id) AS total_transaction_volume
FROM fintrust_transaction_data
GROUP BY 
    YEAR(transaction_date), 
    MONTH(transaction_date), 
    DAYNAME(transaction_date), 
    DAYOFWEEK(transaction_date)
ORDER BY 
    year, 
    month,
	day_of_week;
    
-- ================================================================
-- BUSINES QUESTION 3
-- ================================================================
-- Which channels carry the most transactions and value, and how does that compare with customers' preferred channel?
SELECT 
    channel,
    preferred_channel,
    CASE WHEN channel = preferred_channel THEN 'Match' ELSE 'Mismatch' END AS preference_match,
    SUM(amount_NGN) AS total_value,
    COUNT(transaction_id) AS total_volume
FROM fintrust_transaction_data AS td
JOIN fintrust_customers_data AS cd
    ON td.customer_id = cd.customer_id
GROUP BY channel, preferred_channel
ORDER BY total_value DESC, total_volume DESC;

-- ================================================================
-- BUSINES QUESTION 4
-- ================================================================
-- What are the failed, reversed and pending rates by channel, transaction type and location?
-- ===========
-- By channel
-- ===========
SELECT
    channel,
    COUNT(*) AS total_transactions,
    ROUND(SUM(CASE WHEN transaction_status = 'Failed' THEN 1 ELSE 0 END)/ COUNT(*) * 100, 2) AS failed_rate_pct,
    ROUND(SUM(CASE WHEN transaction_status = 'Reversed' THEN 1 ELSE 0 END)/ COUNT(*) * 100, 2) AS reversed_rate_pct,
    ROUND(SUM(CASE WHEN transaction_status = 'Pending' THEN 1 ELSE 0 END)/ COUNT(*) * 100, 2) AS pending_rate_pct
FROM fintrust_transaction_data
GROUP BY channel
ORDER BY failed_rate_pct DESC;
-- ===========
-- By transaction
-- ===========
SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(CASE WHEN transaction_status = 'Failed' THEN 1 ELSE 0 END)/ COUNT(*) * 100, 2) AS failed_rate_pct,
    ROUND(SUM(CASE WHEN transaction_status = 'Reversed' THEN 1 ELSE 0 END)/ COUNT(*) * 100, 2) AS reversed_rate_pct,
    ROUND(SUM(CASE WHEN transaction_status = 'Pending' THEN 1 ELSE 0 END)/ COUNT(*) * 100, 2) AS pending_rate_pct
FROM fintrust_transaction_data
GROUP BY transaction_type
ORDER BY failed_rate_pct DESC;
-- ===========
-- By location
-- ===========
SELECT
    location,
    COUNT(*) AS total_transactions,
    ROUND(SUM(CASE WHEN transaction_status = 'Failed' THEN 1 ELSE 0 END)/ COUNT(*) * 100, 2) AS failed_rate_pct,
    ROUND(SUM(CASE WHEN transaction_status = 'Reversed' THEN 1 ELSE 0 END)/ COUNT(*) * 100, 2) AS reversed_rate_pct,
    ROUND(SUM(CASE WHEN transaction_status = 'Pending' THEN 1 ELSE 0 END)/ COUNT(*) * 100, 2) AS pending_rate_pct
FROM fintrust_transaction_data
GROUP BY location
ORDER BY failed_rate_pct DESC;

-- ================================================================
-- BUSINES QUESTION 5
-- Which transaction types make up most of the value, and how much comes from the top 1 to 5% of transactions?
-- ================================================================
SELECT
    transaction_type,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount_NGN), 2) AS total_transaction_value,
    ROUND(SUM(amount_NGN) / (SELECT SUM(amount_NGN) FROM fintrust_transaction_data) * 100,2
    ) AS value_share_pct
FROM fintrust_transaction_data
GROUP BY transaction_type
ORDER BY total_transaction_value DESC;

-- ================================================================
-- Business Question 6: What share of transactions is flagged for risk review, and how does it change by amount, transaction type, channel, and international status?
-- ============================================================
-- ===========
-- Overall risk-review rate
-- ===========
SELECT
COUNT(*) AS total_transactions,
SUM(CASE
        WHEN risk_review_flag = 'Yes' THEN 1
        ELSE 0
    END) AS flagged_transactions,
ROUND(SUM(CASE
            WHEN risk_review_flag = 'Yes' THEN 1
            ELSE 0
        END) / COUNT(*) * 100,2) AS risk_review_rate_pct
FROM fintrust_transaction_data;
-- ===========
-- Risk-review rate by transaction amount
-- ===========
SELECT
    CASE
        WHEN amount_NGN < 2193 THEN 'Low'
        WHEN amount_NGN < 10306 THEN 'Medium'
        WHEN amount_NGN < 48497 THEN 'High'
        ELSE 'Very High'
    END AS amount_band,
    COUNT(*) AS total_transactions,
    SUM(CASE
            WHEN risk_review_flag = 'Yes' THEN 1
            ELSE 0
        END
    ) AS flagged_transactions,
    ROUND(SUM(CASE
                WHEN risk_review_flag = 'Yes' THEN 1
                ELSE 0
            END) / COUNT(*) * 100,2) AS risk_review_rate_pct
FROM fintrust_transaction_data
GROUP BY
amount_band
ORDER BY
risk_review_rate_pct DESC;
-- ===========
-- Risk-review rate by transaction type
-- ===========
SELECT
transaction_type,
COUNT(*) AS total_transactions,
SUM(CASE
            WHEN risk_review_flag = 'Yes' THEN 1
            ELSE 0
        END) AS flagged_transactions,
ROUND(SUM(CASE
                WHEN risk_review_flag = 'Yes' THEN 1
                ELSE 0
            END) / COUNT(*) * 100,2) AS risk_review_rate_pct
FROM fintrust_transaction_data
GROUP BY
transaction_type
ORDER BY
risk_review_rate_pct DESC;
-- ===========
-- Risk-review rate by channel
-- ===========
SELECT
    channel,
COUNT(*) AS total_transactions,
SUM(CASE
            WHEN risk_review_flag = 'Yes' THEN 1
            ELSE 0
        END) AS flagged_transactions,
ROUND(SUM(CASE
                WHEN risk_review_flag = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS risk_review_rate_pct
FROM fintrust_transaction_data
GROUP BY
channel
ORDER BY
risk_review_rate_pct DESC;
-- ===========
-- Risk-review rate by international transaction status
-- ===========
SELECT
international_transfer,
COUNT(*) AS total_transactions,
SUM(CASE
            WHEN risk_review_flag = 'Yes' THEN 1
            ELSE 0
        END) AS flagged_transactions,
ROUND(SUM(CASE
                WHEN risk_review_flag = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2) AS risk_review_rate_pct
FROM fintrust_transaction_data
GROUP BY
international_transfer
ORDER BY
risk_review_rate_pct DESC;

-- ================================================================
-- Business Question 7: Do Dormant and Restricted accounts still transact, and how do engagement score and tenure relate to activity?
-- ============================================================
-- ===========
-- Transaction activity by account status
-- ===========
SELECT
    cd.account_status,
    COUNT(*) AS transaction_count,
    COUNT(DISTINCT cd.customer_id) AS active_customers,
    ROUND(SUM(td.amount_NGN), 2) AS total_transaction_value,
    ROUND(AVG(td.amount_NGN), 2) AS average_transaction_value
FROM fintrust_transaction_data AS td
JOIN fintrust_customers_data AS cd
    ON td.customer_id = cd.customer_id
GROUP BY
    cd.account_status
ORDER BY
    transaction_count DESC;
-- ===========
-- Transaction activity by digital engagement score
-- ===========
SELECT
    CASE
        WHEN c.digital_engagement_score < 25 THEN 'Low'
        WHEN c.digital_engagement_score < 50 THEN 'Medium'
        WHEN c.digital_engagement_score < 75 THEN 'High'
        ELSE 'Very High'
    END AS engagement_band,
    COUNT(*) AS transaction_count,
    COUNT(DISTINCT c.customer_id) AS active_customers,
    ROUND(SUM(t.amount_NGN), 2) AS total_transaction_value,
    ROUND(AVG(t.amount_NGN), 2) AS average_transaction_value
FROM fintrust_transaction_data AS t
JOIN customers AS c
    ON t.customer_id = c.customer_id
GROUP BY
    engagement_band
ORDER BY
    transaction_count DESC;
-- ===========
-- Transaction activity by customer tenure
-- ===========
SELECT
    CASE
        WHEN cd.tenure_months < 12 THEN 'Less than 1 year'
        WHEN cd.tenure_months < 36 THEN '1–3 years'
        WHEN cd.tenure_months < 60 THEN '3–5 years'
        ELSE '5+ years'
    END AS tenure_band,
    COUNT(*) AS transaction_count,
    COUNT(DISTINCT cd.customer_id) AS active_customers,
    ROUND(SUM(td.amount_NGN), 2) AS total_transaction_value,
    ROUND(AVG(td.amount_NGN), 2) AS average_transaction_value
FROM fintrust_transaction_data AS td
JOIN fintrust_customers_data AS cd
    ON td.customer_id = cd.customer_id
GROUP BY
    tenure_band
ORDER BY
    transaction_count DESC;
    
-- ================================================================
-- Business Question 8: 
-- ============================================================