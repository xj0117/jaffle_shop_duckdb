-- with source as (

--     {#-
--     Normally we would select from the table here, but we are using seeds to load
--     our data in this project
--     #}
--     select * from {{ ref('raw_orders') }}

-- ),

-- renamed as (

--     select
--         id as order_id,
--         user_id as customer_id,
--         order_date,
--         status

--     from source

-- )

-- select * from renamed


select  cast(id as varchar) as order_id,
        cast(customer as varchar) as customer_id,
        cast(ordered_at as timestamp) as ordered_at,
        cast(store_id as varchar) as store_id,
        cast(subtotal as int) as subtotal,
        cast(tax_paid as int) as tax_paid,
        cast(order_total as int) as order_total
-- from read_csv_auto('s3://dbt-learn-sample-data/raw_orders.csv')
from 'data/parquet/orders.parquet'
