
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='view') }}

with bank_assets as (

  SELECT institution_name, state_name, total_assets
FROM `bigquery-public-data.fdic_banks.institutions` 
WHERE total_assets IS NOT NULL
GROUP BY state_name, institution_name, total_assets
ORDER BY state_name, total_assets, institution_name
)

select *
from bank_assets;

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
