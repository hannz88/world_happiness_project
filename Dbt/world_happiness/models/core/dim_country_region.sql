{{
    config(
        materialized='table'
    )
}}

with country_regiondata as(
    select
        {{ dbt_utils.generate_surrogate_key(['country', 'region']) }} as countryid,
        country, region
    from {{ref('stg_country')}}
)
select
    *
from country_regiondata