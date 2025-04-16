{{ config(materialized='view') }}

with world_happiness_data as(
    select
        *
    from {{source('staging', 'world_happiness')}}
)
select
    {{ dbt_utils.generate_surrogate_key(['Country_Name', 'Year']) }} as happinessid,
    Country_Name as country,
    Regional_Indicator as region,
    {{ dbt.safe_cast("Year", api.Column.translate_type("integer")) }} as year,

    coalesce(cast(Life_Ladder as numeric), null) as happiness_score,
    coalesce(cast(Log_GDP_Per_Capita as numeric), null) as log_gdp,
    coalesce(cast(Social_Support as numeric), null) as soc_support,
    coalesce(cast(Healthy_Life_Expectancy_At_Birth as numeric), null) as life_expectancy,
    coalesce(cast(Freedom_To_Make_Life_Choices as numeric), null) as freedom_life,
    coalesce(cast(Generosity as numeric), null) as generosity,
    coalesce(cast(Perceptions_Of_Corruption as numeric), null) as corruption,
    coalesce(cast(Positive_Affect as numeric), null) as pos_aff,
    coalesce(cast(Negative_Affect as numeric), null) as neg_aff,
    coalesce(cast(Confidence_In_National_Government as numeric), null) as government_confidence
from world_happiness_data
