import time

import torch
from enum import Enum

import models


class ModeOfTransport(Enum):
    STILL = 1
    WALK = 2
    RUN = 3
    BIKE = 4
    CAR = 5
    BUS = 6
    TRAIN = 7
    SUBWAY = 8


def predict_user_data(u_id, day, features, times):
    model = None
    continuous_results = []
    last_mode = None
    start_interval = None
    end_interval = None

    # Process each 10-second window
    for start in range(0, len(features) - 599, 100):  # Jump by 100 rows each iteration
        end = start + 600
        pred_end = start + 100
        if end > len(features):
            break
        window_features = features[start:end]
        if end == len(features) - 1:
            window_times = times[start:end]
        else:
            window_times = times[start:pred_end]

        # Convert features to tensor and predict
        window_features_tensor = torch.tensor(window_features, dtype=torch.float32)
        predicted_mode = model(window_features_tensor.unsqueeze(0))  # Model expects batch dimension
        predicted_mode = predicted_mode.argmax(dim=1).item()  # Assuming classification task

        if predicted_mode == last_mode and start_interval is not None:
            # Continue the interval
            end_interval = window_times[-1]
        else:
            # Save previous interval if it exists
            if start_interval is not None:
                mode_name = ""
                for mode in ModeOfTransport:
                    if mode.value == last_mode:
                        mode_name = mode.name

                continuous_results.append((start_interval, end_interval, mode_name))
            # Start new interval
            start_interval = window_times[0]
            end_interval = window_times[-1]
            last_mode = predicted_mode

    # Ensure the last interval is added
    if start_interval is not None:
        mode_name = ""
        for mode in ModeOfTransport:
            if mode.value == last_mode:
                mode_name = mode.name
        continuous_results.append((start_interval, end_interval, mode_name))

    infer_data_list = []

    for start_interval, end_interval, mode_name in continuous_results:
        infer_data = models.Infer_Data(
            u_id=u_id,
            day=day,
            mode=mode_name,
            start_time=start_interval,
            end_time=end_interval
        )
        infer_data_list.append(infer_data)

    models.insertData(infer_data_list)
