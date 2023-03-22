{{ config(materialized='ephemeral') }}

select * from {{ source('product', 'inventory') }}