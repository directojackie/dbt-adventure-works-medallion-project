/*
    dbt model for salesorders table
*/
WITH source_data AS (
    SELECT 
        salesOrderId,
        revisionNumber,
        orderDate,
        dueDate,
        shipDate,
        status,
        isOrderedOnline,
        salesOrderNumber,
        purchaseOrderNumber,
        accountNumber,
        customerId,
        salesPersonId,
        territory,
        billToAddress,
        shipToAddress,
        shipMethod,
        creditCardId,
        creditCardApprovalCode,
        currencyRateId,
        subTotal,
        taxAmount,
        freight,
        totalDue,
        comment,
        modifiedDate
    FROM {{ source('bronze_adworks_jaq_test', 'salesorders') }}
    WHERE salesOrderId IS NOT NULL
),

max_modified AS (
    {% if is_incremental() %}
    SELECT COALESCE(MAX(MODIFIED_DATE), '1900-01-01') AS max_modified_date
    FROM {{ this }}
    {% else %}
    SELECT '1900-01-01'::timestamp AS max_modified_date
    {% endif %}
),

filtered_data AS (
    SELECT sd.*
    FROM source_data sd
    JOIN max_modified mm ON sd.modifiedDate > mm.max_modified_date
)

SELECT 
    salesOrderId AS SALES_ORDER_ID,
    revisionNumber AS REVISION_NUMBER,
    CAST(orderDate AS DATE) AS ORDER_DATE,
    CAST(dueDate AS DATE) AS DUE_DATE,
    CAST(shipDate AS DATE) AS SHIP_DATE,
    status AS STATUS,
    isOrderedOnline AS IS_ORDERED_ONLINE,
    salesOrderNumber AS SALES_ORDER_NUMBER,
    purchaseOrderNumber AS PURCHASE_ORDER_NUMBER,
    accountNumber AS ACCOUNT_NUMBER,
    customerId AS CUSTOMER_ID,
    salesPersonId AS SALES_PERSON_ID,
    territory AS TERRITORY,
    billToAddress AS BILL_TO_ADDRESS,
    shipToAddress AS SHIP_TO_ADDRESS,
    shipMethod AS SHIP_METHOD,
    creditCardId AS CREDIT_CARD_ID,
    creditCardApprovalCode AS CREDIT_CARD_APPROVAL_CODE,
    currencyRateId AS CURRENCY_RATE_ID,
    ROUND(subTotal, 2) AS SUB_TOTAL,
    ROUND(taxAmount, 2) AS TAX_AMOUNT,
    ROUND(freight, 2) AS FREIGHT,
    ROUND(totalDue, 2) AS TOTAL_DUE,
    comment AS COMMENT,
    CAST(modifiedDate AS DATE) AS MODIFIED_DATE,
    {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM filtered_data

