CREATE DATABASE fintrust_database;
USE fintrust_database;

CREATE TABLE fintrust_customers_data (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(50),
    age INT,
    gender VARCHAR(50),
    city VARCHAR(20),
    customer_segment VARCHAR(50),
    account_type VARCHAR(50),
    tenure_months INT,
    digital_engagement_score DECIMAL(6,2),
    monthly_income_band VARCHAR(100),
    preferred_channel VARCHAR(50),
    account_status VARCHAR(50)
);

LOAD DATA LOCAL INFILE "C:/Users/USER/Downloads/FinTrust_Customer_Data - FinTrust_Customer_Data(in) (1).csv"
INTO TABLE fintrust_customers_data
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
show warnings;
SELECT *
FROM fintrust_customers_data;
DROP TABLE fintrust_customers_data;

CREATE TABLE fintrust_transaction_data (
    transaction_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    transaction_date DATE,
    transaction_type VARCHAR(50),
    amount_NGN DECIMAL(15,2),
    channel VARCHAR(20),
    device_type VARCHAR(50),
    location VARCHAR(50),
    international_transfer VARCHAR(50),
    transaction_status VARCHAR(50),
    risk_review_flag VARCHAR(100)
   
);

LOAD DATA LOCAL INFILE "C:/Users/USER/Downloads/FinTrust_Transaction_Data - FinTrust_Transaction_Data 2(in) (1).csv"
INTO TABLE fintrust_transaction_data
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

show warnings;
SELECT *
FROM fintrust_transaction_data;
DROP TABLE fintrust_transaction_data;