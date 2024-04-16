
  
    

        create or replace transient table ASTRO_SDK_DB.ASTRO_SDK_SCHEMA.report_product_invoices
         as
        (SELECT
  p.product_id,
  p.stock_code,
  p.description,
  SUM(fi.quantity) AS total_quantity_sold
FROM ASTRO_SDK_DB.ASTRO_SDK_SCHEMA.fct_invoices fi
JOIN ASTRO_SDK_DB.ASTRO_SDK_SCHEMA.dim_product p ON fi.product_id = p.product_id
GROUP BY p.product_id, p.stock_code, p.description
ORDER BY total_quantity_sold DESC
LIMIT 10
        );
      
  