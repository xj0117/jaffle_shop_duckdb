{% test scd2_no_overlap(model, key_column) %}

with ordered as (

    select
        {{ key_column }} as key,
        cast(valid_from as timestamp) as valid_from,
        cast(valid_to as timestamp) as valid_to,

        lag(cast(valid_to as timestamp)) over (
            partition by {{ key_column }}
            order by valid_from
        ) as prev_valid_to

    from {{ model }}

)

select *
from ordered
where valid_from < prev_valid_to

{% endtest %}