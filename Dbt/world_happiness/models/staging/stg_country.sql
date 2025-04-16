{{ config(materialized='view') }}

with world_happiness_data as(
    select
        *
    from {{source('staging', 'world_happiness')}}
)
select
    distinct
    Country_Name as country,
    Regional_Indicator as region
from world_happiness_data
