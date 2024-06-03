import numpy as np
import torch


def fetch_and_process_data(cursor):
    # Query to fetch data sorted by user_id and time
    cursor.execute("""
        SELECT id, user_id, value, time
        FROM accelerometer
        ORDER BY user_id, time ASC
    """)

    # Fetch all results
    rows = cursor.fetchall()

    # Convert to NumPy array from list of tuples
    data_array = np.array(rows, dtype=[('id', 'i4'), ('user_id', 'i4'), ('value', 'f4'), ('time', 'datetime64[ms]')])

    # Split data by user_id using a structured numpy array
    users_data = {}
    unique_user_ids = np.unique(data_array['user_id'])
    for user_id in unique_user_ids:
        user_data = data_array[data_array['user_id'] == user_id]

        users_data[user_id] = (user_data['value'], user_data['time'])

    return users_data