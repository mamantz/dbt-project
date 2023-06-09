WITH 

customer AS (
  SELECT * FROM {{ ref('stg_customers') }}
),

final as (
  SELECT 
    sub_tier, 
    to_char(DATE_TRUNC('month', purchase_date), 'Month YYYY') AS month,  
    COUNT(*) AS purchase_count
  FROM 
    customer.customer c
  JOIN 
    customer.order_info oi ON oi.customer_id = c.id
  JOIN 
    customer.order_catalog fi ON fi.order_id = oi.order_id
  GROUP BY sub_tier, month
  ORDER BY sub_tier
)

select * from final
