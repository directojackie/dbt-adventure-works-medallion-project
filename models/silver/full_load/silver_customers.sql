
/*
    dbt model for customers table
*/

{{ config(materialized='table') }}


SELECT customerId AS CUSTOMER_ID
    , personId AS PERSON_ID
    , storeId AS STORE_ID
    , territory AS TERRITORY
    , accountNumber AS ACCOUNT_NUMBER
    , CAST(modifiedDate AS DATE) AS MODIFIED_DATE
    , {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM {{ source('bronze_adworks_jaq_test', 'customers') }}
WHERE customerId IS NOT NULL;