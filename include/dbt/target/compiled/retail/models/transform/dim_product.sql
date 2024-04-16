SELECT DISTINCT
    md5(cast(coalesce(cast("StockCode" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("Description" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("UnitPrice" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as product_id,
		"StockCode" AS stock_code,
    "Description" AS description,
    "UnitPrice" AS price
FROM ASTRO_SDK_DB.ASTRO_SDK_SCHEMA.raw_invoices
WHERE "StockCode" IS NOT NULL
AND "UnitPrice" > 0