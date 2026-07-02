-- ============================================================
-- Bank Customer Churn Analytics — SQL Metrics (PostgreSQL)
-- ============================================================
-- Load data/Customer.csv into a table named bank_churn before
-- running these queries. Example load statement is at the
-- bottom of this file.

-- ------------------------------------------------------------
-- 1. Overall churn rate
-- ------------------------------------------------------------
SELECT ROUND(AVG(churn) * 100, 2) AS churn_rate
FROM bank_churn;
-- Result: 20.37%

-- ------------------------------------------------------------
-- 2. Churn rate by geography
-- ------------------------------------------------------------
SELECT country,
       COUNT(*)                       AS total_customers,
       ROUND(AVG(churn) * 100, 2)     AS churn_rate
FROM bank_churn
GROUP BY country
ORDER BY churn_rate DESC;
-- Result: Germany (32.44%), Spain (16.67%), France (16.15%)

-- ------------------------------------------------------------
-- 3. Churn rate by active membership status
-- ------------------------------------------------------------
SELECT active_member,
       ROUND(AVG(churn) * 100, 2) AS churn_rate
FROM bank_churn
GROUP BY active_member;
-- Result: Inactive (26.85%), Active (14.27%)

-- ------------------------------------------------------------
-- 4. Churn rate by number of products held
-- ------------------------------------------------------------
SELECT products_number,
       COUNT(*)                   AS total_customers,
       ROUND(AVG(churn) * 100, 2) AS churn_rate
FROM bank_churn
GROUP BY products_number
ORDER BY products_number;
-- Result: 1 Product (27.71%), 2 Products (7.58%),
--         3 Products (82.71%), 4 Products (100.00%)

-- ------------------------------------------------------------
-- 5. Average age of churned vs. retained customers
-- ------------------------------------------------------------
SELECT churn,
       ROUND(AVG(age), 1) AS avg_age,
       COUNT(*)           AS customers
FROM bank_churn
GROUP BY churn;
-- Result: Retained avg age 37.4, Churned avg age 44.8

-- ------------------------------------------------------------
-- 6. Churn rate by gender
-- ------------------------------------------------------------
SELECT gender,
       ROUND(AVG(churn) * 100, 2) AS churn_rate
FROM bank_churn
GROUP BY gender
ORDER BY churn_rate DESC;

-- ------------------------------------------------------------
-- 7. Credit-card ownership vs churn
-- ------------------------------------------------------------
SELECT credit_card,
       ROUND(AVG(churn) * 100, 2) AS churn_rate
FROM bank_churn
GROUP BY credit_card;

-- ------------------------------------------------------------
-- 8. Balance tier vs churn (quartile buckets)
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN balance = 0 THEN 'Zero Balance'
        WHEN balance < 100000 THEN 'Under 100K'
        WHEN balance < 150000 THEN '100K - 150K'
        ELSE '150K+'
    END AS balance_tier,
    COUNT(*)                   AS total_customers,
    ROUND(AVG(churn) * 100, 2) AS churn_rate
FROM bank_churn
GROUP BY balance_tier
ORDER BY churn_rate DESC;

-- ------------------------------------------------------------
-- 9. High-risk customer segment (inactive + Germany + 1 or 3+ products)
--    Useful as the seed query for a targeted retention campaign list.
-- ------------------------------------------------------------
SELECT customer_id, credit_score, age, balance, products_number, estimated_salary
FROM bank_churn
WHERE active_member = 0
  AND country = 'Germany'
  AND (products_number = 1 OR products_number >= 3)
ORDER BY balance DESC;

-- ------------------------------------------------------------
-- Example table creation + load (adjust path for your machine)
-- ------------------------------------------------------------
-- CREATE TABLE bank_churn (
--     customer_id       BIGINT PRIMARY KEY,
--     credit_score      INT,
--     country            VARCHAR(20),
--     gender             VARCHAR(10),
--     age                INT,
--     tenure             INT,
--     balance            NUMERIC(14,2),
--     products_number    INT,
--     credit_card        SMALLINT,
--     active_member      SMALLINT,
--     estimated_salary   NUMERIC(14,2),
--     churn              SMALLINT
-- );
--
-- COPY bank_churn FROM '/path/to/data/Customer.csv' DELIMITER ',' CSV HEADER;
