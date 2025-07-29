/* Transformation from Silver Layer to Gold Layer for addresses model -> dim_addresses */
{{ config(materialized='table') }}

SELECT ADDRESS_ID
     , CONCAT(NULLIF(STREET, ''), ' ', CITY, ' ', STATE, ' ', COUNTRY, ' ', ZIPCODE) AS COMPLETE_ADDRESS
     , MODIFIED_DATE AS ADDRESS_MODIFIED_DATE
     , {{ convert_to_wa_time() }} AS UPDATE_DATE
 FROM {{ ref('silver_addresses') }}
 WHERE ADDRESS_ID IS NOT NULL;