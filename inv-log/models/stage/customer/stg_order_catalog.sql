{{ config(materialized='ephemeral') }}

select * from {{ source('customer', 'order_catalog') }}