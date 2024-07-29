import random
import sys
from datetime import datetime, timedelta
from typing import Any

import requests
import json

from models import Acc_Item, Pred_Data

# URL of the service
url = "http://34.142.112.23:8084/predict_acc/"

# Headers including a custom 'username'
headers = {
    "username": "1",  # Replace 'your_username' with the actual username
    "Content-Type": "application/json"
}


def generate_pred_data(num_entries: int, items_per_entry: int) -> list[dict[str, Any]]:
    pred_data_list = []
    base_time = datetime.now()

    for i in range(num_entries):
        # Create a list of Acc_Item instances
        acc_items = [Acc_Item(x=random.uniform(-10, 10),
                              y=random.uniform(-10, 10),
                              z=random.uniform(-10, 10)) for _ in range(items_per_entry)]

        # Create a Pred_Data instance with a time offset
        pred_data = Pred_Data(time=base_time + timedelta(minutes=i), data=acc_items)

        # Append the Pred_Data to the list
        pred_data_list.append(pred_data)

    pred_data_list = [item.dict() for item in pred_data_list]
    for item in pred_data_list:
        item['time'] = item['time'].isoformat() if 'time' in item and item['time'] else item['time']

    return pred_data_list


data = generate_pred_data(32400, 100)
print("size of data is:", sys.getsizeof(data) / (1024 * 1024), "MB")

response = requests.post(url, headers=headers, json=data)


if response.status_code == 200:
    print("Success:", response.json())
else:
    print("Failed with status code:", response.status_code)
    print("Response message:", response.json())
