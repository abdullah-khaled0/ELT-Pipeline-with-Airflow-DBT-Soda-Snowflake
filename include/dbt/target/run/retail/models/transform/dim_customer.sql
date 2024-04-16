
  
    

        create or replace transient table ASTRO_SDK_DB.ASTRO_SDK_SCHEMA.dim_customer
         as
        (WITH customer_cte AS (
	SELECT DISTINCT
	    md5(cast(coalesce(cast("CustomerID" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("Country" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as customer_id,
	    "Country" AS country
	FROM ASTRO_SDK_DB.ASTRO_SDK_SCHEMA.raw_invoices
	WHERE "CustomerID" IS NOT NULL
)
SELECT
    t.*,
	cm.iso
FROM customer_cte t
LEFT JOIN ASTRO_SDK_DB.ASTRO_SDK_SCHEMA.country cm ON t.country = cm.nicename
        );
      
  