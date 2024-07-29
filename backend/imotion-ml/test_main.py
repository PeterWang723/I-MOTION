import random
from datetime import datetime, timedelta
from typing import List, Dict, Any

import pytest
from fastapi.testclient import TestClient
from main import app
from models import Pred_Data, Acc_Item


@pytest.fixture
def client():
    with TestClient(app) as c:
        yield c


@pytest.fixture
def pred_data_list() -> List[Dict[str, Any]]:
    return generate_pred_data(3, 100)


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


def test_predict_acc_success(client, pred_data_list):
    response = client.post(
        "/predict_acc/",
        json=pred_data_list,
        headers={"username": "12345"}
    )
    assert response.status_code == 200
    assert response.json() == {"message": "machine_learning model is predicting now"}


def test_predict_acc_missing_username(client, pred_data_list):
    response = client.post(
        "/predict_acc/",
        json=pred_data_list
    )
    assert response.status_code == 400
    assert response.json() == {"detail": "Username header is missing"}


def test_predict_acc_no_data(client, pred_data_list):
    response = client.post(
        "/predict_acc/",
        headers={"username": "12345"},
        json=[]
    )
    assert response.status_code == 404
    assert response.json() == {"detail": "Items not found"}
