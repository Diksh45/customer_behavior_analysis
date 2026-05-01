select * from customer

--1. Total reveneu granted by male vs female customers
select gender, sum(purchase_amount) as revenue
from customer
group by gender

--2. Which customer use discount but still spent more than average amount
select customer_id, purchase_amount
from customer
where discount_applied = 'Yes' and purchase_amount >= (select avg(purchase_Amount) from customer)

--3. Top 5 products with highest avg review ratings
select item_purchased, round(avg(review_rating::numeric),2) as review
from customer
group by item_purchased
order by review desc
limit 5

--4. Compare avg purchase amounts between std and express shiping
select shipping_type, round(avg(purchase_amount),2) as amount
from customer
where shipping_type in ('Standard', 'Express') 
group by shipping_type

--5. Do subscribed customers spend more? Compare average spend and total revenue 
--between subscribers and non-subscribers.
select subscription_status, count(customer_id),
	  round(avg(purchase_amount),2) as avg_spend,
	  round(sum(purchase_amount),2) as tot_revenue
from customer
group by subscription_status
order by tot_revenue, avg_spend desc
	  
--6. Which 5 products have the highest percentage of purchases with discounts applied?
select item_purchased,
	   round(100* sum(case when discount_applied = 'Yes' then 1 else 0 end) / count(*), 2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5

--7. Segment customers into New, Returning, and Loyal based on their total 
-- number of previous purchases, and show the count of each segment. 
with customer_type as (
select customer_id, previous_purchases,
case
	when previous_purchases = 1 then 'New'
	when previous_purchases between 2 and 10 then 'Reurning'
	else 'Loyal'
	end as customer_segment
from customer
)

select customer_segment, count(*) as no_of_customers
from customer_type
group by customer_segment

--Q8. What are the top 3 most purchased products within each category? 
with item_counts as (
select category, item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category, item_purchased
)

select item_rank, category item_purchased, total_orders
from item_counts
where item_rank <= 3

--Q9. Are customers who are repeat buyer
--Q10. What is the revenue contribution of each age group? 
select age_group, sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue descs (more than 5 previous purchases) also likely to subscribe?
select subscription_status, count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status
