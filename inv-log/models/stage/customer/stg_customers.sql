{{ config(materialized='ephemeral') }}

select * from {{ source('customer', 'customer') }}