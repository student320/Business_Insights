select * from dim_customer;
select * from dim_product;
select * from fact_gross_price;
select * from fact_manufacturing_cost;
select * from fact_pre_invoice_deductions;
select * from fact_sales_monthly;


-- 1. Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.
select 
	customer, 
    market, 
    region 
from dim_customer
where customer = "Atliq Exclusive" and region = "APAC";

-- 2. What is the percentage of unique product increase in 2021 vs. 2020? 

with products_2020 as 
(select 
	count(distinct(product_code)) as unique_products_2020
from fact_sales_monthly
where fiscal_year = 2020),
products_2021 as 
(select 
	count(distinct(product_code)) as unique_products_2021
from fact_sales_monthly
where fiscal_year = 2021)
select 
	products_2020.unique_products_2020,
    products_2021.unique_products_2021,
    round(((unique_products_2021 - unique_products_2020)/unique_products_2020)*100,2) as pct_change
from products_2020
cross join products_2021;

-- 3. Provide a report with all the unique product counts for each segment and sort them in descending order of product counts.

select 
	segment, 
    count(distinct(product_code)) as product_count 
from dim_product
group by segment
order by product_count desc;


-- 4. Follow-up: Which segment had the most increase in unique products in 2021 vs 2020?
with cte1 as 
(select 
	p.segment, 
    count(distinct(p.product_code)) as product_count_2020
from dim_product p
join fact_sales_monthly fsm
on p.product_code = fsm.product_code
where fiscal_year = 2020
group by segment),
cte2 as 
(select 
	p.segment, 
    count(distinct(p.product_code)) as product_count_2021
from dim_product p
join fact_sales_monthly fsm
on p.product_code = fsm.product_code
where fiscal_year = 2021
group by segment)

select 
	cte1.segment,
	product_count_2020,
	product_count_2021,
    product_count_2021 - product_count_2020 as difference
from cte1
join cte2
on cte1.segment = cte2.segment
order by difference desc;


-- 5. top 10 lowest cost products. 
select 
    p.product,
   round(avg(manufacturing_cost),2) as manufacturing_cost
from dim_product p
join fact_manufacturing_cost fmc
on p.product_code = fmc.product_code
group by product
order by manufacturing_cost asc
limit 10;

-- 5 follow up: highest cost products
select 
	p.product_code,
    p.product,
    manufacturing_cost
from dim_product p
join fact_manufacturing_cost fmc
on p.product_code = fmc.product_code
where fmc.manufacturing_cost = (select max(manufacturing_cost) from fact_manufacturing_cost)
union all
-- lowest cost
select 
	p.product_code,
    p.product,
    manufacturing_cost
from dim_product p
join fact_manufacturing_cost fmc
on p.product_code = fmc.product_code
where fmc.manufacturing_cost = (select min(manufacturing_cost) from fact_manufacturing_cost);

/*6. Generate a report which contains the top 5 customers who received an
average high pre_invoice_discount_pct for the fiscal year 2021 and in the
Canadian market. */


select 
	pid.customer_code,
    c.customer,
	round(avg(pre_invoice_discount_pct) *100,2) as average_discount_percentage
from fact_pre_invoice_deductions pid
join dim_customer c
on pid.customer_code = c.customer_code
where fiscal_year = 2021 and market = "Canada"
group by pid.customer_code, c.customer
order by average_discount_percentage desc
limit 5;



/*7. Get the complete report of the Gross sales amount for the customer “Atliq
Exclusive” for each month. This analysis helps to get an idea of low and
high-performing months and take strategic decisions. */

select 
	month(date) as month,
    year(date) as year,
    round(sum((sold_quantity * gross_price))/1000000,2) as gross_sales_mln
from fact_sales_monthly fsm
join fact_gross_price fgp
on fsm.product_code = fgp.product_code
join dim_customer c
on fsm.customer_code = c.customer_code 
where customer = 'Atliq Exclusive'
group by year(date), month(date)
order by year(date) asc, gross_sales_mln asc; 

/*8. In which quarter of 2020, got the maximum total_sold_quantity? */

-- using order by and limit
select 
	quarter(date) as quarter,
    sum(sold_quantity) as total_sold_quantity
from fact_sales_monthly 
where fiscal_year = 2020
group by quarter
order by total_sold_quantity desc
limit 1;

-- using CTE
with quarterly_sales as
(select 
	quarter(date) as quarter,
    sum(sold_quantity) as total_sold_quantity
from fact_sales_monthly 
where fiscal_year = 2020
group by quarter)
select 
	quarter,
    total_sold_quantity
