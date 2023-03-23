with 

source1 as (
  select * from {{ ref('stg_order_catalog') }}
),

source2 as (
  select * from {{ ref('stg_customers') }}
),

transformed as (
  select
    s2.customer_id, s2.customer_name, s1.count(item_id), s1.sum(price), s1.max(purchased_on)
  from source1 s1
  join source2 s2 on 
  group by customer_id, customer_name
  order by customer_name asc
)

select * from transformed