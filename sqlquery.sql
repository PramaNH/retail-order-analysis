create table df_orders (
	[order_id] int primary key,
	[order_date] date,
	[ship_mode] varchar(20),
	[segment] varchar(20),
	[country] varchar(20),
	[city] varchar(20),
	[state] varchar(20),
	[postal_code] varchar(20),
	[region] varchar(20),
	[category] varchar(20),
	[sub_category] varchar(20),
	[product_id] varchar(50),
	[quantity] int,
	[discount] decimal(7,2),
	[sale_price] decimal(7,2),
	[profit] decimal(7,2)
)

select * from df_orders 


-- Questions
-- 1. Find top 10 highest revenue generating products

select top 10 product_id, sum(sale_price) as sales
from df_orders
group by product_id
order by sales desc
 
-- 2. Find top 5 highest selling product in each region

with cte as(
select region, product_id, sum(sale_price) as sales
from df_orders
group by product_id, region
order by region, sales desc
) select * from 
(select *
, row_number() over (partition by region order by sales desc) as rn
from cte) A
where rn<=5

-- 3. find month over month growth comparison for 2022 and 2023 sales 
-- ex: jan 2022 vs jan 2023

with cte as (
select year(order_date) as order_year, month(order_date) as order_month,
sum(sale_price) as sales
from df_orders
group by year(order_date), month(order_date)
-- order by year(order_date), month(order_date)
) select order_month, 
sum(case when order_year = 2022 then sales else 0 end) as sales_2022,
sum(case when order_year = 2023 then sales else 0 end)as sales_2023
from cte
group by order_month
order by order_month


-- 4. for each category which month had highest sales

select * from df_orders 


with cte as (
select category, format(order_date,'yyyyMM') as order_year_month,
sum(sale_price) as sales
from df_orders
group by category, format(order_date,'yyyyMM')
) 
select * from(
select *, 
row_number() over(partition by category order by sales desc) rn
from cte
) a where rn = 1


with cte1 as (
select category, format(order_date,'yyyyMM') as order_year_month,
sum(sale_price) as sales
from df_orders
group by category, format(order_date,'yyyyMM')
) select top 3 category, tot_sales from (select category, max(sales) as tot_sales 
from cte1
group by category) a
order by tot_sales desc


