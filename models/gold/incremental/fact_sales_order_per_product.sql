/* Aggregates from fact_sales_order and silver_products model -> fact_sales_order_per_producr */
{{ config(
    materialized='incremental',
    unique_key='SALES_ORDER_ID'
) }}

SELECT 
    so.SALES_ORDER_ID,
    so.SALES_ORDER_NUMBER,
    so.CUSTOMER_ID,
    so.SALES_PERSON_ID,
    so.TERRITORY,
    sod.PRODUCT_ID,
    sod.PRODUCT_NAME,

    -- Aggregates
    SUM(sod.ORDER_QUANTITY) AS TOTAL_QUANTITY,
    SUM(sod.UNIT_PRICE * sod.ORDER_QUANTITY) AS TOTAL_GROSS_AMOUNT,
    SUM(sod.UNIT_PRICE_DISCOUNT * sod.UNIT_PRICE * sod.ORDER_QUANTITY) AS TOTAL_DISCOUNT_AMOUNT,
    SUM(sod.LINE_TOTAL) AS TOTAL_NET_AMOUNT,

    -- Order-level financials
    MAX(so.SUB_TOTAL) AS SUB_TOTAL,
    MAX(so.TAX_AMOUNT) AS TAX_AMOUNT,
    MAX(so.FREIGHT) AS FREIGHT,
    MAX(so.TOTAL_DUE) AS TOTAL_DUE,

    -- Dates
    MAX(so.ORDER_DATE) AS ORDER_DATE,
    MAX(so.SHIP_DATE) AS SHIP_DATE,
    MAX(so.DUE_DATE) AS DUE_DATE,
    MAX(so.ORDER_MODIFIED_DATE) AS LAST_UPDATE_DATE

FROM {{ ref('fact_sales_order') }} so
JOIN {{ ref('silver_salesorderdetails') }} sod
  ON so.SALES_ORDER_ID = sod.SALES_ORDER_ID

{% if is_incremental() %}
WHERE so.ORDER_MODIFIED_DATE > (SELECT MAX(ORDER_MODIFIED_DATE) FROM {{ this }})
{% endif %}

GROUP BY 
    so.SALES_ORDER_ID,
    so.SALES_ORDER_NUMBER,
    so.CUSTOMER_ID,
    so.SALES_PERSON_ID,
    so.TERRITORY,
    sod.PRODUCT_ID,
    sod.PRODUCT_NAME
