CREATE DATABASE project;

USE project;

-- 1 Retrieve all customers from a specific State, City and Zipcode that contains 3,5,7.(Filtering using WHERE and using Wildcards)
SELECT 
*
FROM
    customer
WHERE
    customer_state = 'SP'
        AND customer_city = 'Santos'
        OR customer_zip_code LIKE '%3%\'%5%\'%7%';

 -- 2 List all delivered orders.(Aggregation using COUNT)
SELECT 
    COUNT(*) AS total_orders
FROM
    orders;

-- 2.1 List all delivered orders.(Filtering based on conditions)
SELECT 
    *
FROM
    orders
WHERE
    order_status = 'delivered';

-- 3 Find total revenue (price + shipping charges) for each order.(Aggregation, Group By & Order By)
SELECT 
    order_id, SUM(price + shipping_charges) AS total_revenue
FROM
    orders_items
GROUP BY order_id;

-- 4 Get the top 5 most expensive products.(Sorting with ORDER BY and limiting results.)
SELECT 
    *
FROM
    products
ORDER BY product_weight_g DESC
LIMIT 5;

-- 5 Identify orders with more than 2 items.(HAVING with grouped data)
SELECT 
    order_id, COUNT(order_item_id) AS item_count
FROM
    orders_items
GROUP BY order_id
HAVING COUNT(order_item_id) > 2;

-- 6 Join orders with customers to get customer details for each order.(Inner join.)
SELECT 
    o.order_id, c.customer_id, c.customer_city, c.customer_state
FROM
    orders o
        JOIN
    customer c ON o.customer_id = c.customer_id;

-- 7 Find the average price of all products in each category.(Aggregation with AVG and grouping)
SELECT 
    product_category_name, AVG(price) AS avg_price
FROM
    orders_items oi
        JOIN
    products p ON oi.product_id = p.product_id
GROUP BY product_category_name;

-- 8 Calculate the total shipping charges for each state.(Multi-table join with grouping)
SELECT 
    c.customer_state, SUM(oi.shipping_charges) AS total_shipping
FROM
    orders o
        JOIN
    customer c ON o.customer_id = c.customer_id
        JOIN
    orders_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_state;

-- 9 Find the product category with the most orders.(Join, aggregation, and limiting results)
SELECT 
    p.product_category_name,
    COUNT(oi.product_id) AS total_orders
FROM
    orders_items oi
        JOIN
    products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_orders DESC
LIMIT 1;

-- 10 List orders placed in the last 6 months.(Date filtering) -----
SELECT DATE_SUB(now(), INTERVAL -6 MONTH) as date_format FROM orders;
SELECT str_to_date(DATE_SUB(now(), INTERVAL -6 MONTH),'%Y-%m-%d') as date_format FROM orders;
select str_to_date(order_purchase_timestamp,'%m/%d/%Y') as past_6month from orders;
SELECT 
    *
FROM
    orders
WHERE
    order_purchase_timestamp >= str_to_date(DATE_SUB(now(), INTERVAL -6 MONTH),'%Y-%m-%d'); -- DATE_SUB(now(), INTERVAL 6 MONTH)
/* SELECT 
    *
FROM
    orders
WHERE
    order_purchase_timestamp >= DATEADD(month, - 6, GETDATE()); */

-- 11 Find customers who placed more than 1 order.(Grouping and filtering grouped results)
SELECT 
    c.customer_id,
    c.customer_city,
    COUNT(o.order_id) AS order_count
FROM
    customer c
        JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id , c.customer_city
HAVING COUNT(o.order_id) > 1;

-- 12 List all orders that include products in the "electronics" category.(Filtering with joins) 
SELECT DISTINCT
    o.order_status, COUNT(o.order_id) AS total_count
FROM
    orders o
        JOIN
    orders_items oi ON o.order_id = oi.order_id
        JOIN
    products p ON oi.product_id = p.product_id
WHERE
    p.product_category_name = 'electronics'
GROUP BY o.order_status;

-- 13 Find the state with the highest total revenue.(Aggregation with ranking)
SELECT 
    c.customer_state,
    SUM(oi.price + oi.shipping_charges) AS total_revenue
FROM
    customer c
        JOIN
    orders o ON c.customer_id = o.customer_id
        JOIN
    orders_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 1;

-- 14 Find Customers Who Placed the Most Orders.(Sub-Query)
SELECT 
    customer_id, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY customer_id
HAVING COUNT(order_id) = (SELECT 
        MAX(order_count)
    FROM
        (SELECT 
            customer_id, COUNT(order_id) AS order_count
        FROM
            orders
        GROUP BY customer_id) AS customer_order_counts);

-- 15 Find Orders That Contain the Most Expensive Product. 
SELECT DISTINCT
    order_id
FROM
    orders_items
WHERE
    product_id = (SELECT 
            product_id
        FROM
            products
        ORDER BY product_weight_g DESC
        LIMIT 1);

-- 16 Find the total category wise count of the products from the order items.(Using Case) 
SELECT 
    CASE
        WHEN price < 1000 THEN 'Cheap'
        WHEN price BETWEEN 1000 AND 3000 THEN 'Medium'
        ELSE 'Expensive'
    END AS Price_category,
    COUNT(price) AS Total_count
FROM
    orders_items
GROUP BY Price_category;



















