---
title: The Impact of COVID-19 on Life Expectancy
---


## Introduction
The COVID-19 pandemic affected nearly every nation on earth in some form, and it's influence will be felt for generations to come. Despite its undeniable and devastating impact, which continues to reverberate around the globe and remain vivid in our collective memory, a closer examination of specific statistics, such as Life Expectancy, reveals yet more shocking insights.

```sql life_expectancy_db
select
    entity
    , year
    , life_expectancy
from life_expectancy
```

Average Global Life Expectancy had been rising year on year continously since 1971. Indeed, there are only three periods since 1950, when this dataset first starts to have consistent Global Life Expectancy data, where Average Life Expectancy has declined:
1. **A period between 1959 and 1961**: Which was influenced in part by the Great Leap Forward in China 
2. **A one year decline in 1971**: Which was influenced by conflicts in countries like Cambodia, India and Pakistan  
3. **The COVID-19 Pandemic in 2020 and 2021**



<LineChart
    data="{life_expectancy_db.filter(d => {
    return (
      d.entity === 'World' 
    );
  })}"
    x="year"
    y="life_expectancy"
    title="Global Life Expectancy" >
    <ReferenceLine x='1959' labelPosition=aboveStart lineType=dotted />
    <ReferenceLine x='1971' labelPosition=aboveStart lineType=dotted />
    <ReferenceLine x='2020' labelPosition=aboveStart lineType=dotted />
</LineChart>


## The Impact of COVID-19

If we focus in on the late 2010s, the true scale of COVID-19s impact becomes obvious. Only 23 countries saw decreases in Life Expectancy in 2019 compared to 2018, just 9.7% of all countries in this datset.

```sql difference_life_expectancy_2018_to_2019
/* This CTE takes the discovers the difference in Life Expectancy between 2018 and 2029 to attempt to measure some of the impact of COVID-19. It simply joins the two year values together to provide it's final output. */
with life_expectancy_2018 as (
    select
        entity
        , code
        , life_expectancy as life_expectancy_2018
    from life_expectancy
    where year = 2018
),

life_expectancy_2019 as (
    select
        entity
        , code
        , life_expectancy as life_expectancy_2019
    from life_expectancy
    where year = 2019
)
/* This filter joins the data of 2018 and 2019 together onto the same row, and then attempts to find the difference between them */
select 
    case when life_expectancy_2018 - life_expectancy_2019 > 0 then 'Life Expectancy Decreased in 2019' else 'Life Expectancy Increased in 2019' end as name
    , 2019 as year
    , count(distinct life_expectancy_2018.entity) as value
from life_expectancy_2018 
left join life_expectancy_2019 on life_expectancy_2018.entity = life_expectancy_2019.entity
where life_expectancy_2018.code is not null and life_expectancy_2018.code != 'OWID_WRL' 
group by name
```


```sql difference_life_expectancy_2019_to_2020
/* This CTE takes the discovers the difference in Life Expectancy between 2019 and 2020 to attempt to measure some of the impact of COVID-19. It simply joins the two year values together to provide it's final output. */
with life_expectancy_2019 as (
    select
        entity
        , code
        , life_expectancy as life_expectancy_2019
    from life_expectancy
    where year = 2019
),

life_expectancy_2020 as (
    select
        entity
        , code
        , life_expectancy as life_expectancy_2020
    from life_expectancy
    where year = 2020
)
/* This filter joins the data of 2019 and 2020 together onto the same row, and then attempts to find the difference between them */
select 
    case when life_expectancy_2019 - life_expectancy_2020 > 0 then 'Life Expectancy Decreased in 2020' else 'Life Expectancy Increased in 2020' end as name
    , 2020 as year
    , count(distinct life_expectancy_2019.entity) as value
from life_expectancy_2019
left join life_expectancy_2020 on life_expectancy_2019.entity = life_expectancy_2020.entity
where life_expectancy_2019.code is not null and life_expectancy_2019.code != 'OWID_WRL' 
group by name
```


