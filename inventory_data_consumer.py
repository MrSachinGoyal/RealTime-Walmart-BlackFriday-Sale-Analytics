import json
from google.cloud import pubsub_v1
import snowflake.connector

# set up Pub/Sub Subscriber client
subscriber = pubsub_v1.SubscriberClient()

# project and topic details
project_id = "your_project_id"
subscription_name = "your-default-subscription-name"
subscription_path = subscriber.subscription_path(project_id, subscription_name)

# Create Snowflake connection object
conn = snowflake.connector.connect(
    user='USER_NAME',
    password='PASSWORD',
    account='account_name',
    warehouse='warehouse_name',
    database='database_name',
    schema='schema_name'
)

# Create a cursor object
cur = conn.cursor()

# Prepare Snowflake Insert statement 
insert_stmt = ("""
    INSERT INTO fact_inventory_trnx (product_id, timestamp, quantity_change, store_id)
    VALUES (%s, %s, %s, %s)
""")

# pull and process messages
def pull_messages():
    while True:
        response = subscriber.pull(request={"subscription": subscription_path,  "max_messages": 10})
        ack_ids = []

        for received_message in response.received_messages:
            # Extract JSON data
            json_data = received_message.message.data.decode('utf-8')

            # Deseraialize the JSON data
            deserialized_data = json.loads(json_data)

            print(deserialized_data)

            # get data for Snowflake Insertion
            snowflake_data = (
                deserialized_data.get("product_id"),
                deserialized_data.get("timestamp"),
                deserialized_data.get("quantity_change"),
                deserialized_data.get("store_id"),
            )

            # Insert data into Snowflake table
            cur.execute(insert_stmt, snowflake_data)

            print("Data inserted in Snowflake !!!")

            # Collect ack ID for acknowledgment
            ack_ids.append(received_message.ack_id)

        # Acknowledge the messages so they won't be sent again
        if ack_ids:
            subscriber.acknowledge(request={"subscription": subscription_path, "ack_ids": ack_ids})

# Run the consumer
if __name__ == "__main__":
    try:
        pull_messages()
    except KeyboardInterrupt:
        pass
