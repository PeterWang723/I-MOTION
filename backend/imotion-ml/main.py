from typing import List

from fastapi import FastAPI, HTTPException, BackgroundTasks, Request

import models
import prediction

app = FastAPI()


@app.on_event("startup")
async def event_startup():
    models.create_table()


@app.post("/predict_acc/", status_code=200)
async def predict_acc(pred_data: List[models.Pred_Data], background_tasks: BackgroundTasks, request: Request):
    # Check if the username header is present
    username = request.headers.get("username")
    if not username:
        raise HTTPException(status_code=400, detail="Username header is missing")

    if pred_data is None or len(pred_data) == 0:
        raise HTTPException(status_code=404, detail="Items not found")

    background_tasks.add_task(prediction.predict_modes, pred_data, int(username))

    return {"message": f"machine_learning model is predicting now"}