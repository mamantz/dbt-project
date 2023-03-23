with 

shipping_costs as (
  select * from {{ ref('stg_shipping_cost') }}
),

customers as (
  select * from {{ ref('stg_customers') }}
),

transformed as (
  select
    c.id as customer_id,
	  si.item_discount,
    si.shipping_discount
  from customer.customer c
  join customer.sub_info si on si.id = c.sub_tier
)

select * from transformed