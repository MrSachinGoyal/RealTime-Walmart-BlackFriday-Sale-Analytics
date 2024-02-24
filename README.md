# Walmart Black Friday Insights: Real-Time Sales and Inventory Analytics

# Overview
This project focuses on building a robust real-time data warehousing solution tailored for analyzing sales data during Walmart's Black Friday event. The primary objective is to ingest, process, and visualize real-time sales and inventory data. By doing so, the solution empowers data-driven decision-making across various aspects of retail operations, including inventory management, marketing strategies, and customer experience enhancement. The ultimate goal is to leverage insights derived from this data to optimize sales performance, understand customer behavior patterns, and ensure efficient inventory management during one of the busiest shopping periods of the year.

# Technologies Used
This project leverages various technologies to implement a healthcare data processing pipeline:

- **Programming Languages**: Python, SQL
- **Data Warehousing**: Snowflake
- **Data Streaming**: Google Cloud Pub/Sub
- **Visualization**: Power BI

# Project Structure
- **Database Setup**: SQL commands are used to create a new database and schema in Snowflake. The database and schema are the foundational structures where tables and other objects will reside. Four tables are created: `dim_products` and `dim_stores` for preloaded dimensional data, and `fact_sales_trnx` and `fact_inventory_trnx` for storing streaming sales and inventory data, respectively.
- **Sales Data Producer (sales_data_producer.py)**: This Python script generates mock sales data and publishes it to a Google Cloud Pub/Sub topic. It creates simulated transactions with product IDs, sale timestamps, quantities, unit prices, and store IDs. The data is serialized into JSON format before being published.
 - **Inventory Data Producer (inventory_data_producer.py)**: Similar to the sales data producer, this script generates mock inventory data and publishes it to a Pub/Sub topic. It creates simulated inventory transactions with product IDs, timestamps, quantity changes, and store IDs.
- **Sales Data Consumer (sales_data_consumer.py)**: This Python script consumes messages from the Pub/Sub topic containing sales data, deserializes the JSON data, and inserts it into the `fact_sales_trnx` table in Snowflake. It establishes a connection to Snowflake using the Snowflake Connector for Python and executes SQL INSERT statements.
- **Inventory Data Consumer (inventory_data_consumer.py)**: Similar to the sales data consumer, this script consumes messages from the Pub/Sub topic containing inventory data, deserializes the JSON data, and inserts it into the `fact_inventory_trnx` table in Snowflake.
- **SQL Queries**: Business queries are crafted to derive key metrics and perform in-depth analysis on the data stored in Snowflake tables, enabling data-driven decision-making.
- **Visualization**: A dashboard using Power BI is developed to visualize key metrics and unearth various insights, providing stakeholders with intuitive and actionable information.

# Key Metrics Derived
- Hourly, daily, and weekly sales trends during Black Friday.
- Sales trends by geographic region or store location.
- Top-selling products and categories based on quantity sold and revenue generated.
- Real-time inventory monitoring to identify stockouts and products requiring replenishment.
- Sell-through rate for each product to evaluate inventory turnover.
- Total revenue generated segmented by product category, store, and overall for Walmart chain.
- Identification of high-revenue stores and regions.
- Ranking of stores by sales volume and revenue to identify top performers.

# Prerequisites
Before you begin with the setup, make sure you have the following:

- **Programming Language** : Python 3.1 or higher
- **Google Cloud Platform (GCP) Services**:
  - An active GCP account with the necessary permissions.
     - Google Cloud Pub/Sub: Access to Google Cloud Pub/Sub for setting up topics and subscriptions to handle real-time data streams.
- **Snowflake Database**: Access to Snowflake database for storing both preloaded dimensional data and streaming data.
- **Power BI**: Power BI Desktop to visualize key metrics and unearth various insights from the processed data.
