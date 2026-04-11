{% macro generate_partition_parquet(table_name, s3_path, partition_by) %}

COPY (
  SELECT    *,
            cast({{ partition_by }} as date) as date
  FROM read_csv_auto('{{ s3_path }}')
)
TO 'data/parquet/{{ table_name }}'
(
    FORMAT PARQUET, 
    PARTITION_BY (date),
    OVERWRITE_OR_IGNORE TRUE
);

{% endmacro %}