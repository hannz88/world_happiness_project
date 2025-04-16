{{
    config(
        materialized='table'
    )
}}

with world_happiness_data as(
    select
        year,
        country,
        happiness_score,
        log_gdp,
        soc_support,
        life_expectancy,
        freedom_life,
        generosity,
        corruption,
        pos_aff,
        neg_aff,
        government_confidence
    from {{ ref('stg_world_happiness') }}
)
select
    *
from world_happiness_data