/* 1. TOTAL ORDERS */

Select Count(*) as total_orders
From olist_orders;


/* 2. PRODUCT SALES */

Select sum(price) as product_sales
From olist_order_items;


/* 3. TOTAL FREIGHT */

Select sum(freight_value) as total_freight
From olist_order_items;


/* 4. AVERAGE ORDER VALUE (AOV) */

Select 
    sum(oi.price) / Count(distinct o.order_id) as average_order_value
From olist_order_items oi
join olist_orders o
    on oi.order_id = o.order_id;


/* 5. TOTAL CUSTOMERS */

Select Count(distinct customer_id) as total_customers
From olist_customers;


/* 6. TOTAL SELLERS */

Select Count(*) as total_sellers
From olist_sellers;


/* 7. TOTAL PRODUCTS */

Select Count(*) as total_products
From olist_products;


/* 8. DELIVERED ORDERS */

Select Count(*) as delivered_orders
From olist_orders
where order_status = 'delivered';


/* 9. CANCELLED ORDERS */

Select Count(*) as cancelled_orders
From olist_orders
where order_status = 'canceled';


/* 10. AVERAGE DELIVERY TIME */

Select 
    avg(
        Datediff(
            order_delivered_customer_date,
            order_purchase_timestamp
        )
    ) as avg_delivery_days
From olist_orders
where order_status = 'delivered';


/* 11. LATE DELIVERY ORDERS */

Select Count(*) as late_delivery_orders
From olist_orders
where order_status = 'delivered'
  and order_delivered_customer_date > order_estimated_delivery_date;


/* 12. LATE DELIVERY PERCENTAGE */

Select
    round(
        sum(
            case
                when order_delivered_customer_date > order_estimated_delivery_date
                then 1
                else 0
            end
        ) * 100.0 / Count(*),
        2
    ) as late_delivery_percentage
From olist_orders
where order_status = 'delivered';


/* 13. AVERAGE REVIEW SCORE */

Select 
    avg(review_score) as average_review_score
From olist_order_reviews;


/* 14. ORDERS BY PAYMENT TYPE */

Select 
    payment_type,
    Count(*) as payment_Count
From olist_order_payments
Group by payment_type;


/* 15. SALES BY PRODUCT CATEGORY */

Select 
    p.product_category_name,
    sum(oi.price) as total_sales
From olist_order_items oi
join olist_products p
    on oi.product_id = p.product_id
Group by p.product_category_name;


/* 16. ORDERS BY PRODUCT CATEGORY */

Select 
    p.product_category_name,
    Count(distinct oi.order_id) as total_orders
From olist_order_items oi
join olist_products p
    on oi.product_id = p.product_id
Group by p.product_category_name;


/* 17. SELLER SALES */

Select 
    s.seller_id,
    sum(oi.price) as total_sales
From olist_order_items oi
join olist_sellers s
    on oi.seller_id = s.seller_id
Group by s.seller_id;


/* 18. MONTHLY SALES */

Select 
    Year(o.order_purchase_timestamp) as Years,
    month(o.order_purchase_timestamp) as months,
    sum(oi.price) as total_sales
From olist_order_items oi
join olist_orders o
    on oi.order_id = o.order_id
Group by 
    Year(o.order_purchase_timestamp),
    month(o.order_purchase_timestamp)
Order by 
    Years,
    months;


/* 19. SALES BY CUSTOMER STATE */

Select 
    c.customer_state,
    sum(oi.price) as total_sales
From olist_order_items oi
join olist_orders o
    on oi.order_id = o.order_id
join olist_customers c
    on c.customer_id = o.customer_id
Group by c.customer_state;


/* 20. AVERAGE DELIVERY TIME BY CUSTOMER STATE */

Select 
    c.customer_state,
    avg(
        Datediff(
            o.order_delivered_customer_date,
            o.order_purchase_timestamp
        )
    ) as avg_delivery_days
From olist_customers c
join olist_orders o
    on c.customer_id = o.customer_id
where o.order_status = 'delivered'
Group by c.customer_state;


/* 21. TOP PRODUCT CATEGORIES BY SALES */

Select 
    p.product_category_name,
    sum(oi.price) as total_sales
From olist_order_items oi
join olist_products p
    on oi.product_id = p.product_id
Group by p.product_category_name
Order by total_sales desc;


/* 22. TOP SELLERS BY SALES */

Select 
    s.seller_id,
    sum(oi.price) as total_sales
From olist_sellers s
join olist_order_items oi
    on s.seller_id = oi.seller_id
Group by s.seller_id
Order by total_sales desc;


/* 23. DELIVERY STATUS ANALYSIS */

Select 
    Count(order_id) as total_orders,
    case 
        when order_delivered_customer_date > order_estimated_delivery_date 
            then 'Late'
        when order_delivered_customer_date = order_estimated_delivery_date 
            then 'on Time'
        else 'Early'
    end as delivery_status
From olist_orders
where order_status = 'delivered'
Group by delivery_status;

