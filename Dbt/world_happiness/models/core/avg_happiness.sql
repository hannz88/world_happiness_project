{{
    config(
        materialized='table'
    )
}}

with happiness_data as(
    select
        *
    from {{ ref('stg_world_happiness') }}
)
select
    country,
    avg(happiness_score) as happiness_score,
    avg(log_gdp) as avg_log_gdp,
    avg(soc_support) as avg_soc_support,
    avg(life_expectancy) as avg_life_expectancy,
    avg(freedom_life) as avg_freedom_life,
    avg(generosity) as avg_generosity,
    avg(corruption) as avg_corruption,
    avg(pos_aff) as avg_pos_aff,
    avg(neg_aff) as avg_neg_aff,
    avg(government_confidence) as avg_government_confidence
from happiness_data
group by country