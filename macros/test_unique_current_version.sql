{% test unique_current_version(model, key_column) %}

select
    {{ key_column }},
    count(*) as cnt
from {{ model }}
where is_current = true
group by {{ key_column }}  
having count(*) > 1

{% endtest %}