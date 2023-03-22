WITH 

shipping_info AS (
    SELECT * FROM {{ ref('int__shipping_cost_per_customer') }}
),

customer_info AS (
    SELECT * FROM {{ ref('stg_customer__total_purchased') }}
),

final AS (
    SELECT 
      c.*, 
      t.cost
    FROM customer_info c
    JOIN shipping_info t
    ON c.customer_id = t.id
)

SELECT * FROM final