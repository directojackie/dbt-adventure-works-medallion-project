
/*
    dbt model for productdescriptions table
*/

{{ config(materialized='table') }}


SELECT productDescriptionId AS PRODUCT_DESCRIPTION_ID
     , description AS PRODUCT_DESCRIPTION
     , cultureCode AS CULTURE_CODE
     , CAST(modifiedDate AS DATE) AS MODIFIED_DATE
     , {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM {{ source('bronze_adworks_jaq_test', 'productdescriptions') }}
WHERE productDescriptionId IS NOT NULL;