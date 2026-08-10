use [RetailBank];
go

-------------------------------
-- Bronze Layer Validation
-------------------------------

-------Customers 

---------- 1. NULL Check ----------

SELECT 
     SUM(CASE WHEN customer_id IS NULL OR customer_id='' THEN 1 ELSE 0 END) AS blank_id,
	 SUM(CASE WHEN first_name IS NULL OR first_name='' THEN 1 ELSE 0 END) AS blank_first_name,
	 SUM(CASE WHEN last_name  IS NULL OR last_name ='' THEN 1 ELSE 0 END) AS blank_last_name ,
	 SUM(CASE WHEN gender  IS NULL OR gender ='' THEN 1 ELSE 0 END) AS blank_gender ,
	 SUM(CASE WHEN job IS NULL OR job='' THEN 1 ELSE 0 END) AS blank_job,
	 SUM(CASE WHEN loyalty_tier IS NULL OR loyalty_tier = '' THEN 1 ELSE 0 END) AS blank_loyalty_tier,
	 SUM(CASE WHEN email_domain IS NULL OR email_domain = '' THEN 1 ELSE 0 END) AS blank_email_domain,
	 SUM(CASE WHEN city IS NULL OR city = '' THEN 1 ELSE 0 END) AS blank_city,
     SUM(CASE WHEN state IS NULL OR state = '' THEN 1 ELSE 0 END) AS blank_email_state,
	 SUM(CASE WHEN dob IS NULL OR dob = '' THEN 1 ELSE 0 END) AS blank_dob,
	 SUM(CASE WHEN signup_date IS NULL OR signup_date = '' THEN 1 ELSE 0 END) AS blank_signup_date
FROM Bronze.Customers;;

---------- 2. Investigate NULL Values ----------

SELECT *
FROM Bronze.Customers
WHERE job IS NULL
   OR LTRIM(RTRIM(job)) = '';

SELECT *
FROM Bronze.Customers
WHERE loyalty_tier IS NULL
   OR LTRIM(RTRIM(loyalty_tier)) = '';

---------- 3. TRY_CAST Validation ----------

SELECT *
FROM Bronze.Customers
WHERE TRY_CAST(customer_id AS INT) IS NULL;

SELECT *
FROM Bronze.Customers
WHERE TRY_CAST(cc_num AS BIGINT) IS NULL;

SELECT *
FROM Bronze.Customers
WHERE TRY_CAST(zip AS INT) IS NULL;

SELECT *
FROM Bronze.Customers
WHERE TRY_CAST(city_pop AS INT) IS NULL;

SELECT *
FROM Bronze.Customers
WHERE TRY_CAST(dob AS DATE) IS NULL;

SELECT *
FROM Bronze.Customers
WHERE TRY_CAST(signup_date AS DATE) IS NULL;

---------- 4. Inconsistent Categorical Values ----------

SELECT
    gender,
    COUNT(*) AS CNT
FROM Bronze.Customers
GROUP BY gender
ORDER BY CNT DESC;

SELECT
    state,
    COUNT(*) AS CNT
FROM Bronze.Customers
GROUP BY state
ORDER BY CNT DESC;

---------- 5. Duplicate Check ----------

Select 
   customer_id,
   count(*) AS CNT
from Bronze.Customers
group by (customer_id)
having count(*) >1

---------- 6. Total Row Count ----------

SELECT COUNT(*) AS Total_Rows
FROM Bronze.Customers;


-------------Merchants Validation

---------- 1. NULL Check ----------
SELECT 
     SUM(CASE WHEN merchant_id IS NULL OR merchant_id='' THEN 1 ELSE 0 END) AS blank_id,
	 SUM(CASE WHEN merchant_name IS NULL OR merchant_name='' THEN 1 ELSE 0 END) AS blank_merchant_name,
	 SUM(CASE WHEN dominant_category  IS NULL OR dominant_category ='' THEN 1 ELSE 0 END) AS blank_dominant_category ,
	 SUM(CASE WHEN merchant_city  IS NULL OR merchant_city ='' THEN 1 ELSE 0 END) AS blank_merchant_city ,
	 SUM(CASE WHEN merchant_state IS NULL OR merchant_state='' THEN 1 ELSE 0 END) AS blank_merchant_state,
	 SUM(CASE WHEN merchant_since IS NULL OR merchant_since = '' THEN 1 ELSE 0 END) AS blank_merchant_since,
	 SUM(CASE WHEN is_active IS NULL OR is_active = '' THEN 1 ELSE 0 END) AS blank_is_active
FROM Bronze.Merchants;

---------- 2. Investigate NULL Values ----------

SELECT *
FROM Bronze.Merchants
WHERE merchant_city IS NULL
   OR LTRIM(RTRIM(merchant_city)) = '';

---------- 3. TRY_CAST Validation ----------

SELECT *
FROM Bronze.Merchants
WHERE TRY_CAST(merchant_id AS INT) IS NULL;

SELECT *
FROM Bronze.Merchants
WHERE TRY_CAST(merchant_lat AS DECIMAL(10,6)) IS NULL;

SELECT *
FROM Bronze.Merchants
WHERE TRY_CAST(merchant_long AS DECIMAL(10,6)) IS NULL;

SELECT *
FROM Bronze.Merchants
WHERE TRY_CAST(merchant_since AS DATE) IS NULL;

SELECT *
FROM Bronze.Merchants
WHERE TRY_CAST(is_active AS INT) IS NULL;

---------- 4. Inconsistent Categorical Values ----------
SELECT
    dominant_category,
    COUNT(*) AS CNT
