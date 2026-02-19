# -- 1. Get all BMW cars sold after 2020

```sql
select model, year, region, price_usd, sales_volume
from bmw_sales
where year > 2020
order by year;
```

# -- 2. Find only Electric cars

```sql
select model, fuel_type, price_usd
from bmw_sales
where fuel_type = 'Electric';
```

# -- 3. Average price by fuel type

```sql
select fuel_type, round(avg(price_usd), 2) as avg_price
from bmw_sales
group by fuel_type
order by avg_price desc;
```

# -- 4. Highest and lowest price

```sql
select max(price_usd) as highest_price, min(price_usd) as lowest_price
from bmw_sales;
```

# -- 5. Categorize cars by price range

```sql
select model, price_usd, case 
when price_usd < 50000 then 'Budget'
when price_usd between 50000 and 100000 then 'Mid-Range'
else 'Premium' end as price_category
from bmw_sales;
```

# -- 6. Cars priced above average

```sql
select model, price_usd
from bmw_sales
where price_usd > (select avg(price_usd)
from bmw_sales)
order by price_usd desc;
```

# Assume:

REGIONS(region_id, region_name)

BMW_SALES(region_id, model, year, price_usd, sales_volume)

# -- 7. Show sales with readable region name

```sql
select b.model, b.year, r.region_name, b.sales_volume
from bmw_sales b
inner join regions r
on b.region_id = r.region_id
order by b.year;
```

# -- 8. Total sales per region

```sql
select r.region_name, sum(b.sales_volume) as total_sales
from bmw_sales b
join regions r
on b.region_id = r.region_id
group by r.region_name
order by total_sales desc;
```

# -- 9. Regions where average price is above overall average

```sql
select r.region_name, round(avg(b.price_usd), 2) as avg_price
from bmw_sales b
join regions r on b.region_id = r.region_id
group by r.region_name
having avg(b.price_usd) > (select avg(price_usd)
from bmw_sales);
```

# -- 10. Full sales report with model and region details

```sql
select m.model_name, m.engine_size_l, r.region_name, b.year, b.price_usd, b.sales_volume
from bmw_sales b
join models m on b.model_id = m.model_id
join regions r on b.region_id = r.region_id
order by b.year desc;
```

# -- 11. Rank models by sales inside each region

```sql
select r.region_name, m.model_name, b.sales_volume,
rank() over (partition by r.region_name order by b.sales_volume desc) as sales_rank
from bmw_sales b
join regions r on b.region_id = r.region_id
join models m on b.model_id = m.model_id;
```
