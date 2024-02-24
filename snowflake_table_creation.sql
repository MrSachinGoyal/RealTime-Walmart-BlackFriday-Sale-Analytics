-- create database
CREATE OR REPLACE DATABASE database_name;

-- create schema
CREATE OR REPLACE SCHEMA schema_name;

-- create tables 

-- preloaded dimension tables
CREATE OR REPLACE TABLE database_name.schema_name.dim_products (
    product_id VARCHAR(255),
    name VARCHAR(255),
    category VARCHAR(255),
    price DOUBLE,
    supplier_id VARCHAR(255)
);

CREATE OR REPLACE TABLE database_name.schema_name.dim_stores (
    store_id VARCHAR(255),
    location VARCHAR(255),
    size INTEGER,
    manager VARCHAR(255)
);

-- tables for loading streaming data
CREATE OR REPLACE TABLE database_name.schema_name.fact_sales_trnx (
    transaction_id VARCHAR(255),
    product_id VARCHAR(255),
    sale_timestamp TIMESTAMP_NTZ,
    quantity INTEGER,
    unit_price INTEGER,
    store_id VARCHAR(255)
);

CREATE OR REPLACE TABLE database_name.schema_name.fact_inventory_trnx (
    product_id VARCHAR(255),
    timestamp TIMESTAMP_NTZ,
    quantity_change INTEGER,
    store_id VARCHAR(255)
)

