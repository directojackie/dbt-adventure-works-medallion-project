/* Transformation from Silver Layer to Gold Layer for customers and persons model -> dim_customers */

{{ config(materialized='table') }}

WITH customers AS (
    SELECT 
        CUSTOMER_ID,
        PERSON_ID,
        STORE_ID,
        TERRITORY,
        ACCOUNT_NUMBER,
        MODIFIED_DATE AS CUSTOMER_MODIFIED_DATE,
        {{ convert_to_wa_time() }} AS CUSTOMER_UPDATE_DATE
    FROM {{ ref('silver_customers') }}
    WHERE CUSTOMER_ID IS NOT NULL
),

persons AS (
    SELECT 
        PERSON_ID,
        FULL_NAME,
        TITLE,
        FIRST_NAME,
        MIDDLE_NAME,
        LAST_NAME,
        SUFFIX,
        PERSON_TYPE,
        NAME_STYLE,
        EMAIL_PROMOTION,
        ADDITIONAL_CONTACT_INFO,
        TOTAL_PURCHASE_YTD,
        MODIFIED_DATE AS PERSON_MODIFIED_DATE,
        {{ convert_to_wa_time() }} AS PERSON_UPDATE_DATE
    FROM {{ ref('silver_persons') }}
    WHERE PERSON_ID IS NOT NULL
)

SELECT 
    c.CUSTOMER_ID,
    c.PERSON_ID,
    c.STORE_ID,
    c.TERRITORY,
    c.ACCOUNT_NUMBER,
    p.FULL_NAME,
    p.TITLE,
    p.FIRST_NAME,
    p.MIDDLE_NAME,
    p.LAST_NAME,
    p.SUFFIX,
    p.PERSON_TYPE,
    p.NAME_STYLE,
    p.EMAIL_PROMOTION,
    p.ADDITIONAL_CONTACT_INFO,
    p.TOTAL_PURCHASE_YTD,
    p.PERSON_MODIFIED_DATE,
    c.CUSTOMER_MODIFIED_DATE,
    {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM customers c
LEFT JOIN persons p 
    ON c.PERSON_ID = p.PERSON_ID;
