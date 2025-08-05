/* Transformation from Silver Layer to Gold Layer for customers model -> dim_customers */
{{ config(materialized='table') }}

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
    {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM {{ ref('silver_persons') }}
WHERE PERSON_ID IS NOT NULL