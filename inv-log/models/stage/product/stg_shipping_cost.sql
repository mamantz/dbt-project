{{ config(materialized='ephemeral') }}

select * from {{ source('product', 'shipping_costs') }}