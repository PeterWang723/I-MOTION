from datetime import datetime, timedelta
import random
from typing import List, Tuple

import models


def create_time_range(start, delta_minutes):
    start_time = datetime.strptime(start, "%Y-%m-%d %H:%M")
    end_time = start_time + timedelta(minutes=delta_minutes)
    return start_time, end_time


# Initialize the start time
current_time = datetime.strptime("2023-08-01 00:00", "%Y-%m-%d %H:%M")

# Modes to choose from
possible_modes = ["walk", "bike", "car", "bus", "train", "subway", "still", "bike"]

# Generate test data
all_acc_date = []
modes = []

# Initial mode
previous_mode = random.choice(possible_modes)
modes.append(previous_mode)
delta_minutes = 1
all_acc_date.append((current_time, current_time + timedelta(seconds=delta_minutes)))
current_time += timedelta(seconds=delta_minutes)

for _ in range(64799):  # We already have the first mode
    delta_minutes = 1  # Random duration between 5 and 60 minutes
    all_acc_date.append((current_time, current_time + timedelta(seconds=delta_minutes)))
    current_time += timedelta(seconds=delta_minutes)  # Move to the next start time

    # Increase the chance of choosing the same mode as the previous one
    if random.random() < 0.75:  # 70% chance to keep the same mode
        current_mode = previous_mode
    else:
        current_mode = random.choice(possible_modes)

    modes.append(current_mode)
    previous_mode = current_mode


def combine_continuous_modes(u_id: int, all_acc_date: List[Tuple[datetime, datetime]], modes: List[str],
                             MinTime: int = 30) -> List[models.Infer_Data]:
    if not all_acc_date or not modes or len(all_acc_date) != len(modes):
        raise ValueError("Dates and modes lists must be of the same length and non-empty")

    day = all_acc_date[0][0]

    # Step 1: Encode the initial transport mode sequence and time sequence
    sequences = [(modes[i], all_acc_date[i][0], all_acc_date[i][1], 1, 0) for i in range(len(modes))]

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


result = combine_continuous_modes(1, all_acc_date, modes)

print("combined result counts = ", result)
