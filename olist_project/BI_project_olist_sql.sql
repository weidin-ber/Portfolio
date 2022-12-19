#Marketing funnel leads
#MKT_SALES_.csv
use olist;
select mql_id, origin, business_segment, lead_type, lead_behaviour_profile, business_type, won_date from marketing_qualified_leads
join closed_deals using (mql_id);

#customer-table
#orders_count_amount_.csv

SELECT * FROM olist.customers;
select orders.customer_id, count(orders.order_id) as num_orders from orders
join customers using (customer_id)
group by orders.customer_id
having num_orders > 0;

# create a table that brings together order_id, payment_type and sums the payment_value per order_id from table order_payments 
# and the purchase timestamp from orders table and the review score from order_reviews table
# output CSV: "order_payments_sum_review"

SELECT order_payments.order_id, payment_type, sum(payment_value), orders.order_purchase_timestamp, order_reviews.review_score FROM order_payments 
INNER JOIN orders using (order_id)
INNER JOIN order_reviews using (order_id)
group by order_id
limit 200000;

# select everything from order_status_year_price to get the product category per order_id
# output CSV: "order_product_category"

select * from order_status_year_price
group by order_id
limit 200000;

# Step 1: create a temp table to later group by seller_id

CREATE TEMPORARY TABLE sellers_orders
select sellers.*, order_items.order_id, order_payments.payment_value from sellers
join order_items using (seller_id)
join order_payments using (order_id)
limit 200000;

# Step 2: use the temp table to count the number of order per seller_id
# output CSV: "sellers"

select seller_id, seller_zip_code_prefix, seller_city, seller_state, count(order_id) as num_orders, sum(payment_value) as sum_sales from sellers_orders
group by seller_id
limit 100000;

# Step 1: create a temp table to later group by customer_id

CREATE TEMPORARY TABLE customers_orders
select customers.*, orders.order_id, order_payments.payment_value from customers
join orders using (customer_id)
join order_payments using (order_id)
limit 200000;

# use the temp table to count the number of order per customer_id
# output CSV: "customers"

select customer_id, customer_zip_code_prefix, customer_city, customer_state, count(order_id) as num_orders, sum(payment_value) as sum_sales from customers_orders
group by customer_id
limit 1000000;
