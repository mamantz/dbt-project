with 

source1 as (
  select * from {{ ref('stg_order_catalog') }}
),

source2 as (
  select * from {{ ref('stg_customers') }}
),

transformed as (
  select
    s2.id as customer_id, 
    s2.name as customer_name, 
    s1.num_items_purchased, 
    s1.total_paid, 
    count(s1.order_id) as num_of_invoices, 
    max(s1.date_purchased) as most_recent_purchase
  from customer.final_invoice s1
  join customer.order_info oi on oi.order_id = s1.order_id
  join customer.customer s2 on s2.id = oi.customer_id
  group by s2.id, s2.name, s1.num_items_purchased, s1.total_paid
  order by customer_name asc
)

select * from transformed