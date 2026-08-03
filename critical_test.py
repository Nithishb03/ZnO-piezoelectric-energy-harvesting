# test_features.py - Check ALL features matter
import pandas as pd
import joblib

model = joblib.load('models/best_voltage_model.pkl')

# Test ALL combinations (fixed pressure=20)
tests = [
    [20, 15, 40],  # Low temp/humidity
    [20, 25, 60],  # Base (should match your web app)
    [20, 35, 80],  # High temp/humidity
    [20, 25, 40],  # Low humidity only
    [20, 35, 60]   # High temp only
]

df = pd.DataFrame(tests, columns=['pressure', 'temperature_C', 'humidity_percent'])
preds = model.predict(df)

print("🔍 FEATURE IMPACT TEST:")
print("=" * 50)
for i, (row, pred) in enumerate(zip(df.values, preds)):
    print(f"P={row[0]}, T={row[1]}°C, H={row[2]}% → {pred:.1f}mV")
print("=" * 50)
