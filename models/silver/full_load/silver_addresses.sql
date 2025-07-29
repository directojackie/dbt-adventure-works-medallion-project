/*
    dbt model for addresses table
*/

{{ config(materialized='table') }}


SELECT addressId AS ADDRESS_ID
    , CONCAT_WS(addressLine1, ' ', addressLine2) AS STREET
    , city AS CITY
    , state AS STATE
    , country AS COUNTRY
    , postalCode AS ZIPCODE
    , CAST(modifiedDate AS DATE) AS MODIFIED_DATE
    , {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM {{ source('bronze_adworks_jaq_test', 'addresses') }}
WHERE addressId IS NOT NULL;