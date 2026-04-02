select  cast(id as varchar) as store_id,
        cast(name as varchar) as name,
        cast(opened_at as datetime) as opened_at,
        cast(tax_rate as int) as tax_rate
from read_csv_auto('s3://dbt-learn-sample-data/raw_stores.csv')