# debug_model.py - FIXED SYNTAX
import pandas as pd
import numpy as np
import joblib
import os

print("🔍 DIAGNOSING YOUR MODEL ISSUE...")

# Check dataset
print("\n📊 DATASET ANALYSIS:")
try:
    df = pd.read_csv('final_dataset_ml.csv')
    print(f"✅ Dataset loaded: {df.shape}")
    print("Columns:", df.columns.tolist())
    print("Voltage stats:", df.iloc[:,-1].describe())
    
    # Check feature ranges
    print("\n📈 FEATURE RANGES:")
    print(df[['pressure', 'temperature_C', 'humidity_percent']].describe())
except Exception as e:
    print(f"❌ Dataset error: {e}")

# Check model files
print("\n🤖 MODEL FILES:")
if os.path.exists('models/best_voltage_model.pkl'):
    try:
        model = joblib.load('models/best_voltage_model.pkl')
        print(f"✅ Model loaded: {type(model).__name__}")
        
        # Test different inputs
        test_inputs = [
            [10, 25, 60],
            [20, 25, 60], 
            [30, 25, 60],
            [35, 40, 80]
        ]
        
        print("\n🧪 PREDICTION TEST:")
        predictions = []
        for i, inp in enumerate(test_inputs):
            pred = model.predict([inp])[0]
            predictions.append(pred)
            print(f"Input {i+1}: {inp} → {pred:.2f}V")
            
            if i > 0 and abs(pred - predictions[0]) < 0.01:
                print("❌ SAME PREDICTION DETECTED - MODEL BROKEN!")
        
        # Check if all predictions are identical
        if len(set(predictions)) == 1:
            print("\n🚨 CRITICAL: MODEL PREDICTS SAME VALUE FOR ALL INPUTS!")
        else:
            print("\n✅ GOOD: Model gives different predictions!")
            
    except Exception as e:
        print(f"❌ Model loading failed: {e}")
else:
    print("❌ No model file found: models/best_voltage_model.pkl")

print("\n🎯 NEXT: Run train_fixed.py to fix!")
