{{ config(materialized='ephemeral') }}

select * from {{ source('customer', 'sub_info') }}