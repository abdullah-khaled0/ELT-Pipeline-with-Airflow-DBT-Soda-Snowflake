
  
    

        create or replace transient table ASTRO_SDK_DB.ASTRO_SDK_SCHEMA.report_year_invoices
         as
        (SELECT
  dt.year,
  dt.month,
  COUNT(DISTINCT fi.invoice_id) AS num_invoices,
  SUM(fi.total) AS total_revenue
FROM ASTRO_SDK_DB.ASTRO_SDK_SCHEMA.fct_invoices fi
JOIN ASTRO_SDK_DB.ASTRO_SDK_SCHEMA.dim_datetime dt ON fi.datetime_id = dt.datetime_id
GROUP BY dt.year, dt.month
ORDER BY dt.year, dt.month
        );
      
  