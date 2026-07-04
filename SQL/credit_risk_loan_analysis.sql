CREATE TABLE loan_data (
    loan_id VARCHAR(20) PRIMARY KEY,
    no_of_dependents INT,
    education VARCHAR(50),
    self_employed VARCHAR(10),
    income_annum BIGINT,
    loan_amount BIGINT,
    loan_term INT,
    cibil_score INT,
    residential_assets_value BIGINT,
    commercial_assets_value BIGINT,
    loan_status VARCHAR(20),
    total_assets BIGINT,
    loan_to_income_ratio NUMERIC(10,2),
    loan_to_asset_ratio NUMERIC(10,2),
    cibil_category VARCHAR(20),
    risk_level VARCHAR(20)
);

--Total Loan Applications--
SELECT COUNT(*)   AS total_applications
FROM loan_data;

-- Approval Rate--
SELECT
ROUND(
    COUNT(CASE WHEN loan_status = ' Approved' THEN 1 END) * 100.0
    / COUNT(*),
    2
) AS approval_rate
FROM loan_data;

-- Average Loan Amount--
SELECT ROUND(AVG(loan_amount)) as avg_loan_amt
FROM loan_data;

-- Average Annual Income --
SELECT ROUND(AVG(income_annum)) as avg_income
FROM loan_data;

--Approved vs Rejected Loans--
SELECT loan_status, COUNT(loan_status) as total
FROM loan_data
GROUP BY loan_status;

--Approval Rate by Education--
SELECT
education,
COUNT(*) FILTER (WHERE loan_status=' Approved') AS approved,
COUNT(*) FILTER (WHERE loan_status=' Rejected') AS rejected
FROM loan_data
GROUP BY education;

--Approval Rate by Self Employment--
SELECT
self_employed,
COUNT(*) FILTER (WHERE loan_status=' Approved') AS approved,
COUNT(*) FILTER (WHERE loan_status=' Rejected') AS rejected
FROM loan_data
GROUP BY self_employed;

-- Loan Status by CIBIL Category --
SELECT loan_status, cibil_category,
COUNT(*) as total
FROM loan_data
GROUP BY loan_status, cibil_category;

-- Average Loan Amount by Risk Level --
SELECT risk_level, ROUND(AVG(loan_amount),2) as avg_loan_amt
FROM loan_data
GROUP BY risk_level;

-- Average Income by Risk Level --
SELECT risk_level, ROUND(AVG(income_annum),2) as avg_income
FROM loan_data
GROUP BY risk_level;

--Total Assets by Risk Level--
SELECT risk_level, ROUND(sum(total_assets),2) as total_assets
FROM loan_data
GROUP BY risk_level;

-- Applicants with Above Average Income
SELECT * FROM loan_data
WHERE income_annum > (
 SELECT ROUND(AVG(income_annum),2) as avg_income
 FROM loan_data);

-- Top 10 Applicants by Loan Amount-
SELECT loan_amount, loan_id
FROM loan_data 
ORDER BY loan_amount DESC
LIMIT 10;

--Rank Applicants by Income --
SELECT loan_id, income_annum,
RANK() OVER(ORDER BY income_annum DESC)AS income_rank
FROM loan_data;

-- Income Groups Using CASE --
SELECT loan_id, income_annum,
CASE 
WHEN income_annum < 5000000 THEN 'Low Income'
WHEN income_annum BETWEEN 5000000 AND 10000000 THEN 'Middle Income'
ELSE 'High Income'
END AS income_group
FROM loan_data;

