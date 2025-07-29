/* Transformation from Silver Layer to Gold Layer for customers and stores model -> dim_stores */

{{ config(materialized='table') }}

WITH customers AS (
    SELECT CUSTOMER_ID,
        PERSON_ID,
        STORE_ID,
        TERRITORY,
        ACCOUNT_NUMBER,
        MODIFIED_DATE AS CUSTOMER_MODIFIED_DATE, {{ convert_to_wa_time() }} AS CUSTOMER_UPDATE_DATE
    FROM {{ ref('silver_customers') }}
    WHERE CUSTOMER_ID IS NOT NULL
),

stores AS (
    SELECT STORE_ID,
        STORE_NAME,
        SALES_PERSON_ID,
        ANNUAL_SALES AS ANNUAL_SALES,
        ANNUAL_REVENUE AS ANNUAL_REVENUE,
        BANK_NAME,
        BUSINESS_TYPE,
        YEAR_OPENED,
        SPECIALTY,
        SQUARE_FEET,
        BRANDS,
        INTERNET,
        NUMBER_EMPLOYEES,
        MODIFIED_DATE AS STORE_MODIFIED_DATE, {{ convert_to_wa_time() }} AS STORE_UPDATE_DATE
    FROM {{ ref('silver_stores') }}
    WHERE STORE_ID IS NOT NULL
)

SELECT 
    c.CUSTOMER_ID,
    c.PERSON_ID,
    c.STORE_ID,
    c.TERRITORY,
    c.ACCOUNT_NUMBER,
    c.CUSTOMER_MODIFIED_DATE,
    c.CUSTOMER_UPDATE_DATE,
    s.STORE_NAME,
    s.SALES_PERSON_ID,
    s.ANNUAL_SALES,
    s.ANNUAL_REVENUE,
    s.BANK_NAME,
    s.BUSINESS_TYPE,
    s.YEAR_OPENED,
    s.SPECIALTY,
    s.SQUARE_FEET,
    s.BRANDS,
    s.INTERNET,
    s.NUMBER_EMPLOYEES,
    s.STORE_MODIFIED_DATE,
    s.STORE_UPDATE_DATE, {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM customers c
LEFT JOIN stores s ON c.STORE_ID = s.STORE_ID;
