import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime
from typing import Dict, List, Tuple

from google.cloud import aiplatform
from google.protobuf import json_format
from google.protobuf.struct_pb2 import Value

import models
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def sort_and_combine(pred_data_list: [models.Pred_Data]):
    sorted_data = sorted(pred_data_list, key=lambda pd: pd.time)
    all_acc_date = []
    all_acc_items = []
    for pred_data in sorted_data:
        all_acc_date.append((pred_data.day, pred_data.time))
        all_acc_items.extend(pred_data.data)

    chunk_size = 300
    jump_size = 100
    acc_item_chunks = [all_acc_items[i:i + chunk_size] for i in
                       range(0, len(all_acc_items) - chunk_size + 1, jump_size)]
    return all_acc_date, acc_item_chunks


def combine_continuous_modes(u_id: int, all_acc_date: List[Tuple[datetime, datetime]], modes: List[str],
                             MinTime: int = 30) -> List[models.Infer_Data]:
    if not all_acc_date or not modes or len(all_acc_date) != len(modes):
        raise ValueError("Dates and modes lists must be of the same length and non-empty")

    day = all_acc_date[0][0]

    # Step 1: Encode the initial transport mode sequence and time sequence
    sequences = [(modes[i], all_acc_date[i][1], all_acc_date[i][1], 1, 0) for i in range(len(modes))]

    def merge_sequences(sequences):
        merged_sequences = []
        i = 0
        while i < len(sequences):
            current_mode = sequences[i][0]
            start_time = sequences[i][1]
            end_time = sequences[i][2]
            duration = sequences[i][3]
            while i + 1 < len(sequences) and sequences[i + 1][0] == current_mode:
                i += 1
                end_time = sequences[i][2]
                duration += sequences[i][3]

            # Step 3: Determine if sequence is core or normal
            if duration >= MinTime:
                merged_sequences.append((current_mode, start_time, end_time, duration, 1))
            else:
                merged_sequences.append((current_mode, start_time, end_time, duration, 0))
            i += 1
        return merged_sequences

    def process_sequences(sequences):
        finished = False
        while not finished:
            # Step 2: Merge each neighbour sequence
            sequences = merge_sequences(sequences)

            if all(seq[4] == 1 for seq in sequences) or all(seq[4] == 0 for seq in sequences):
                finished = True
            else:
                # Step 4: Modify normal sequences
                for i in range(len(sequences)):
                    if sequences[i][4] == 0:
                        left_core = right_core = None
                        if i > 0 and sequences[i - 1][4] == 1:
                            left_core = sequences[i - 1]
                        if i < len(sequences) - 1 and sequences[i + 1][4] == 1:
                            right_core = sequences[i + 1]
                        if i == 0 and sequences[i + 1][4] == 1:
                            right_core = sequences[i + 1]
                        if i == len(sequences) - 1 and sequences[i - 1][4] == 1:
                            left_core = sequences[i - 1]

                        if left_core and right_core:
                            if left_core[3] >= right_core[3]:
                                sequences[i] = (left_core[0], sequences[i][1], sequences[i][2], sequences[i][3], 0)
                            else:
                                sequences[i] = (right_core[0], sequences[i][1], sequences[i][2], sequences[i][3], 0)
                        elif left_core:
                            sequences[i] = (left_core[0], sequences[i][1], sequences[i][2], sequences[i][3], 0)
                        elif right_core:
                            sequences[i] = (right_core[0], sequences[i][1], sequences[i][2], sequences[i][3], 0)

        return sequences

    processed_sequences = process_sequences(sequences)

    # Step 6: Decode the final core label sequence
    results = []
    for seq in processed_sequences:
        results.append(models.Infer_Data(
            u_id=u_id,
            mode=seq[0],
            day=day,
            start_time=seq[1],
            end_time=seq[2]
        ))

    return results


def predict_modes(features: List[models.Pred_Data], u_id: int):
    all_acc_date, acc_item_chunks = sort_and_combine(features)
    modes = []
    for acc_item_chunk in acc_item_chunks:
        instances: List[Dict[str, str]] = []
        instance = generate_single_instance(acc_item_chunk)
        instances.append(instance)
        mode = predict_tabular_classification(instances=instances)
        modes.extend(mode)

    # modes = predict_tabular_classification(instances=instances)
    modes.append(modes[-1])
    modes.append(modes[-1])
    logger.info("Predicted modes: %s", len(modes))
    logger.info("all_acc_date: %s", len(all_acc_date))
    combined_results = combine_continuous_modes(u_id, all_acc_date, modes)
    logger.info("combined_results: %s", len(combined_results))
    models.insert_data(combined_results)
    logger.info("prediction is done")


def predict_tabular_classification(
        project: str = "1008426611303",
        endpoint_id: str = "4907731723229331456",
        location: str = "europe-west2",
        api_endpoint: str = "europe-west2-aiplatform.googleapis.com",
        instances: List[Dict[str, str]] = None
) -> List[str]:
    client_options = {"api_endpoint": api_endpoint}

    client = aiplatform.gapic.PredictionServiceClient(client_options=client_options)

    parameters_dict = {}
    parameters = json_format.ParseDict(parameters_dict, Value())
    endpoint = client.endpoint_path(
        project=project, location=location, endpoint=endpoint_id
    )

    # Process the predictions to find the best class for each
    result = []
    #batch_size = 50

    response = client.predict(
        endpoint=endpoint, instances=instances, parameters=parameters
    )

    predictions = response.predictions

    for prediction in predictions:
        scores = prediction["scores"]
        classes = prediction["classes"]
        best_index = scores.index(max(scores))
        result.append(classes[best_index])

    """for i in range(0, len(instances), batch_size):
        batch = instances[i:min(i + batch_size, len(instances))]
        response = client.predict(
            endpoint=endpoint, instances=batch, parameters=parameters
        )
        predictions = response.predictions

        for prediction in predictions:
            scores = prediction["scores"]
            classes = prediction["classes"]
            best_index = scores.index(max(scores))
            result.append(classes[best_index])"""

    return result


def generate_single_instance(instance: List[models.Acc_Item]) -> Dict[str, str]:
    result = {}
    for i, item in enumerate(instance):
        prefix = f"Acc_{i + 1}"
        result[f"{prefix}_x"] = str(item.x)
        result[f"{prefix}_y"] = str(item.y)
        result[f"{prefix}_z"] = str(item.z)
    return result
