
/*
    dbt model for productcategories table
*/

{{ config(materialized='table') }}


SELECT CAST(productCategoryId AS INTEGER) AS PRODUCT_CATEGORY_ID
     , name AS PRODUCT_CATEGORY_NAME
     , CAST(modifiedDate AS DATE) AS MODIFIED_DATE
     , {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM {{ source('bronze_adworks_jaq_test', 'productcategories') }}
WHERE productCategoryId IS NOT NULL;