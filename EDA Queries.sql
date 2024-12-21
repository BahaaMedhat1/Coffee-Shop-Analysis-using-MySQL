-- 1. How many people in each city are estimated to consume coffee from the shope.
with customer_city as (
select distinct
	s.customer_id,
    cty.city_name
from
	sales as s
inner join
	customer as cust
on
	s.customer_id = cust.customer_id
left join
	city as cty
on
	cty.city_id = cust.city_id)
    
select
	city_name,
    concat(round(count(customer_id) / (select count(*) from customer_city) * 100, 2), "%") as coffee_perc
from
	customer_city
group by 
	city_name;
    


    
    

-- 2. What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
with city_revenue as(
select
	cty.city_name,
	s.sale_date,
    s.total,
    s.customer_id
from
	sales as s
left join
	customer as cust
on
	cust.customer_id = s.customer_id
left join
	city as cty
on
	cty.city_id = cust.city_id
where
	year(sale_date) = 2023
    and quarter(sale_date) = 4)
    
select
	city_name,
    quarter(sale_date) as qurat,
    concat( format( sum(total), 0), " $") as Total_Revenue
from
	city_revenue
group by 
	city_name, quarter(sale_date)
order by sum(total) desc;





-- 3. What is the average sales amount per customer in each city?
with avg_customer as (
select
	customer_id,
    round(avg(total), 2) as avg_total
from
	sales
group by 
	customer_id)

select
	cty.city_name,
    avc.customer_id,
    avc.avg_totalf
from
	avg_customer as avc
left join
	customer as cust
on
	cust.customer_id = avc.customer_id
left join
	city as cty
on
	cty.city_id = cust.city_id;






-- 4. How many units of each coffee product have been sold?
select
	prod.product_name,
    format( count(s.product_id), 0 )as num_sold
from
	sales as s
left join
	product as prod
on
	prod.product_id = s.product_id
group by	
	prod.product_name
order by count(s.product_id) desc;






-- 5. What are the top 3 selling products in each city based on sales volume?
with city_product as(
select
	city.city_name,
	prod.product_name,
    s.total,
    s.customer_id
from
	sales as s
left join
	product as prod
on
	prod.product_id = s.product_id
left join
	customer as cust
on
	cust.customer_id = s.customer_id
left join
	city
on
	city.city_id = cust.city_id), 
rank_city_product as(
select
	city_name,
	product_name,
	sum(total) as total_sales,
    row_number() over(PARTITION BY city_name order by sum(total) desc) as row_rank
from	
	city_product
group by	
	city_name, product_name)
select
	*
from
	rank_city_product
where
	row_rank <= 3;
    
    
    
    
    


-- 6. How many unique customers are there in each city who have purchased coffee products?
with customer_city as (
select distinct
	s.customer_id,
    cty.city_name
from
	sales as s
inner join
	customer as cust
on
	s.customer_id = cust.customer_id
left join
	city as cty
on
	cty.city_id = cust.city_id)
select
	city_name,
    count(customer_id) as num_customer
from
	customer_city
group by 
	city_name;
    
    
    
    
    
    
    

-- 7.Find each city and their average sale per customer and avg rent per customer
with city_avg as(
select
	city.city_name,
    city.estimated_rent,
    cust.customer_id,
    s.total
from
	city
left join
	customer as cust
on
	cust.city_id = city.city_id
left join
	sales as s
on
	s.customer_id = cust.customer_id)
select
	city_name,
	format(avg(estimated_rent), 0) as avg_rent,
    format(avg(total), 0) as avg_total
from
	city_avg
group by	
	city_name;








-- 8. Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly) by each city.
with growth_city as (
select
	city.city_name,
    year(s.sale_date) as year,
    month(s.sale_date) as month,
    sum(s.total) as Revenue,
    lag(sum(s.total)) over (PARTITION BY city.city_name , year(s.sale_date) order by year(s.sale_date) , month(s.sale_date)) as last_revenue
from
	sales as s
left join
	customer as cust
on
	cust.customer_id = s.customer_id
left join
	city
on
	city.city_id = cust.city_id
group by
	1,2,3
order by 1,2,3 )
select
	*, 
    ifnull(
           concat(
				   round( 
						  (revenue - last_revenue) / last_revenue * 100 
                          , 2)
                              , "%"), 0) as growth_rate
                              
from
	growth_city;
    







-- 9. Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer
select
	 city.city_name,
     format(sum(s.total), 0) as total_sales,
	 format(count(s.customer_id), 0) as num_customer,
     format(avg(city.estimated_rent), 0) as avg_rent
from
	sales as s
left join
	customer as cust
on
	cust.customer_id = s.customer_id
right join
	city
on
	city.city_id = cust.city_id
group by	
	city.city_name
order by
	sum(s.total) desc
limit 3;