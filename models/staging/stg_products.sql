select  cast(sku as varchar) as sku,
         cast(name as varchar) as name,
         cast(type as varchar) as type,
         cast(price as int) as price,
         cast(description as varchar) as description
from read_csv_auto('s3://dbt-learn-sample-data/raw_products.csv')