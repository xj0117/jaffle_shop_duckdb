select  cast(id as varchar) as store_id,
        cast(name as varchar) as name,
        cast(opened_at as datetime) as opened_at,
        cast(tax_rate as int) as tax_rate,
        cast(date as varchar) as date
-- from read_csv_auto('s3://dbt-learn-sample-data/raw_stores.csv')
from read_parquet('data/parquet/stores/**/*.parquet', hive_partitioning=true)