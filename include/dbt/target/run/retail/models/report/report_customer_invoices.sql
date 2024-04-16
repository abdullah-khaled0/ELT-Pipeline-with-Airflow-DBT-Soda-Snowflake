
  
    

        create or replace transient table ASTRO_SDK_DB.ASTRO_SDK_SCHEMA.report_customer_invoices
         as
        (SELECT
  c.country,
  c.iso,
  COUNT(fi.invoice_id) AS total_invoices,
  SUM(fi.total) AS total_revenue
FROM ASTRO_SDK_DB.ASTRO_SDK_SCHEMA.fct_invoices fi
JOIN ASTRO_SDK_DB.ASTRO_SDK_SCHEMA.dim_customer c ON fi.customer_id = c.customer_id
GROUP BY c.country, c.iso
ORDER BY total_revenue DESC
LIMIT 10
        );
      
  