/* Transformation from Silver Layer to Gold Layer for customers model -> dim_customers */

{{ config(materialized='table') }}


SELECT 
    CUSTOMER_ID,
    PERSON_ID,
    STORE_ID,
    TERRITORY,
    ACCOUNT_NUMBER,
    MODIFIED_DATE AS CUSTOMER_MODIFIED_DATE,
    {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM {{ ref('silver_customers') }}
WHERE CUSTOMER_ID IS NOT NULL

