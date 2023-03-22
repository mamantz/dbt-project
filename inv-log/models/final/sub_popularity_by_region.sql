WITH 

sub_info AS (
  SELECT * FROM {{ ref('stg_sub_info') }}
),

customer AS (
  SELECT * FROM {{ ref('stg_customers') }}
),

final as (
    SELECT c.location, s.name AS sub_name, COUNT(c.id) AS customer_count
    FROM customer c
    JOIN customer.sub_info s ON c.sub_tier = s.id
    GROUP BY c.location, s.name
    HAVING COUNT(c.id) = (
        SELECT MAX(customer_count)
        FROM (
            SELECT c.location, s.name AS sub_name, COUNT(c.id) AS customer_count
            FROM customer.customer c
            JOIN customer.sub_info s ON c.sub_tier = s.id
            GROUP BY c.location, s.name
        ) AS sub_counts
        WHERE sub_counts.location = c.location
    )
    ORDER BY c.location
)

select * from final