# creating table start:

CREATE TABLE final_orders AS
SELECT 
    o.order_id,
    oi.product_id,
    p.product_category_name,
    o.order_purchase_timestamp,
    o.order_approved_at,
    pay.payment_type,
    pay.payment_value AS amount_paid,
    oi.shipping_charges,
    c.customer_state
FROM orders o
JOIN orderitems oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN payments pay ON o.order_id = pay.order_id
JOIN customers c ON o.customer_id = c.customer_id;

# creating table ends 

# data cleaning (null value deletion starts)
SET SQL_SAFE_UPDATES = 0;

DELETE FROM final_orders 
WHERE order_id IS NULL OR order_id = ' ' 
OR product_id IS NULL OR product_id = ' ' 
OR product_category_name IS NULL OR product_category_name = ' ' 
OR order_purchase_timestamp IS NULL OR order_purchase_timestamp = ' ' 
OR order_approved_at IS NULL OR order_approved_at = ' ' 
OR payment_type IS NULL OR payment_type = ' ' 
OR amount_paid IS NULL
 OR shipping_charges IS NULL 
OR customer_state IS NULL 
OR customer_state = ' '; 

SET SQL_SAFE_UPDATES = 1; 


# data cleaning (null value deletion ends)

# creating approval time column in the table
SET SQL_SAFE_UPDATES = 0;
UPDATE final_orders
SET approval_time_mins = TIMESTAMPDIFF(MINUTE,
    STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'),
    STR_TO_DATE(order_approved_at, '%Y-%m-%d %H:%i:%s'));
SET SQL_SAFE_UPDATES = 1;

#viewing if approval time column is created correctly
USE sales_project;
SELECT order_id, order_purchase_timestamp, order_approved_at, approval_time_mins
FROM final_orders
LIMIT 10;

#Revenue Analysis
#1. Total revenue generated:
SELECT ROUND(SUM(amount_paid),2) AS total_revenue_generated
FROM final_orders;

#2. Revenue per product category
SELECT product_category_name, ROUND(SUM(amount_paid), 2) AS revenue_per_category
FROM final_orders
GROUP BY product_category_name;

#3. Top 5 categories by revenue
SELECT product_category_name, ROUND(SUM(amount_paid), 2) AS revenue_per_category
FROM final_orders
GROUP BY product_category_name
ORDER BY revenue_per_category DESC
LIMIT 5;

#4. Revenue per customer state
SELECT customer_state, ROUND(SUM(amount_paid), 2) AS revenue_per_state 
FROM final_orders 
GROUP BY customer_state; 

#5. Average order value overall
select round(avg(amount_paid),2) as average_order_value
from final_orders;

#6. Which payment type is most used
SELECT payment_type, COUNT(payment_type) AS total_usage
FROM final_orders
GROUP BY payment_type
ORDER BY total_usage DESC
LIMIT 1;

#7. Average order value per payment type
SELECT AVG(amount_paid) as avg_order_value , payment_type
FROM final_orders
GROUP BY payment_type;

#8.Revenue split by payment type
SELECT payment_type, SUM(amount_paid) as total_amount
FROM final_orders
GROUP BY payment_type;

#9. First 5 States where credit card usage is highest
SELECT customer_state
FROM final_orders
GROUP BY customer_state
ORDER BY SUM(amount_paid) desc
LIMIT 5;


#10. Average approval time overall
SELECT AVG(approval_time_mins) as avg_approval_time
FROM final_orders;

#11. Top 5 Categories with highest average approval time
SELECT product_category_name, ROUND(AVG(approval_time_mins),2)
FROM final_orders
GROUP BY product_category_name
ORDER BY AVG(approval_time_mins) DESC
LIMIT 5;

#12. Orders where approval time is above average
SELECT COUNT(order_id) AS late_orders_count
FROM final_orders
WHERE approval_time_mins > (
    SELECT AVG(approval_time_mins)
    FROM final_orders);
    
#13. Top 5 States with slowest approval times
SELECT customer_state, round(AVG(approval_time_mins),2) AS avg_approval_time
FROM final_orders
GROUP BY customer_state
ORDER BY AVG(approval_time_mins) desc
LIMIT 5;

#14. Orders being placed per month in 2017
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month, COUNT(order_id) AS no_of_orders
FROM final_orders
WHERE order_purchase_timestamp LIKE '2017%'
GROUP BY month
ORDER BY month ASC;

#15. Average shipping charges per category
SELECT product_category_name, ROUND(AVG(shipping_charges),2) AS avg_shipping_charges
FROM final_orders
GROUP BY product_category_name
ORDER BY AVG(shipping_charges) DESC;

#16. Shipping cost as % of amount paid per category
SELECT product_category_name, ROUND(SUM(shipping_charges) * 100 / SUM(amount_paid), 2) AS shipping_percentage
FROM final_orders
GROUP BY product_category_name
ORDER BY shipping_percentage DESC;

#17. Orders where shipping cost is more than amount paid
SELECT order_id as orders, shipping_charges, amount_paid
FROM final_orders
WHERE shipping_charges > amount_paid;

#18. Count of orders where shipping cost is more than amount paid
SELECT COUNT(order_id) AS orders_with_high_shipping
FROM final_orders
WHERE shipping_charges > amount_paid;