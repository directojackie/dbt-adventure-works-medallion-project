/* Transformation from Silver Layer to Gold Layer for products, productcategories, productmodels and product description model -> dim_products */
{{ config(materialized='table') }}

WITH products AS (
    SELECT PRODUCT_ID,
        PRODUCT_NAME,
        PRODUCT_NUMBER,
        IS_MANUFACTURED,
        IS_SALEABLE,
        PRODUCT_COLOR,
        SAFETY_STOCK_LEVEL,
        REORDER_POINT,
        STANDARD_COST,
        LIST_PRICE,
        PRODUCT_SIZE,
        PRODUCT_SIZE_UNIT,
        PRODUCT_WEIGHT_UNIT,
        PRODUCT_WEIGHT,
        DAYS_TO_MANUFACTURE,
        PRODUCT_LINE,
        PRODUCT_CLASS,
        PRODUCT_STYLE,
        PRODUCT_SUBCATEGORY,
        PRODUCT_CATEGORY,
        PRODUCT_MODEL,
        SELL_START_DATE AS SELL_START_DATE,
        SELL_END_DATE  AS SELL_END_DATE,
        DISCONTINUED_DATE  AS DISCONTINUED_DATE,
        MODIFIED_DATE  AS PRODUCT_MODIFIED_DATE,
        {{ convert_to_wa_time() }} AS PRODUCT_UPDATE_DATE
    FROM {{ ref('silver_products') }}
    WHERE PRODUCT_ID IS NOT NULL
),

product_categories AS (
    SELECT PRODUCT_CATEGORY_ID,
        PRODUCT_CATEGORY_NAME,
        MODIFIED_DATE AS CATEGORY_MODIFIED_DATE,
        {{ convert_to_wa_time() }} AS CATEGORY_UPDATE_DATE
    FROM {{ ref('silver_productcategories') }}
    WHERE PRODUCT_CATEGORY_ID IS NOT NULL
),

product_models AS (
    SELECT PRODUCT_MODEL_ID,
        PRODUCT_MODEL_NAME,
        PRODUCT_MODEL_CATALOG_DESCRIPTION,
        PRODUCT_MODEL_INSTRUCTIONS,
        MODIFIED_DATE AS MODEL_MODIFIED_DATE,
        {{ convert_to_wa_time() }} AS MODEL_UPDATE_DATE
    FROM {{ ref('silver_productmodels') }}
    WHERE PRODUCT_MODEL_ID IS NOT NULL
),

product_descriptions AS (
    SELECT PRODUCT_DESCRIPTION_ID,
        PRODUCT_DESCRIPTION,
        CULTURE_CODE,
        MODIFIED_DATE AS DESCRIPTION_MODIFIED_DATE,
        {{ convert_to_wa_time() }} AS DESCRIPTION_UPDATE_DATE
    FROM {{ ref('silver_productdescriptions') }}
    WHERE PRODUCT_DESCRIPTION_ID IS NOT NULL
)

SELECT 
    p.PRODUCT_ID,
    p.PRODUCT_NAME,
    p.PRODUCT_NUMBER,
    p.IS_MANUFACTURED,
    p.IS_SALEABLE,
    p.PRODUCT_COLOR,
    p.SAFETY_STOCK_LEVEL,
    p.REORDER_POINT,
    p.STANDARD_COST,
    p.LIST_PRICE,
    p.PRODUCT_SIZE,
    p.PRODUCT_SIZE_UNIT,
    p.PRODUCT_WEIGHT_UNIT,
    p.PRODUCT_WEIGHT,
    p.DAYS_TO_MANUFACTURE,
    p.PRODUCT_LINE,
    p.PRODUCT_CLASS,
    p.PRODUCT_STYLE,
    p.PRODUCT_SUBCATEGORY,
    p.PRODUCT_CATEGORY,
    pc.PRODUCT_CATEGORY_NAME,
    pm.PRODUCT_MODEL_NAME,
    pm.PRODUCT_MODEL_CATALOG_DESCRIPTION,
    pm.PRODUCT_MODEL_INSTRUCTIONS,
    pd.PRODUCT_DESCRIPTION,
    pd.CULTURE_CODE,
    p.SELL_START_DATE,
    p.SELL_END_DATE,
    p.DISCONTINUED_DATE,
    p.PRODUCT_MODIFIED_DATE,
    pc.CATEGORY_MODIFIED_DATE,
    pm.MODEL_MODIFIED_DATE,
    pd.DESCRIPTION_MODIFIED_DATE,
    p.PRODUCT_UPDATE_DATE,
    pc.CATEGORY_UPDATE_DATE,
    pm.MODEL_UPDATE_DATE,
    pd.DESCRIPTION_UPDATE_DATE,
    {{ convert_to_wa_time() }} AS UPDATE_DATE
FROM products p
LEFT JOIN product_categories pc
    ON p.PRODUCT_CATEGORY = pc.PRODUCT_CATEGORY_NAME
LEFT JOIN product_models pm
    ON p.PRODUCT_MODEL = pm.PRODUCT_MODEL_NAME
LEFT JOIN product_descriptions pd
    ON p.PRODUCT_ID = pd.PRODUCT_DESCRIPTION_ID  -- Adjust this join if needed;
