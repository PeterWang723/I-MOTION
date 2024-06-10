from fastapi import FastAPI, HTTPException, BackgroundTasks

import models, Prediction

app = FastAPI()


@app.on_event("startup")
async def event_startup():
    models.createTable()


@app.post("/predict_acc/", status_code=200)
async def predict_acc(pred_data: models.Pred_Data, background_tasks: BackgroundTasks):
    if pred_data.data is None:
        raise HTTPException(status_code=404, detail="Items not found")

    u_id = pred_data.uid
    features = [(item.x, item.y, item.z) for item in pred_data.data]
    times = [item.time for item in pred_data.data]

    background_tasks.add_task(Prediction.predict_user_data, u_id, features, times)

    return {"message": f"machine_learning model is predicting now"}


@app.post("/run/", status_code=200)
async def run(item: models.Infer_Data):
    infr_datas = [item]
    models.insertData(infr_datas)
    return {"message": f"get it"}
