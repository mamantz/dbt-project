WITH 

order_catalog AS (
  SELECT * FROM {{ ref('stg_order_catalog') }}
),

customer AS (
  SELECT * FROM {{ ref('stg_customers') }}
),

inventory AS (
  SELECT * FROM {{ ref('stg_inventory') }}
),

final as (
  SELECT 
    c.location AS region,
    i.name AS product,
    SUM(oc.num_of_items) AS total_quantity_sold
  FROM 
    customer.customer as c
    JOIN customer.order_info oi ON oi.customer_id = c.id
    JOIN customer.order_catalog oc ON oc.order_id = oi.order_id
    JOIN product.inventory i ON i.id = oc.item_id
  GROUP BY 
    region,
    product
  ORDER BY
    product,
    total_quantity_sold DESC
)

select * from final