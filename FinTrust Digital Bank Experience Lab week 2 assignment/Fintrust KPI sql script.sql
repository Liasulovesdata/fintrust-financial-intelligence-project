-- ================================================================
-- KPI's calculations 
-- ============================================================

-- 1. TOTAL_SUCCESSFUL_TRANSACTION_VALUE
SELECT
ROUND(SUM(amount_NGN),2) AS TOTAL_SUCCESSFUL_TRANSACTION_VALUE
FROM fintrust_transaction_data
WHERE transaction_status = 'successful';

-- ================================================================
-- 2. TOTAL_SUCCESSFUL_TRANSACTION_VOLUME
SELECT
COUNT(transaction_id) AS TOTAL_SUCCESSFUL_TRANSACTION_VOLUME
FROM fintrust_transaction_data
WHERE transaction_status = 'successful';

-- ================================================================
-- 3. AVERAGE_TRANSACTION_VALUE
SELECT 
ROUND(AVG(amount_NGN),2)
FROM fintrust_transaction_data
WHERE transaction_status = 'successful';

-- ================================================================
-- 4. SUCCESS_RATE
SELECT 
    ROUND(
        (SUM(CASE WHEN transaction_status = 'Successful' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
    2) AS success_rate_percent
FROM fintrust_transaction_data;

-- ================================================================
-- 5. Failed and Reversed Rate
SELECT 
    ROUND(
        (SUM(CASE WHEN transaction_status IN ('Failed', 'Reversed') THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
    2) AS failed_and_reversed_rate_percent,
    COUNT(*) AS total_transactions
FROM fintrust_transaction_data;

-- ================================================================
-- 6. Risk Review Flag Rate
SELECT DISTINCT risk_review_flag, COUNT(*) 
FROM fintrust_transaction_data
GROUP BY risk_review_flag;

-- ================================================================
-- 7. Active Account Rate
SELECT
customer_id,
customer_name
FROM fintrust_customers_data
WHERE account_status = 'active'
LIMIT 10;
SELECT 
    ROUND(
        (SUM(CASE WHEN account_status = 'Active' THEN 1 ELSE 0 END) / COUNT(DISTINCT customer_id)) * 100, 
    2) AS active_account_rate_percent,
    COUNT(DISTINCT customer_id) AS total_accounts
FROM fintrust_customers_data;

-- ================================================================
-- 8. Digital Channel Share
SELECT 
    ROUND(
        (SUM(CASE WHEN channel IN ('Mobile App', 'Web', 'USSD') THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
    2) AS digital_channel_share_percent,
    COUNT(*) AS total_transactions
FROM fintrust_transaction_data;