WITH 

order_invoice AS (
  SELECT * FROM {{ ref('stg_order_invoice') }}
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
        inv.name AS product,
        SUM(oi.num_of_items) AS total_quantity_sold
    FROM 
        customer as c
        JOIN order_invoice oi ON c.id = oi.customer_id
        JOIN inventory inv ON oi.item_id = inv.id
    GROUP BY 
        region, 
        product
    ORDER BY
        region, 
        total_quantity_sold DESC
)

select * from final