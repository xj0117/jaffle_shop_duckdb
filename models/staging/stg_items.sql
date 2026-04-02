select  cast(id as varchar) as item_id,
        cast(order_id as varchar) as order_id,
        cast(sku as varchar) as sku
from read_csv_auto('s3://dbt-learn-sample-data/raw_items.csv')