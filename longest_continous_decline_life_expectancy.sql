/* This SQL query uses the life_expectancy db, and attempts to find the longest year after year period of continous decline in life expectancy in a country. The initial dataset
contains a mix of countries, regions such as Europe and Africa, and collections of nations such as 'High-income countries'. */

/* This CTE collects all the data from the life_expectancy db. It then looks to see if a countries life expectancy is lower than the previous year. If it is _not_ lower, ie if 
life expectancy has increased, it returns the current year. This is so we can collect the start and end periods of life expectancy decline. Finally, it filters out non-countries  */
with lagged_life_expectancy as (
    select 
        entity
        , code
        , year
        , max(year) over(partition by code order by null) as max_country_year
        , lag(year) over(partition by code order by year) as previous_year --not all years in this dataset will be 1 year earlier than the current row year. Some may be 5 or 10
        , year - previous_year as previous_period_year_difference 
        , life_expectancy
        , lag(life_expectancy) over(partition by code order by year) as previous_life_expectancy
        , case
            when max_country_year = year then year --This line is required, otherwise if the last row of a country is part of a decline period, it will be skipped
            when previous_life_expectancy - life_expectancy <= 0 then year 
            else null 
        end as life_expectency_increase_years
    from life_expectancy 
    where code is not null and code != 'OWID_WRL' --all countries, other than the 'World', have a null code value
)

/* This CTE removes the periods of decline, so we are left with only rows where there is an increase in life expectancy. It then uses a lag function to calculate the number of 
years it's been since the previous increase in life expectancy. The larger the time period, the longer the period of continuous decline. -1 is then removed from the 
no_of_years_of_decline to ensure the value starts from the first year of decline, and not the last period of increase. */
, define_decline_periods as (
    select
        entity
        , code
        , year
        , life_expectancy
        , previous_life_expectancy
        , previous_period_year_difference
        , life_expectency_increase_years
        , life_expectency_increase_years - lag(life_expectency_increase_years) over(partition by code order by year) - 1 as no_years_of_decline
    from lagged_life_expectancy
    where life_expectency_increase_years is not null
)


/* This final select statement returns the results. As the request was to return the largest year after year decline, it also removed any time periods where the previous 
period was more than one year in the past */
select
    entity as country
    , year - no_years_of_decline as year_start
    , year - 1 as year_end
from define_decline_periods
where previous_period_year_difference = 1
order by no_years_of_decline desc
limit 1