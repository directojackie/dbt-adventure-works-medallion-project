
/*
    dbt model for products table
*/

{{ config(materialized='table') }}


SELECT productId AS PRODUCT_ID
     , name AS PRODUCT_NAME
     , productNumber AS PRODUCT_NUMBER
     , isManufactured AS IS_MANUFACTURED
     , isSaleable AS IS_SALEABLE
     , color AS PRODUCT_COLOR
     , safetyStockLevel AS SAFETY_STOCK_LEVEL
     , reorderPoint AS REORDER_POINT
     , standardCost AS STANDARD_COST
     , listPrice AS LIST_PRICE
     , size AS PRODUCT_SIZE
     , sizeUnit AS PRODUCT_SIZE_UNIT
     , weightUnit AS PRODUCT_WEIGHT_UNIT
     , weight AS PRODUCT_WEIGHT
     , daysToManufacture AS DAYS_TO_MANUFACTURE
     , productLine AS PRODUCT_LINE
     , class AS PRODUCT_CLASS
     , style AS PRODUCT_STYLE
     , subcategory AS PRODUCT_SUBCATEGORY
     , category AS PRODUCT_CATEGORY
     , model AS PRODUCT_MODEL
     , CAST(sellStartDate AS DATE) AS SELL_START_DATE
     , CAST(sellEndDate AS DATE) AS SELL_END_DATE
     , CAST(discontinuedDate AS DATE) AS DISCONTINUED_DATE
     , CAST(modifiedDate AS DATE) AS MODIFIED_DATE
     , {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM {{ source('bronze_adworks_jaq_test', 'products') }}
WHERE productId IS NOT NULL;