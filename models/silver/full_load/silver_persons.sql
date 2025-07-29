
/*
    dbt model for persons table
*/

{{ config(materialized='table') }}


SELECT personId AS PERSON_ID
    , CASE 
        WHEN nameStyle = 'Eastern Style(last name, first name)' THEN  CONCAT(lastName, ' ', firstName)
        ELSE CONCAT(firstName, ' ', lastName)
      END AS FULL_NAME
    , title AS TITLE
    , firstName AS FIRST_NAME
    , middleName AS MIDDLE_NAME
    , lastName AS LAST_NAME
    , suffix AS SUFFIX
    , personType AS PERSON_TYPE
    , nameStyle AS NAME_STYLE
    , emailPromotion AS EMAIL_PROMOTION
    , additionalContactInfo AS ADDITIONAL_CONTACT_INFO
    , CAST(TotalPurchaseYTD AS DECIMAL) AS TOTAL_PURCHASE_YTD
    , modifiedDate AS MODIFIED_DATE
    --, CAST(modifiedDate AS DATE) AS MODIFIED_DATE
    , {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM {{ source('bronze_adworks_jaq_test', 'persons') }}
WHERE personId IS NOT NULL;