```sql difference_life_expectancy_2020_to_2021
/* This CTE takes the discovers the difference in Life Expectancy between 2018 and 2020 to attempt to measure some of the impact of COVID-19. It simply joins the two year values together to provide it's final output. */
with life_expectancy_2020 as (
    select
        entity
        , code
        , life_expectancy as life_expectancy_2020
    from life_expectancy
    where year = 2020
),

life_expectancy_2021 as (
    select
        entity
        , code
        , life_expectancy as life_expectancy_2021
    from life_expectancy
    where year = 2021
)
/* This filter joins the data of 2020 and 2021 together onto the same row, and then attempts to find the difference between 2020 and 2021. */
select 
    case when life_expectancy_2020 - life_expectancy_2021 > 0 then 'Life Expectancy Decreased' else 'Life Expectancy Increased' end as life_expectancy_difference_2020_2021
    , count(distinct life_expectancy_2020.entity) as number_of_nations
from life_expectancy_2020 
left join life_expectancy_2021 on life_expectancy_2020.entity = life_expectancy_2021.entity
where life_expectancy_2020.code is not null and life_expectancy_2020.code != 'OWID_WRL' 
group by life_expectancy_difference_2020_2021
```

```sql difference_life_expectancy_1958_to_1959
/* This CTE takes the discovers the difference in Life Expectancy between 2018 and 2020 to attempt to measure some of the impact of COVID-19. It simply joins the two year values together to provide it's final output. */
with life_expectancy_1958 as (
    select
        entity
        , code
        , life_expectancy as life_expectancy_1958
    from life_expectancy
    where year = 1958
),

life_expectancy_1959 as (
    select
        entity
        , code
        , life_expectancy as life_expectancy_1959
    from life_expectancy
    where year = 1959
)
/* This filter joins the data of 1958 and 1959 together onto the same row, and then attempts to find the difference between 1958 and 1959. */
select 
    case when life_expectancy_1958 - life_expectancy_1959 > 0 then 'Life Expectancy Decreased in 1959' else 'Life Expectancy Increased in 1959' end as name
    , count(distinct life_expectancy_1958.entity) as value
from life_expectancy_1958 
left join life_expectancy_1959 on life_expectancy_1958.entity = life_expectancy_1959.entity
where life_expectancy_1958.code is not null and life_expectancy_1958.code != 'OWID_WRL' 
group by name
```


##### Number of Countries Whose Life Expetancy Increased/Decreased: 2019
<ECharts config={
    {
        tooltip: {
            formatter: '{b}: {c} ({d}%)'
        },
        series: [
        {
          type: 'pie',
          data: difference_life_expectancy_2018_to_2019,
          color: ['#004c6d', '#5886a5'] 
        }
      ]
      }
    }
/>

However, just one year later, the momentum had changed entirely. 159 countries (67%), saw a decline in Average Life Expectancy in 2020 compared to 2019. A 590% increase from the year prior.

##### Number of Countries Whose Life Expetancy Increased/Decreased: 2020
<ECharts config={
    {
        tooltip: {
            formatter: '{b}: {c} ({d}%)'
        },
        series: [
        {
          type: 'pie',
          data: difference_life_expectancy_2019_to_2020,
          color: ['#5886a5', '#004c6d'] 
        }
      ]
      }
    }
/>

When we compare this to the largest one-year decline in the dataset before the pandemic, which occurred in 1958-59, the true gravity of the situation becomes starkly evident.

##### Number of Countries Whose Life Expetancy Increased/Decreased: 1959
<ECharts config={
    {
        tooltip: {
            formatter: '{b}: {c} ({d}%)'
        },
        series: [
        {
          type: 'pie',
          data: difference_life_expectancy_1958_to_1959,
          color: ['#004c6d', '#5886a5'] 
        }
      ]
      }
    }
/>

