with items as (

    select *
    from {{ ref('stg_items') }}

),

aggregated as (

    select
        order_id,
        count(*) as item_count

    from items
    group by order_id

)

select * from aggregated