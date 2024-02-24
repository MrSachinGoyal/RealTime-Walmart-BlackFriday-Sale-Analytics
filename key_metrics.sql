-- Derive Key Metricsdatabase_name

-- Identify hourly, daily, and weekly sales trends during the Black Friday event. Highlight periods of peak sales activity.

SELECT 
    WEEK(sale_timestamp) AS week_of_sale,
    DATE(sale_timestamp) AS day_of_sale,
    HOUR(sale_timestamp) AS hour_of_sale, 
    SUM(quantity*unit_price) AS total_sales_per_hour
FROM 
    database_name.schema_name.fact_sales_trnx
GROUP BY 
    week_of_sale, 
    day_of_sale, 
    hour_of_sale 
ORDER BY 
    total_sales_per_hour DESC;

-- Analyze sales trends by geographic region or store location to understand regional preferences and demand patterns.

SELECT 
    store.location AS store_location,
    products.name AS products_name,
    SUM(sales.quantity * sales.unit_price) AS revenue
FROM 
    database_name.schema_name.fact_sales_trnx sales
INNER JOIN 
    database_name.schema_name.dim_stores store
ON 
    sales.store_id = store.store_id
INNER JOIN 
    database_name.schema_name.dim_products products
ON 
    sales.product_id = products.product_id
GROUP BY 
    store_location, products_name
ORDER BY 
    revenue DESC;

-- Determine the top-selling products and categories based on quantity sold and revenue generated. 
-- Highlight which products are exceeding sales expectations and which are underperforming.

SELECT
    products.category,
    products.name,
    SUM(sales.quantity) AS quantity_sold,
    SUM(sales.quantity*sales.unit_price) AS revenue
FROM 
    database_name.schema_name.fact_sales_trnx sales
INNER JOIN 
    database_name.schema_name.dim_products products
ON 
    sales.product_id = products.product_id
GROUP BY 
    products.category, products.name
ORDER BY 
    revenue DESC, 
    quantity_sold DESC;

-- Monitor real-time inventory levels and identify products that are at risk of stockouts. Provide alerts for items that require immediate replenishment to avoid lost sales.

SELECT 
    sales.store_id,
    sales.product_id,
    SUM(inventory.quantity_change) AS units_received,
    SUM(sales.quantity) AS units_sold,
    CASE WHEN (SUM(inventory.quantity_change) - SUM(sales.quantity)) > 0 THEN 'in_stock' ELSE 'OUT_OF_STOCK' END AS stock_status
FROM 
    database_name.schema_name.fact_sales_trnx sales
LEFT JOIN 
    database_name.schema_name.fact_inventory_trnx inventory
ON 
    (sales.store_id = inventory.store_id) AND (sales.product_id = inventory.product_id)
WHERE 
    inventory.quantity_change > 0
GROUP BY 
    sales.store_id, 
    sales.product_id;

-- Calculate the sell-through rate (the ratio of units sold to units received) for each product to evaluate inventory turnover and effectiveness in meeting customer demand.

SELECT 
    stores.location,
    products.name,
    (SUM(sales.quantity) / SUM(inventory.quantity_change)) AS sell_through_rate
FROM 
    database_name.schema_name.fact_sales_trnx sales
LEFT JOIN 
    database_name.schema_name.fact_inventory_trnx inventory
ON 
    (sales.store_id = inventory.store_id) AND (sales.product_id = inventory.product_id)
INNER JOIN 
    database_name.schema_name.dim_products products
ON 
    sales.product_id = products.product_id
INNER JOIN 
    database_name.schema_name.dim_stores stores
ON 
    sales.store_id = stores.store_id
WHERE 
    inventory.quantity_change > 0
GROUP BY 
    stores.location, 
    products.name;

-- Calculate total revenue generated in real-time, segmented by product category, store, and overall for the Walmart chain.

SELECT 
    stores.location,
    products.category,
    SUM(sales.quantity * sales.unit_price) AS total_revenue,
    SUM(SUM(sales.quantity * sales.unit_price)) OVER() AS walmart_total_revenue
FROM 
    database_name.schema_name.fact_sales_trnx sales
INNER JOIN 
    database_name.schema_name.dim_stores stores
ON 
    sales.store_id = stores.store_id
INNER JOIN 
    database_name.schema_name.dim_products products
ON 
    sales.product_id = products.product_id
GROUP BY
    stores.location,
    products.category;

-- Identify high-revenue stores and regions

SELECT 
    stores.location,
    stores.store_id,
    SUM(sales.quantity * sales.unit_price) AS revenue
FROM 
    database_name.schema_name.fact_sales_trnx sales
INNER JOIN 
    database_name.schema_name.dim_stores stores
ON 
    sales.store_id = stores.store_id
GROUP BY 
    stores.location,
    stores.store_id
ORDER BY 
    revenue DESC;

-- Rank stores by sales volume and revenue to identify top performers

SELECT 
    stores.location,
    SUM(sales.quantity) AS units_sold_per_store,
    SUM(sales.quantity * sales.unit_price) AS total_revenue_per_store,
    RANK() OVER(ORDER BY SUM(sales.quantity * sales.unit_price) DESC, SUM(sales.quantity)) AS rank
FROM 
    database_name.schema_name.fact_sales_trnx sales
INNER JOIN 
    database_name.schema_name.dim_stores stores
ON 
    sales.store_id = stores.store_id
GROUP BY
    stores.location
ORDER BY 
    total_revenue_per_store DESC,
    units_sold_per_store DESC;