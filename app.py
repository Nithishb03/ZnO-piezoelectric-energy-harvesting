from fastapi import FastAPI, HTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
import joblib
import pandas as pd
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
import time
from typing import List

app = FastAPI(title="⚡ Voltage Predictor Pro")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])
app.mount("/static", StaticFiles(directory="static"), name="static")

# Load ONLY model (no scaler!)
model = None
try:
    model = joblib.load('models/best_voltage_model.pkl')
    print(f"✅ Tree model loaded: {type(model).__name__}")
except Exception as e:
    print(f"❌ Model error: {e}")

# 🔥 PLATE VOLTAGE CALCULATOR
BASE_VOLTAGE_MV_6PLATES = 114.0  # Your experimental max for 6 plates

# 🔥 HISTORY STORAGE
history: List[dict] = []

# 🔥 PYDANTIC MODELS
class PredictionInput(BaseModel):
    pressure: float
    temperature_C: float
    humidity_percent: float

class PlateInput(BaseModel):  # 🔥 FIXED: NEW Pydantic model!
    plates: int

@app.post("/predict")
async def predict_voltage(data: PredictionInput):
    if model is None:
        raise HTTPException(status_code=500, detail="Model not loaded")
    
    try:
        # ✅ DataFrame with EXACT column names from your dataset
        input_df = pd.DataFrame([{
            'pressure': data.pressure,
            'temperature_C': data.temperature_C,
            'humidity_percent': data.humidity_percent
        }])
        
        # DETAILED LOGGING
        print(f"🔍 INPUT -> P={data.pressure:.1f}, T={data.temperature_C:.1f}°C, H={data.humidity_percent:.1f}%")
        print(f"🔍 DataFrame:\n{input_df}")
        
        # Direct prediction - NO scaler!
        prediction = model.predict(input_df)[0]
        voltage_mv = round(prediction, 1)
        
        print(f"✅ OUTPUT: {voltage_mv}mV")
        print("-" * 50)
        
        # 🔥 HISTORY STORAGE
        history.append({
            "timestamp": len(history) + 1,
            "pressure": data.pressure,
            "temperature_C": data.temperature_C,
            "humidity_percent": data.humidity_percent,
            "voltage_mV": voltage_mv,
            "time": time.strftime("%H:%M:%S")
        })
        # Keep only last 20 predictions
        if len(history) > 20:
            history[:] = history[-20:]
        
        return {
            "status": "success",
            "voltage_mV": voltage_mv,
            "inputs": {
                "pressure": data.pressure,
                "temperature_C": data.temperature_C,
                "humidity_percent": data.humidity_percent
            },
            "history": history
        }
    except Exception as e:
        print(f"❌ ERROR: {e}")
        raise HTTPException(status_code=500, detail=str(e))

# 🔥 FIXED PLATE ENDPOINT - NOW WORKS!
@app.post("/plate-voltage")
async def calculate_plate_voltage(data: PlateInput):  # ← FIXED: Use PlateInput!
    """Calculate max voltage for X plates (linear scaling from 6-plate baseline)"""
    voltage_mv = BASE_VOLTAGE_MV_6PLATES * (data.plates / 6.0)  # ← FIXED: data.plates
    print(f"📊 PLATE CALC: {data.plates} plates → {voltage_mv:.1f}mV (x{data.plates/6:.1f})")
    return {
        "plates": data.plates,
        "voltage_mV": round(voltage_mv, 1),
        "voltage_V": round(voltage_mv / 1000, 3),
        "multiplier": round(data.plates / 6.0, 2)
    }

@app.get("/history")
async def get_history():
    return {"history": history}

@app.get("/", response_class=HTMLResponse)
async def read_root():
    try:
        with open("templates/index.html", "r", encoding="utf-8") as f:
            return HTMLResponse(content=f.read())
    except FileNotFoundError:
        return HTMLResponse(content="❌ templates/index.html missing! Create the file.")

@app.get("/health")
async def health_check():
    return {
        "status": "healthy", 
        "model_loaded": model is not None,
        "model_type": type(model).__name__ if model else None,
        "history_count": len(history),
        "plate_baseline": BASE_VOLTAGE_MV_6PLATES
    }

if __name__ == "__main__":
    uvicorn.run("app:app", host="0.0.0.0", port=8501, reload=True, log_level="info")
