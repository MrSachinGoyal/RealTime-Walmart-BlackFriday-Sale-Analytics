import random
import json
import time
from datetime import datetime
from google.cloud import pubsub_v1

# set up Pub/Sub Publisher client
publisher = pubsub_v1.PublisherClient()

# project and topic details
project_id = "your_project_id"
topic_name = "your-topic-name"
topic_path = publisher.topic_path(project_id, topic_name)

# Callback function to handle the publishing results.
def callback(future):
    try:
        # Get the message_id after publishing.
        message_id = future.result()
        print(f"Published message with ID: {message_id}")
    except Exception as e:
        print(f"Error publishing message: {e}")

# generate mock sales data
store_ids = [f'W00{i}' for i in range(0, 10)]

def random_datetime():
    year = 2024
    month = 1
    day = random.randint(1, 14)
    hour = random.randint(0, 23)
    minute = random.randint(0, 59)
    second = random.randint(0, 59)
    dt_object = datetime(year, month, day, hour, minute, second)
    return dt_object


def generate_mock_sales_data(transaction_id):
    if (transaction_id >= 0) and (transaction_id) < 10:
        transaction_id = f"T10" + str(transaction_id).zfill(2)
    else:
        transaction_id = f"T10" + str(transaction_id)

    product_id, unit_price = random.choice ([("P500", 299.99), ("P501", 199.99), ("P502", 49.99), ("P503", 129.99), ("P504", 79.99),
                                             ("P505", 19.99), ("P506", 39.99), ("P507", 499.99), ("P508", 89.99), ("P509", 159.99) ])
    
    sale_timestamp = random_datetime().strftime("%Y-%m-%d %H:%M:%S")
    quantity = random.randint(1, 5)
    store_id = random.choice(store_ids)

    return {
        "transaction_id": transaction_id,
        "product_id": product_id,
        "sale_timestamp": sale_timestamp,
        "quantity": quantity,
        "unit_price": unit_price,
        "store_id": store_id
    }

transaction_id = 1
while True:
    data = generate_mock_sales_data(transaction_id)
    serialized_json_data = json.dumps(data).encode('utf-8') # # Convert the data into a JSON-formatted string encode into bytes using UTF-8 encoding

    try:
        # publish the serialized JSON data to the topic
        future = publisher.publish(topic_path, serialized_json_data)
        # Add a callback to the future
        future.add_done_callback(callback)
        # Wait for the publishing process to complete.
        future.result()
    except Exception as e:
        print(f"Exception encountered: {e}")

    time.sleep(2)

    transaction_id += 1
    if transaction_id > 100:
        break
    






 