In 1959, only 30 countries experienced a decrease in life expectancy compared to the previous year. In 2020, 159 did.

The significant drop in 1959 was predominantly due to a dramatic decrease in Life Expectancy in China, stemming from social restructuring. This caused average Life Expectancy to plummet from 48.8 in 1958 to 39.7 in 1959. 

While no single country had a decline to the same extent during the COVID-19 pandemic, [primarily because the virus disproportionately affected older populations](https://www.cdc.gov/mmwr/volumes/69/wr/mm695152a8.htm), the overall scale of it's impact is unprecedented in the context of the second half of the 20th century.

Two global influenza pandemics in 1957, and 1968, which claimed millions of lives worldwide, did not result in a decrease or even stagnation in overall Life Expectancy. In contrast, the spread and nature of COVID-19 was sufficient enough to halt the longest, continuous period of growth in Global Life Expectancy in recorded history. 

Unlike the earlier instances we mentioned of declining Life Expectancy, which were relatively isolated and could be reversed or balanced out by increases in Life Expectancy in other countries, the worldwide spread of COVID-19 has made such reversals sometimes feel impossible.

## Countries with the highest decrease in Life Expectancy in 2020

Most nations saw impacts to their average Life Expectancy in 2020, but unfortunately, some nations felt it more severely than others. 

```sql most_impacted_countries
/* This CTE takes the discovers the difference in Life Expectancy between 2018 and 2021 to attempt to measure some of the impact of COVID-19. It simply joins the four year values together to provide it's final output. */

with life_expectancy_2018 as (
    select
        entity
        , code
        , life_expectancy as life_expectancy_2018
    from life_expectancy
    where year = 2018
),
life_expectancy_2019 as (
    select
        entity
        , code
        , life_expectancy as life_expectancy_2019
    from life_expectancy
    where year = 2019
),

life_expectancy_2020 as (
    select
        entity
        , code
        , life_expectancy as life_expectancy_2020
    from life_expectancy
    where year = 2020
),

life_expectancy_2021 as (
    select
        entity
        , code
        , life_expectancy as life_expectancy_2021
    from life_expectancy
    where year = 2021
)
/* This filter joins the data of 2018, 2019 and 2020 together onto the same row, and then attempts to find the difference between 2018 and 2019 and 2019 and 2020. */
select 
    life_expectancy_2018.entity
    , life_expectancy_2018 - life_expectancy_2019 as life_expectancy_decrease_2018_2019
    , life_expectancy_2019 - life_expectancy_2020 as life_expectancy_decrease_2019_2020
    , life_expectancy_2019 - life_expectancy_2021 as life_expectancy_decrease_2019_2021
from life_expectancy_2018
left join life_expectancy_2019 on life_expectancy_2018.entity = life_expectancy_2019.entity
left join life_expectancy_2020 on life_expectancy_2018.entity = life_expectancy_2020.entity
left join life_expectancy_2021 on life_expectancy_2018.entity = life_expectancy_2021.entity
where life_expectancy_2018.code is not null and life_expectancy_2018.code != 'OWID_WRL' 
order by life_expectancy_decrease_2019_2020 desc
```
 <BarChart
    data="{most_impacted_countries.slice(0,10)}"
    x="entity"
    y="life_expectancy_decrease_2019_2020"
    swapXY=true
    labels=true
    title="Top 10 Countries with the Largest Decline in Life Expectancy: 2019-2020"
    sort=true
/>

Among these 10 nations, all but three had experienced increases in life expectancy from 2018 to 2019. Even in the cases of the exceptions, Andorra, Oman, and Kuwait, the declines were relatively minor in comparison. 

Azerbaijan, meanwhile, which had witnessed a continuous rise in life expectancy since 1994, saw the most dramatic reversal, dropping to its lowest level since 2003. Though Azerbaijan was involved in a conflict in late 2020, this "only" involved up to 5000 casualties, and would not account for the entirety of this decline.

<LineChart
    data="{life_expectancy_db.filter(d => {
    return (
      d.entity === 'Azerbaijan' &
      d.year > 1994
    );
  })}"
    x="year"
    y="life_expectancy"
    yMin=50
    title="Life Expectancy in Azerbaijan"
