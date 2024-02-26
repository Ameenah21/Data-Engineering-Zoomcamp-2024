{{ config(materialized='view') }}
 
with fhvdata as 
(
  select *
  from {{ source('staging','fhv_2019') }}
  WHERE EXTRACT(YEAR FROM pickup_datetime) = 2019 
)

select
    {{ dbt.safe_cast("pulocationid", api.Column.translate_type("integer")) }} as pickup_locationid,

    {{ dbt.safe_cast("dolocationid", api.Column.translate_type("integer")) }} as dropoff_locationid,

    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime
from fhvdata