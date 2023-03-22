with 

source as (
  select * from {{ source('customer', 'order_invoice') }}
),

transformed as (
  select
    customer_id, customer_name, count(item_id), sum(price), max(purchased_on)
  from source
  group by customer_id, customer_name
  order by customer_name asc
)

select * from transformed