import torch


def predict_user_data(user_id, features, times):
    model = None
    continuous_results = []
    last_mode = None
    start_interval = None
    end_interval = None

    # Process each 10-second window
    for start in range(0, len(features) - 599, 60):  # Jump by 60 rows each iteration
        end = start + 600
        pred_end = start + 60
        if end > len(features):
            break
        window_features = features[start:end]
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
                continuous_results.append((start_interval, end_interval, last_mode))
            # Start new interval
            start_interval = window_times[0]
            end_interval = window_times[-1]
            last_mode = predicted_mode

    # Ensure the last interval is added
    if start_interval is not None:
        continuous_results.append((start_interval, end_interval, last_mode))

    return continuous_results
