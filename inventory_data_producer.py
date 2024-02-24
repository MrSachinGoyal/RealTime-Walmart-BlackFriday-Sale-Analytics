import random
import json
import time
from datetime import datetime
from google.cloud import pubsub_v1

# set up pub/sub publisher client
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
product_ids = [f'P50{i}'for i in range(0, 10)]
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

def generate_mock_inventory_data():
    product_id = random.choice(product_ids)
    timestamp = random_datetime().strftime("%Y-%m-%d %H:%M:%S")
    quantity_change = random.randint(-2, 5)
    store_id = random.choice(store_ids)

    return {
        "product_id": product_id,
        "timestamp": timestamp,
        "quantity_change": quantity_change,
        "store_id": store_id
    }

counter = 0
while True:
    data = generate_mock_inventory_data()
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

    counter += 1
    if counter > 120:
        break

    






 