-- with source as (

--     {#-
--     Normally we would select from the table here, but we are using seeds to load
--     our data in this project
--     #}
--     select * from {{ ref('raw_customers') }}

-- ),

-- renamed as (

--     select
--         id as customer_id,
--         first_name,
--         last_name

--     from source

-- )

-- select * from renamed

select cast(id as varchar) as customer_id,
       cast(name as varchar) as customer_name
from read_csv_auto('s3://dbt-learn-sample-data/raw_customers.csv')