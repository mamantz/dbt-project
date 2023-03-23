WITH 

order_catalog AS (
  SELECT * FROM {{ ref('stg_order_catalog') }}
),

final as (
    SELECT 
        i.id AS item_id,
        i.name AS item_name,
        location as region,
        CONCAT('Q', EXTRACT(QUARTER FROM purchase_date), ' ', EXTRACT(YEAR FROM purchase_date)) AS quarter,
        SUM(num_of_items) AS total_items_sold
    FROM 
        product.inventory i
    JOIN customer.order_catalog oc ON oc.item_id = i.id
    JOIN customer.order_info oi ON oi.order_id = oc.order_id
    JOIN customer.customer c ON c.id = oi.customer_id
    GROUP BY 
        i.id, item_name, quarter, location
    ORDER BY 
        region, quarter DESC, total_items_sold DESC
)

select * from final