{% macro generate_non_partition_parquet(table_name, s3_path, partition_by=None) %}

COPY (
  SELECT *
  FROM read_csv_auto('{{ s3_path }}')
)
TO 'data/parquet/{{ table_name }}.parquet'
(
  FORMAT PARQUET
{% if partition_by %}
, PARTITION_BY ({{ partition_by }})
{% endif %}
  , OVERWRITE_OR_IGNORE TRUE
);

{% endmacro %}