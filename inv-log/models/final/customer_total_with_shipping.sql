WITH 

discount_rate AS (
    SELECT * FROM {{ ref('int__discount_rate_per_customer') }}
),

customer_info AS (
    SELECT * FROM {{ ref('stg_customer__total_purchased') }}
),

final AS (
    SELECT 
      c.*,
      (c.total_paid * t.item_discount) as item_total
    FROM customer_info c
    JOIN discount_rate t
    ON c.customer_id = t.customer_id
)

SELECT * FROM final