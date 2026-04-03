select  cast(id as varchar) as supply_id,
        cast(name as varchar) as name,
        cast(cost as int) as cost,
        cast(perishable as boolean) as perishable,
        cast(sku as varchar) as sku
-- from read_csv_auto('s3://dbt-learn-sample-data/raw_supplies.csv')
from 'data/parquet/supplies.parquet'