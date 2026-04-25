{% test single_current_row(model, key_column) %}

select *
from (
    select count(*) as cnt
    from {{ model }}
    where is_current = true
) t
where cnt <> (
    select count(distinct {{ key_column }})
    from {{ model }}
)

{% endtest %}