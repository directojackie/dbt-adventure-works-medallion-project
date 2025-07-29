/*
    dbt model for stores table
*/

{{ config(materialized='table') }}


SELECT storeId AS STORE_ID
     , name AS STORE_NAME
     , salesPersonId AS SALES_PERSON_ID
     , CAST(AnnualSales AS INTEGER) AS ANNUAL_SALES
     , CAST(AnnualRevenue AS DOUBLE) AS ANNUAL_REVENUE
     , BankName AS BANK_NAME
     , BusinessType AS BUSINESS_TYPE
     , CAST(NULLIF(YearOpened, '-') AS INTEGER) AS YEAR_OPENED
     , CAST(NULLIF(Specialty, '-')  AS INTEGER) AS SPECIALTY
     , CAST(NULLIF(SquareFeet, '-')  AS INTEGER) AS SQUARE_FEET
     , CAST(NULLIF(Brands, '-') AS INTEGER) AS BRANDS
     , CAST(NULLIF(Internet, '-') AS INTEGER) AS INTERNET
     , CAST(NULLIF(NumberEmployees, '-') AS INTEGER) AS NUMBER_EMPLOYEES
     , CAST(NULLIF(modifiedDate, '-')  AS DATE) AS MODIFIED_DATE
     , {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM {{ source('bronze_adworks_jaq_test', 'stores') }}
WHERE storeId IS NOT NULL;