/>

## Signs of Healing

The effects of the COVID-19 pandemic will be felt long into the future by nearly every nation on earth. But, thankfully, even only 1 year after the Pandemic started for most countries, there are signs of Life Expectancy recovering, however small.

<BarChart
    data="{difference_life_expectancy_2020_to_2021}"
    x="life_expectancy_difference_2020_2021"
    y="number_of_nations"
    labels=true
    title="Number of Countries whose Life Expectancy Increased or Decreased: 2020-2021"
    sort=true
/>

84 countries saw an increase in Life Expectancy in 2021, compared to 78 in 2020. Though many of these countries have not reached their pre-Pandemic levels, and 153 countries still faced a further decline in Life Expectancy, it is encouraging that some nations could see at least a minor reversal, even whilst the Pandemic still continued to rage.

## Much to be Hopeful for

Prior to the onset of the COVID-19 pandemic, a consistent trend of global Life Expectancy growth was evident. It is heartening to observe countries where Life Expectancy continued to rise year after year.

Take Paraguay, for instance, which enjoyed an impressive 87-year streak of continuous Life Expectancy increase, only interrupted in 2020. While there have been specific, elongated instances of Life Expectancy decline during the 20th and 21st centuries, such as Zambia between 1978 and 1999, the overarching momentum has undeniably favoured an increase in Life Expectancy worldwide.

While the path forward may be gradual and come with its share of difficulties, historical trends offer encouragement that this positive pattern is likely to return, and hopefully, sooner rather than later.

```sql largest_continous_increase_life_expectancy_countries
/* This SQL query uses the life_expectancy db, and attempts to find the longest year after year period of continous increase in life expectancy in an entity. The data contains a mix of countries and regions such as Europe and Africa, and collections of nations such as 'High-income countries'. */

/* This CTE collects all the data from the life_expectancy db. It then looks to see if a countries life expectancy is higher than the previous year. If it _is_ lower, it returns the current year. This is so we can collect the start and end periods of life expectancy increases. Finally, it filters out non-countries  */
with lagged_life_expectancy as (
    select 
        entity
        , code
        , year
        , max(year) over(partition by code order by null) as max_country_year
        , year - lag(year) over(partition by code order by year) as previous_period_year_difference
        , life_expectancy
        , lag(life_expectancy) over(partition by code order by year) as previous_life_expectancy
        , case
            when max_country_year = year then year --This line is required, otherwise if the last row of a country is part of an increase period, it will be skipped
            when previous_life_expectancy - life_expectancy > 0 then year 
            else null 
        end as life_expectency_increase
    from life_expectancy 
    where code is not null and code != 'OWID_WRL' 
)

/* This CTE removes the periods of increase, so we are left with only rows where there is an decrease in life expectancy. It then uses a lag function to calculate the number of years it's been since the previous decrease in life expectancy. The larger the time period, the longer the period of continuous increase */
, define_decline_periods as (
    select
        entity
        , code
        , year
        , life_expectancy
        , previous_life_expectancy
        , previous_period_year_difference
        , life_expectency_increase
        , life_expectency_increase - lag(life_expectency_increase) over(partition by code order by year) - 1 as years_of_increase
    from lagged_life_expectancy
    where life_expectency_increase is not null
)


/* This final select statement returns the results */
select
    entity
    , year - years_of_increase as year_start
    , year -1 as year_end
    , years_of_increase
from define_decline_periods
order by years_of_increase desc
limit 10
```

<BarChart
    data="{largest_continous_increase_life_expectancy_countries}"
    x="entity"
    y="years_of_increase"
    swapXY=true
    labels=true
    title="Top 10 Longest Continous Increases in Life Expectancy"
/>