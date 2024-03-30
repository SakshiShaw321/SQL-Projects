use pizza_database;
select * from pizza_sales;	
---------------------------------------------
/*KPI's*/																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																													
/* find the sum of total price of all pizza*/
select sum(total_price) from pizza_sales;
/*the average amount spent per order pizza*/
select sum(total_price)/count(distinct order_id) as Average_sales from pizza_sales;
/*Total Pizzas Sold*/
select sum(quantity)as pizza_sold from pizza_sales;
/* Total Orders*/
select count(distinct order_id) from pizza_sales;
/* Average Pizzas Per Order*/
select cast(sum(quantity) as decimal(5,2))/ 
cast(count(distinct order_id) as decimal (5,2)) from pizza_sales;
------------------------------------------------------------------------
/*Daily Trend for Total Orders*/
select Date(order_date) as order_day,count(distinct order_id) as Total_order from pizza_sales 
group by order_day;
/* Monthly Trend for Orders*/
select month(order_date) as order_day,count(distinct order_id) as Total_order from pizza_sales 
where order_date=1
group by order_day;
/*% of Sales by Pizza Category*/
select pizza_category,sum(total_price)*100/(select sum(total_price) from pizza_sales) as PCT from pizza_sales 
group by pizza_category
order by  PCT desc;
/*% of Sales by Pizza Size*/
select pizza_size,sum(total_price)*100/(select sum(total_price)from pizza_sales) as PCT from pizza_sales
group by pizza_size
order by PCT desc
/* Total Pizzas Sold by Pizza Category*/
select pizza_category,sum(quantity)as total_pizza_sold from pizza_sales
group by pizza_category
order by total_pizza_sold desc
/*Top 5 Pizzas by Revenue*/
select pizza_name_id,sum(total_price) as Revenue from pizza_sales
group by  pizza_name_id
order by revenue desc
limit 5
/*Bottom 5 Pizzas by Revenue*/
select pizza_name_id,sum(total_price) as Revenue from pizza_sales
group by  pizza_name_id
order by revenue asc
limit 5
/*Top 5 Pizzas by Quantity*/
select pizza_name_id,sum(quantity) as Total_quantity from pizza_sales
group by  pizza_name_id
order by Total_quantity  desc
limit 5
/*Bottom 5 Pizzas by Quantity*/
select pizza_name_id,sum(quantity) as Total_quantity from pizza_sales
group by  pizza_name_id
order by Total_quantity asc
limit 5
/*Top 5 Pizzas by Total Orders*/
select pizza_name_id,count(distinct Order_id) as Total_Order from pizza_sales
group by  pizza_name_id
order by Total_Order desc
limit 5
/*Bottom 5 Pizzas by Total Orders*/
select pizza_name_id,count(distinct Order_id) as Total_Order from pizza_sales
group by  pizza_name_id
order by Total_Order asc
limit 5


   