WITH datetime_cte AS (  
  SELECT DISTINCT
    "InvoiceDate" AS datetime_id,
    CASE
      WHEN LENGTH("InvoiceDate") = 16 THEN
        -- Date format: "DD/MM/YYYY HH:MM"
        TO_TIMESTAMP("InvoiceDate", 'DD/MM/YYYY HH24:MI')
      WHEN LENGTH("InvoiceDate") <= 14 THEN
        -- Date format: "MM/DD/YY HH:MM"
        TO_TIMESTAMP("InvoiceDate", 'MM/DD/YY HH24:MI')
      ELSE
        NULL
    END AS date_part
  FROM ASTRO_SDK_DB.ASTRO_SDK_SCHEMA.raw_invoices
  WHERE "InvoiceDate" IS NOT NULL
)
SELECT
  datetime_id,
  date_part as datetime,
  EXTRACT(YEAR FROM date_part) AS year,
  EXTRACT(MONTH FROM date_part) AS month,
  EXTRACT(DAY FROM date_part) AS day,
  EXTRACT(HOUR FROM date_part) AS hour,
  EXTRACT(MINUTE FROM date_part) AS minute,
  EXTRACT(DAYOFWEEK FROM date_part) AS weekday
FROM datetime_cte