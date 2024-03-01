{{ config(materialized='table') }}

with cte_bank as (
	SELECT 
		institution_name, 
		total_assets, 
		zip_code 
  FROM `bigquery-public-data.fdic_banks.institutions` 
  where active is true )

select 
	count(cte_bank.institution_name) as number_of_banks, 
	sum(cte_bank.total_assets) as assets_per_zipcode, 
	zipcode, 
	AVG( population) as pop_avg
  FROM `bigquery-public-data.census_bureau_usa.population_by_zip_2010` 
	right join cte_bank on cte_bank.zip_code = zipcode
	group by zipcode