from quarterly_sales
where total_sold_quantity = (
	select max(total_sold_quantity) from quarterly_sales
    );


-- 9. Gross sales per channel
with channel_sales as 
	(select 
		channel,
        (sum(sold_quantity * gross_price)) as gross_sales -- get sales per channel
	from dim_customer c
    join fact_sales_monthly fsm
    on c.customer_code = fsm.customer_code
    join fact_gross_price fgp
    on fsm.product_code = fgp.product_code
    where fsm.fiscal_year = 2021
    group by channel),
total_sales as
	(select 
		sum(gross_sales) as total_sales -- get total overall sales
	from channel_sales)
select
	channel,
    round((gross_sales/1e6),2) as gross_sales_mln, -- convert to millions
	round((gross_sales/total_sales) * 100,2) as percentage_sales -- get pct sales of each channel
from channel_sales, total_sales -- select from both ctes
order by gross_sales_mln desc;


-- 10. Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? 
 select 
	division,
    product_code,
    product,
    total_quantity_sold_thsnd,
    rank_order
from
	 (select 
		p.division,
		p.product_code,
		p.product,
		round(sum(sold_quantity)/1000,2) as total_quantity_sold_thsnd,
		dense_rank() over(partition by division order by sum(sold_quantity) desc) as rank_order
	from dim_product p
	join fact_sales_monthly fsm
	on p.product_code = fsm.product_code 
	where fiscal_year = 2021
	group by division, product_code, product
    ) ranked_products
where rank_order <=3
order by division, rank_order;


-- 11. Find top/ bottom 5 customers in terms of sold quantity

select 
    customer,
    sum(sold_quantity) as total_sold_quantity
from dim_customer c
join fact_sales_monthly fsm
on c.customer_code = fsm.customer_code
group by customer
order by total_sold_quantity desc
limit 5;

select 
    customer,
    sum(sold_quantity) as total_sold_quantity
from dim_customer c
join fact_sales_monthly fsm
on c.customer_code = fsm.customer_code
group by customer
order by total_sold_quantity asc
limit 5;

select * from fact_sales_monthly;
select * from fact_gross_price;


-- 12. find top/ bottom 5 customers in terms of gross sales and contribution margin
select
    customer,
    ROUND(SUM(sold_quantity * gross_price) / 1000000,2) AS gross_sales_mln,
    ROUND(SUM(sold_quantity * gross_price) / 1000000 - SUM(manufacturing_cost) / 1000000,2) AS contribution_margin
from dim_customer c
join fact_sales_monthly fsm 
on c.customer_code = fsm.customer_code
join fact_gross_price fgp 
on fsm.product_code = fgp.product_code
join fact_manufacturing_cost fmc 
on fmc.product_code = fgp.product_code and  fmc.cost_year = fgp.fiscal_year
group by customer
order by gross_sales_mln desc
limit 5;


select
    customer,
    ROUND(SUM(sold_quantity * gross_price) / 1000000,2) AS gross_sales_mln,
    ROUND(SUM(sold_quantity * gross_price) / 1000000 - SUM(manufacturing_cost) / 1000000,2) AS contribution_margin
from dim_customer c
join fact_sales_monthly fsm 
on c.customer_code = fsm.customer_code
join fact_gross_price fgp 
on fsm.product_code = fgp.product_code
join fact_manufacturing_cost fmc 
on fmc.product_code = fgp.product_code and  fmc.cost_year = fgp.fiscal_year
group by customer
order by gross_sales_mln asc
limit 5;

SELECT product_code, COUNT(*)
FROM fact_manufacturing_cost
GROUP BY product_code;

SELECT *
FROM fact_manufacturing_cost
order BY product_code;

-- 13. find which segment generates the most  gross sales and contribution margin

select 
    segment,
	round(sum(sold_quantity)/1000000,2) as total_sold_quantity_mln,
    round(sum(sold_quantity * gross_price)/1000000,2) as gross_sales_mln,
	ROUND(SUM(sold_quantity * gross_price) / 1000000 - SUM(manufacturing_cost) / 1000000,2) AS contribution_margin
from dim_product p
join fact_sales_monthly fsm
on p.product_code = fsm.product_code
join fact_gross_price fgp
on fsm.product_code = fgp.product_code
join fact_manufacturing_cost fmc 
on fmc.product_code = fgp.product_code and  fmc.cost_year = fgp.fiscal_year
group by segment
order by contribution_margin desc;
