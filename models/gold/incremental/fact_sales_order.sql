/* Transformation from Silver Layer to Gold Layer for Sales Order and Sales Order Details model -> fact_sales_order */
WITH sales_orders AS (
    SELECT 
        SALES_ORDER_ID,
        ORDER_DATE,
        DUE_DATE,
        SHIP_DATE,
        STATUS,
        IS_ORDERED_ONLINE,
        SALES_ORDER_NUMBER,
        CUSTOMER_ID,
        SALES_PERSON_ID,
        TERRITORY,
        BILL_TO_ADDRESS,
        SHIP_TO_ADDRESS,
        SHIP_METHOD,
        CREDIT_CARD_ID,
        CURRENCY_RATE_ID,
        SUB_TOTAL,
        TAX_AMOUNT,
        FREIGHT,
        TOTAL_DUE,
        MODIFIED_DATE AS ORDER_MODIFIED_DATE,
        UPDATE_DATE AS ORDER_UPDATE_DATE
    FROM {{ ref('silver_salesorders') }}
    {% if is_incremental() %}
        WHERE UPDATE_DATE > (SELECT MAX(UPDATE_DATE) FROM {{ this }})
    {% endif %}
),

sales_order_details AS (
    SELECT 
        SALES_ORDER_ID,
        SALES_ORDER_DETAIL_ID,
        PRODUCT_ID,
        PRODUCT_NAME,
        ORDER_QUANTITY,
        {{ round_to_2_decimal_places('UNIT_PRICE') }} AS UNIT_PRICE,
        UNIT_PRICE_DISCOUNT,
        LINE_TOTAL,
        MODIFIED_DATE AS DETAIL_MODIFIED_DATE,
        UPDATE_DATE AS DETAIL_UPDATE_DATE
    FROM {{ ref('silver_salesorderdetails') }}
    {% if is_incremental() %}
        WHERE UPDATE_DATE > (SELECT MAX(UPDATE_DATE) FROM {{ this }})
    {% endif %}
)

SELECT 
    so.SALES_ORDER_ID,
    so.SALES_ORDER_NUMBER,
    so.ORDER_DATE,
    so.DUE_DATE,
    so.SHIP_DATE,
    so.STATUS,
    so.IS_ORDERED_ONLINE,
    so.CUSTOMER_ID,
    so.SALES_PERSON_ID,
    so.TERRITORY,
    so.BILL_TO_ADDRESS,
    so.SHIP_TO_ADDRESS,
    so.SHIP_METHOD,
    so.CREDIT_CARD_ID,
    so.CURRENCY_RATE_ID,
    sod.SALES_ORDER_DETAIL_ID,
    sod.PRODUCT_ID,
    sod.PRODUCT_NAME,
    sod.ORDER_QUANTITY,
    sod.UNIT_PRICE,
    sod.UNIT_PRICE_DISCOUNT,
    sod.LINE_TOTAL,
    sod.UNIT_PRICE * sod.ORDER_QUANTITY AS GROSS_AMOUNT,
    sod.UNIT_PRICE_DISCOUNT * sod.UNIT_PRICE * sod.ORDER_QUANTITY AS DISCOUNT_AMOUNT,
    sod.LINE_TOTAL AS NET_AMOUNT,
    so.SUB_TOTAL,
    so.TAX_AMOUNT AS TAX_AMOUNT,
    so.FREIGHT,
    so.TOTAL_DUE AS TOTAL_DUE,
    {{ convert_to_wa_time_params('sod.DETAIL_MODIFIED_DATE') }} AS DETAIL_MODIFIED_DATE,
    {{ convert_to_wa_time_params('so.ORDER_MODIFIED_DATE') }} AS ORDER_MODIFIED_DATE,
    {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM sales_orders so
JOIN sales_order_details sod
  ON so.SALES_ORDER_ID = sod.SALES_ORDER_ID
WHERE so.SALES_ORDER_ID IS NOT NULL;