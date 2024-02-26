{{ config(materialized='table') }}

with fhv_dim as (
    select * from {{ref('stg_fhv_tripdata')}}
), 
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)

select
    fhv_dim.pickup_locationid,
    fhv_dim.dropoff_locationid,
    fhv_dim.pickup_datetime,
    fhv_dim.dropoff_datetime,
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone, 
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,
    from fhv_dim
    inner join dim_zones as pickup_zone
    on fhv_dim.pickup_locationid = pickup_zone.locationid
    inner join dim_zones as dropoff_zone
    on fhv_dim.dropoff_locationid = dropoff_zone.locationid