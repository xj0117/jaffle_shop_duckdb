{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

with orders as (

    select
        order_id,
        customer_id,
        store_id,
        cast(ordered_at as date) as order_date,
        ordered_at,

        subtotal,
        tax_paid,
        order_total

    from {{ ref('stg_orders') }}

),

customers as (

    select 
        customer_id, 
        customer_name, 
        cast(valid_from as date) as valid_from, 
        cast(valid_to as date) as valid_to
    from {{ ref('dim_customers') }}

),

orders_with_customers as (

    select *
    from (

        select
            o.*,
            c.customer_id,
            c.customer_name,

            row_number() over (
                partition by o.order_id
                order by 
                    case 
                        when o.order_date >= c.valid_from then 0 
                        else 1 
                    end
                    ,c.valid_from desc
            ) as rn

        from orders o
        left join customers c
            on o.customer_id = c.customer_id
        and o.order_date >= c.valid_from
        and o.order_date < coalesce(c.valid_to, '9999-12-31')

    ) t
    where rn = 1

),

stores as (

    select *
    from {{ ref('stg_stores') }}

),

order_items as (

    select *
    from {{ ref('int_order_items') }}

),

final as (

    select
        o.order_id,
        o.order_date,
        o.ordered_at,

        -- 维度
        o.customer_id,
        o.customer_name,

        o.store_id,
        s.name as store_name,

        -- 核心指标（来自 orders）
        o.subtotal,
        o.tax_paid,
        o.order_total,

        -- 衍生指标
        oi.item_count,

        -- KPI
        o.order_total / nullif(oi.item_count, 0) as avg_item_value,

        case 
            when o.order_total > 100 then 'high_value'
            else 'normal'
        end as order_segment

    from orders_with_customers o
    left join stores s
        on o.store_id = s.store_id
    left join order_items oi
        on o.order_id = oi.order_id

)

select * from final

{% if is_incremental() %}

where order_date > (select max(order_date) from {{ this }})

{% endif %}