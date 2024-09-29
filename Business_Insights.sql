select * from gdb041.dim_customer;
select * from gdb041.dim_market;
select * from gdb041.dim_product;
select * from gdb041.fact_sales_monthly;
select * from gdb041.fact_forecast_monthly;

select * from gdb056.freight_cost;
select * from gdb056.gross_price;
select * from gdb056.manufacturing_cost;
select * from gdb056.post_invoice_deductions;
select * from gdb056.pre_invoice_deductions;

-- data cleaning
UPDATE gdb041.dim_market
SET region = 'NA'
WHERE region = 'nan';

UPDATE gdb041.dim_market
SET sub_zone = 'NA'
WHERE sub_zone = 'nan';

-- create fiscal year column in fact_sales_monthly_table
	-- Add the fiscal_year column
ALTER TABLE gdb041.fact_sales_monthly
ADD COLUMN fiscal_year INT;

	-- Update the fiscal_year column with the correct values
UPDATE gdb041.fact_sales_monthly
SET fiscal_year = CASE 
        WHEN MONTH(date) >= 9 THEN YEAR(date) + 1
        ELSE YEAR(date)
    END;

-- 1. Provide the list of customers in North America region.

select 
	customer, 
    cust.market, 
    region 
from gdb041.dim_customer cust
join gdb041.dim_market mark
on cust.market = mark.market
where region = 'NA';

-- 2. Percentage of unique product increase in 2021 vs. 2020. 
with products_2020 as 
(select 
	count(distinct(product_code)) as unique_products_2020
from gdb041.fact_sales_monthly
where fiscal_year = 2020),
products_2021 as 
(select 
	count(distinct(product_code)) as unique_products_2021
from gdb041.fact_sales_monthly
where fiscal_year = 2021)
select 
	products_2020.unique_products_2020,
    products_2021.unique_products_2021,
    round(((unique_products_2021 - unique_products_2020)/unique_products_2020)*100,2) as pct_change
from products_2020
cross join products_2021;

-- 3. Unique product counts for each segment sorted in descending order of product counts.

select 
	segment, 
    count(distinct(product_code)) as product_count 
from gdb041.dim_product
group by segment
order by product_count desc;

-- 4. Segment woth the most increase in unique products in 2021 vs 2020?
with cte1 as 
(select 
	p.segment, 
    count(distinct(p.product_code)) as product_count_2020
from gdb041.dim_product p
join fact_sales_monthly fsm
on p.product_code = fsm.product_code
where fiscal_year = 2020
group by segment),
cte2 as 
(select 
	p.segment, 
    count(distinct(p.product_code)) as product_count_2021
from gdb041.dim_product p
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


-- 5. Top 10 lowest cost products to manufacture. 
select 
    p.product,
   round(avg(manufacturing_cost),2) as manufacturing_cost
from gdb041.dim_product p
join gdb056.manufacturing_cost mc
on p.product_code = mc.product_code
group by product
order by manufacturing_cost asc
limit 10;

-- 5 Top 10 highest cost products to manufacture
select 
    p.product,
   round(avg(manufacturing_cost),2) as manufacturing_cost
from gdb041.dim_product p
join gdb056.manufacturing_cost mc
on p.product_code = mc.product_code
group by product
order by manufacturing_cost desc
limit 10;


/*6. Generate a report which contains the top 5 customers who received an
average highest pre_invoice_discount_pct for the fiscal year 2021 and in the
Canadian market. */


select 
	pid.customer_code,
    c.customer,
	round(avg(pre_invoice_discount_pct) *100,2) as average_discount_percentage
from gdb056.pre_invoice_deductions pid
join gdb041.dim_customer c
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
from gdb041.fact_sales_monthly fsm
join gdb056.gross_price fgp
on fsm.product_code = fgp.product_code
join dim_customer c
on fsm.customer_code = c.customer_code 
where customer = 'Atliq Exclusive'
group by year(date), month(date)
order by year(date) asc, month(date) asc; 

/*8. Quarter of 2020 with the maximum total sold quantity? */

-- using order by and limit
select 
	quarter(date) as quarter,
    sum(sold_quantity) as total_sold_quantity
from gdb041.fact_sales_monthly 
where fiscal_year = 2020
group by quarter
order by total_sold_quantity desc
limit 1;

-- using CTE
with quarterly_sales as
(select 
	quarter(date) as quarter,
    sum(sold_quantity) as total_sold_quantity
from gdb041.fact_sales_monthly 
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
	from gdb041.dim_customer c
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


-- 10. Get the Top 3 products in each division that have highest total_sold_quantity in the fiscal_year 2021? 
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
	from gdb041.dim_product p
	join gdb041.fact_sales_monthly fsm
	on p.product_code = fsm.product_code 
	where fiscal_year = 2021
	group by division, product_code, product
    ) ranked_products
where rank_order <=3
order by division, rank_order;

-- 11. Find top/ bottom 5 customers in terms of sold quantity
	-- Top 5 customers
select 
    customer,
    sum(sold_quantity) as total_sold_quantity
from gdb041.dim_customer c
join gdb041.fact_sales_monthly fsm
on c.customer_code = fsm.customer_code
group by customer
order by total_sold_quantity desc
limit 5;

	-- Bottom 5 customers.
select 
    customer,
    sum(sold_quantity) as total_sold_quantity
from gdb041.dim_customer c
join fact_sales_monthly fsm
on c.customer_code = fsm.customer_code
group by customer
order by total_sold_quantity asc
limit 5;