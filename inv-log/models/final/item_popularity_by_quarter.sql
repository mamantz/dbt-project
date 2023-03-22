WITH 

order_invoice AS (
  SELECT * FROM {{ ref('stg_order_invoice') }}
),

final as (
    SELECT 
        item_id,
        item_name,
        item_desc,
        date_trunc('quarter', purchased_on) AS quarter,
        SUM(num_of_items) AS total_items_sold
    FROM 
        order_invoice
    GROUP BY 
        item_id, item_name, item_desc, quarter
    ORDER BY 
        quarter DESC, total_items_sold DESC
)

select * from final