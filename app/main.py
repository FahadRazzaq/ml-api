# app/main.py
from fastapi import FastAPI
import joblib
import numpy as np
from pydantic import BaseModel

# Load the model
model = joblib.load("model/iris_model.pkl")

app = FastAPI(title="Iris Classifier API")

# Request model
class IrisRequest(BaseModel):
    sepal_length: float
    sepal_width: float
    petal_length: float
    petal_width: float

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/predict")
def predict(request: IrisRequest):
    features = np.array([[request.sepal_length, request.sepal_width, request.petal_length, request.petal_width]])
    prediction = model.predict(features)
    return {"prediction": int(prediction[0])}