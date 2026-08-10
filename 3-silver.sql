
--------------- silver.customers-------------------------------
SELECT
    TRY_CAST(customer_id AS INT)                                    AS customer_id,
    TRY_CAST(cc_num AS BIGINT)                                      AS cc_num,
    LTRIM(RTRIM(first_name))                                        AS first_name,
    LTRIM(RTRIM(last_name))                                         AS last_name,
    LTRIM(RTRIM(gender))                                            AS gender,
    LTRIM(RTRIM(street))                                            AS street,
    LTRIM(RTRIM(city))                                              AS city,
    LTRIM(RTRIM(state))                                             AS state,
    TRY_CAST(TRY_CAST(zip AS FLOAT) AS INT)                         AS zip,
    TRY_CAST(lat AS DECIMAL(10,6))                                  AS lat,
    TRY_CAST([long] AS DECIMAL(10,6))                               AS [long],
    TRY_CAST(city_pop AS INT)                                       AS city_pop,
    ISNULL(NULLIF(LTRIM(RTRIM(job)), ''), 'Unknown')                AS job,
    TRY_CAST(dob AS DATE)                                           AS dob,
    ISNULL(NULLIF(LTRIM(RTRIM(loyalty_tier)), ''), 'Unknown')        AS loyalty_tier,
    LTRIM(RTRIM(email_domain))                                      AS email_domain,
    TRY_CAST(signup_date AS DATE)                                   AS signup_date

INTO Silver.Customers
FROM Bronze.Customers;

ALTER TABLE Silver.Customers ALTER COLUMN customer_id INT NOT NULL;

ALTER TABLE Silver.Customers
ADD CONSTRAINT PK_silver_Customers
PRIMARY KEY (customer_id);

--------------- silver.merchants-------------------------------

SELECT
    TRY_CAST(merchant_id AS INT)                             AS merchant_id,
    LTRIM(RTRIM(merchant_name))                              AS merchant_name,
    LTRIM(RTRIM(dominant_category))                          AS dominant_category,
    ISNULL(NULLIF(LTRIM(RTRIM(merchant_city)), ''), 'Unknown') AS merchant_city,
    LTRIM(RTRIM(merchant_state))                             AS merchant_state,
    TRY_CAST(merchant_lat AS DECIMAL(10,6))                  AS merchant_lat,
    TRY_CAST(merchant_long AS DECIMAL(10,6))                 AS merchant_long,
    TRY_CAST(merchant_since AS DATE)                         AS merchant_since,
    TRY_CAST(is_active AS BIT)                               AS is_active

INTO Silver.Merchants
FROM Bronze.Merchants;

ALTER TABLE Silver.Merchants ALTER COLUMN Merchant_id INT NOT NULL;

ALTER TABLE Silver.Merchants
ADD CONSTRAINT PK_Merchants
PRIMARY KEY (merchant_id);

--------------- silver.transactions-------------------------------


SELECT
    TRY_CAST(transaction_id AS INT)                  AS transaction_id,
    TRY_CAST(trans_date_trans_time AS DATETIME)      AS trans_date_trans_time,
    TRY_CAST(customer_id AS INT)                     AS customer_id,
    TRY_CAST(merchant_id AS INT)                     AS merchant_id,
    LTRIM(RTRIM(category))                           AS category,
    TRY_CAST(amt AS DECIMAL(10,2))                   AS amt,
    TRY_CAST(tax_amt AS DECIMAL(10,2))               AS tax_amt,
    TRY_CAST(discount_amt AS DECIMAL(10,2))          AS discount_amt,
    LTRIM(RTRIM(currency))                           AS currency,
    LTRIM(RTRIM(payment_method))                     AS payment_method,
    LTRIM(RTRIM(channel))                            AS channel,
    LTRIM(RTRIM(entry_mode))                         AS entry_mode,
    LTRIM(RTRIM(device_type))                        AS device_type,
    LTRIM(RTRIM(transaction_status))                 AS transaction_status,
    LTRIM(RTRIM(trans_num))                          AS trans_num,
    LTRIM(RTRIM(session_id))                         AS session_id,
    TRY_CAST(unix_time AS BIGINT)                    AS unix_time,
    TRY_CAST(is_fraud AS BIT)                        AS is_fraud

INTO Silver.Transactions
FROM Bronze.Transactions;

ALTER TABLE Silver.Transactions ALTER COLUMN transaction_id INT NOT NULL;

ALTER TABLE Silver.Transactions
ADD CONSTRAINT PK_Transactions
PRIMARY KEY (transaction_id);

ALTER TABLE Silver.Transactions
ADD CONSTRAINT FK_Transactions_Customers
FOREIGN KEY (customer_id)
REFERENCES Silver.Customers(customer_id);

ALTER TABLE Silver.Transactions
ADD CONSTRAINT FK_Transactions_Merchants
FOREIGN KEY (merchant_id)
REFERENCES Silver.Merchants(merchant_id);

SELECT TOP (10) *
FROM Silver.Customers;

SELECT TOP (10) *
FROM Silver.Merchants;

SELECT TOP (10) *
FROM Silver.Transactions;
