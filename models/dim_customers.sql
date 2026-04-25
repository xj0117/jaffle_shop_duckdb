{{ config(
    materialized='incremental',
    unique_key='customer_id'
) }}

with source as (

    select
        customer_id,
        customer_name,
        hash_diff,
        current_timestamp as updated_at
    from {{ ref('stg_customers') }}

),

-- 当前已存在的记录（只取 active）
current_dim as (

    {% if is_incremental() %}

    select *
    from {{ this }}
    where is_current = true

    {% else %}

    select *
    from {{ ref('stg_customers') }}
    where 1=0

    {% endif %}

),

-- 找出变化的记录
changed as (

    select
        s.*
    from source s
    left join current_dim d
        on s.customer_id = d.customer_id

    where
        d.customer_id is null   -- 新用户
        or (
                s.hash_diff is distinct from d.hash_diff
        )

),

-- 需要关闭的旧记录
expired as (

    select
        d.*
    from current_dim d
    join changed c
        on d.customer_id = c.customer_id

),

-- 新版本记录
new_records as (

    select
        customer_id,
        customer_name,
        hash_diff,
        updated_at as valid_from,
        null as valid_to,
        true as is_current
    from changed

)

-- 最终输出（⚠️ incremental关键）
select * from new_records

{% if is_incremental() %}

union all

-- 更新旧记录为失效
select
    customer_id,
    customer_name,
    hash_diff,
    valid_from,
    current_timestamp as valid_to,
    false as is_current
from expired

{% endif %}