FROM Bronze.Merchants
GROUP BY dominant_category
ORDER BY CNT DESC;

SELECT
    merchant_state,
    COUNT(*) AS CNT
FROM Bronze.Merchants
GROUP BY merchant_state
ORDER BY CNT DESC;

SELECT
    is_active,
    COUNT(*) AS CNT
FROM Bronze.Merchants
GROUP BY is_active
ORDER BY CNT DESC;

---------- 5. Duplicate Check ----------

SELECT
    merchant_id,
    COUNT(*) AS CNT
FROM Bronze.Merchants
GROUP BY merchant_id
HAVING COUNT(*) > 1;

---------- 6. Total Row Count ---------- 

SELECT COUNT(*) AS Total_Rows
FROM [Bronze].[Merchants];

----Transactions

---------- 1. NULL Check ----------

SELECT
    SUM(CASE WHEN transaction_id IS NULL OR LTRIM(RTRIM(transaction_id))='' THEN 1 ELSE 0 END) AS blank_transaction_id,

    SUM(CASE WHEN trans_date_trans_time IS NULL OR LTRIM(RTRIM(trans_date_trans_time))='' THEN 1 ELSE 0 END) AS blank_transaction_date,

    SUM(CASE WHEN customer_id IS NULL OR LTRIM(RTRIM(customer_id))='' THEN 1 ELSE 0 END) AS blank_customer_id,

    SUM(CASE WHEN merchant_id IS NULL OR LTRIM(RTRIM(merchant_id))='' THEN 1 ELSE 0 END) AS blank_merchant_id,

    SUM(CASE WHEN amt IS NULL OR LTRIM(RTRIM(amt))='' THEN 1 ELSE 0 END) AS blank_amount,

    SUM(CASE WHEN currency IS NULL OR LTRIM(RTRIM(currency))='' THEN 1 ELSE 0 END) AS blank_currency,

    SUM(CASE WHEN payment_method IS NULL OR LTRIM(RTRIM(payment_method))='' THEN 1 ELSE 0 END) AS blank_payment_method,

    SUM(CASE WHEN channel IS NULL OR LTRIM(RTRIM(channel))='' THEN 1 ELSE 0 END) AS blank_channel,

    SUM(CASE WHEN transaction_status IS NULL OR LTRIM(RTRIM(transaction_status))='' THEN 1 ELSE 0 END) AS blank_transaction_status,

    SUM(CASE WHEN is_fraud IS NULL OR LTRIM(RTRIM(is_fraud))='' THEN 1 ELSE 0 END) AS blank_is_fraud

FROM Bronze.Transactions;

-----------2. TRY_CAST Validation----------
SELECT
SUM(CASE WHEN TRY_CAST(transaction_id AS INT) IS NULL THEN 1 ELSE 0 END) AS invalid_transaction_id
FROM Bronze.Transactions;

SELECT
SUM(CASE WHEN TRY_CAST(trans_date_trans_time AS DATETIME) IS NULL THEN 1 ELSE 0 END) AS invalid_transaction_date
FROM Bronze.Transactions;

SELECT
SUM(CASE WHEN TRY_CAST(customer_id AS INT) IS NULL THEN 1 ELSE 0 END) AS invalid_customer_id
FROM Bronze.Transactions;

SELECT
SUM(CASE WHEN TRY_CAST(merchant_id AS INT) IS NULL THEN 1 ELSE 0 END) AS invalid_merchant_id
FROM Bronze.Transactions;

SELECT
SUM(CASE WHEN TRY_CAST(amt AS DECIMAL(10,2)) IS NULL THEN 1 ELSE 0 END) AS invalid_amt
FROM Bronze.Transactions;

SELECT
SUM(CASE WHEN TRY_CAST(is_fraud AS INT) IS NULL THEN 1 ELSE 0 END) AS invalid_is_fraud
FROM Bronze.Transactions;

----------3. Inconsistent Categorical Values----------
SELECT
    category,
    COUNT(*) AS CNT
FROM Bronze.Transactions
GROUP BY category
ORDER BY CNT DESC;

SELECT
    currency,
    COUNT(*) AS CNT
FROM Bronze.Transactions
GROUP BY currency
ORDER BY CNT DESC;

SELECT
    payment_method,
    COUNT(*) AS CNT
FROM Bronze.Transactions
GROUP BY payment_method
ORDER BY CNT DESC;

SELECT
    channel,
    COUNT(*) AS CNT
FROM Bronze.Transactions
GROUP BY channel
ORDER BY CNT DESC;

SELECT
    transaction_status,
    COUNT(*) AS CNT
FROM Bronze.Transactions
GROUP BY transaction_status
ORDER BY CNT DESC;

SELECT
    is_fraud,
    COUNT(*) AS CNT
FROM Bronze.Transactions
GROUP BY is_fraud
ORDER BY CNT DESC;

---------- 4. Orphan Records ----------

SELECT COUNT(*) AS orphan_customers
FROM Bronze.Transactions t
LEFT JOIN Bronze.Customers c
ON TRY_CAST(t.customer_id AS INT)=TRY_CAST(c.customer_id AS INT)
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS orphan_merchants
FROM Bronze.Transactions t
LEFT JOIN Bronze.Merchants m
ON TRY_CAST(t.merchant_id AS INT)=TRY_CAST(m.merchant_id AS INT)
WHERE m.merchant_id IS NULL;

---------- 5. Duplicate Check ----------

SELECT
    transaction_id,
    COUNT(*) AS CNT
FROM Bronze.Transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;

---------- 6. Total Row Count ----------
SELECT COUNT(*) AS Total_Rows
FROM Bronze.Transactions;

