with 

shipping_costs as (
  select * from {{ ref('stg_shipping_cost') }}
),

customers as (
  select * from {{ ref('stg_customers') }}
),

transformed as (
  select
    c.id, 
    c.name, 
    c.location, 
    t.cost 
  from customers c
  join shipping_costs t 
  on c.location = t.country
)

select * from transformed