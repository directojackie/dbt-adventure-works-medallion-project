
/*
    dbt model for productmodels table
*/

{{ config(materialized='table') }}


SELECT productModelId AS PRODUCT_MODEL_ID
     , name AS PRODUCT_MODEL_NAME
     , catalogDescription AS PRODUCT_MODEL_CATALOG_DESCRIPTION
     , instructions AS PRODUCT_MODEL_INSTRUCTIONS
     , CAST(modifiedDate AS DATE) AS MODIFIED_DATE
     , {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM {{ source('bronze_adworks_jaq_test', 'productmodels') }}
WHERE productModelId IS NOT NULL;