-- /*
--     dbt model for salesorderdetails table
-- */


WITH source_data AS (
    SELECT 
        salesOrderId,
        salesOrderDetailId,
        carrierTrackingNumber,
        orderQuantity,
        productId,
        productName,
        specialOfferId,
        unitPrice,
        unitPriceDiscount,
        lineTotal,
        modifiedDate
    FROM {{ source('bronze_adworks_jaq_test', 'salesorderdetails') }}
    WHERE salesOrderDetailId IS NOT NULL
),

{% if is_incremental() %}
max_modified AS (
    SELECT COALESCE(MAX(MODIFIED_DATE), '1900-01-01') AS max_modified_date
    FROM {{ this }}
),
filtered_data AS (
    SELECT sd.*
    FROM source_data sd
    JOIN max_modified mm ON sd.modifiedDate >= mm.max_modified_date
)
{% else %}
filtered_data AS (
    SELECT *
    FROM source_data
)
{% endif %}

SELECT 
    salesOrderId AS SALES_ORDER_ID,
    salesOrderDetailId AS SALES_ORDER_DETAIL_ID,
    carrierTrackingNumber AS CARRIER_TRACKING_NUMBER,
    orderQuantity AS ORDER_QUANTITY,
    productId AS PRODUCT_ID,
    productName AS PRODUCT_NAME,
    specialOfferId AS SPECIAL_OFFER_ID,
    round(unitPrice, 2) AS UNIT_PRICE,
    unitPriceDiscount AS UNIT_PRICE_DISCOUNT,
    round(lineTotal, 2) AS LINE_TOTAL,
    CAST(modifiedDate AS DATE) AS MODIFIED_DATE,
    {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM filtered_data
