WITH 

customer AS (
  SELECT * FROM {{ ref('stg_customers') }}
),

final as (
  SELECT 
    sub_tier, DATE_TRUNC('month', purchased_on)::date AS purchase_month, COUNT(*) AS purchase_count
  FROM 
    customer.customer c
    JOIN customer.order_invoice fi ON c.id = fi.customer_id
    JOIN customer.sub_info si ON c.sub_tier = si.id
  GROUP BY 
    sub_tier, purchase_month
  ORDER BY 
    sub_tier, purchase_month
)

select * from final
