# train_final.py - NO SCALER, DIRECT TREE MODEL
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.metrics import mean_absolute_error, r2_score
import joblib
import os

print("🔥 FINAL RETRAIN - NO SCALER PROBLEMS!")

os.makedirs('models', exist_ok=True)

# Load data
df = pd.read_csv('final_dataset_ml.csv')
X = df[['pressure', 'temperature_C', 'humidity_percent']]
y = df['voltage_mV']  # ✅ CORRECT COLUMN NAME

print(f"📊 Data: {X.shape}, Voltage_mV: {y.min():.1f}-{y.max():.1f}")

# Train/test split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# ✅ TREE MODEL - NO SCALER NEEDED!
model = GradientBoostingRegressor(
    n_estimators=300, 
    max_depth=8, 
    learning_rate=0.05,
    random_state=42
)

print("🤖 Training...")
model.fit(X_train, y_train)

# Test
y_pred = model.predict(X_test)
mae = mean_absolute_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)

print(f"✅ R²: {r2:.3f}, MAE: {mae:.1f}mV")

# TEST WEB APP INPUTS
test_inputs = pd.DataFrame({
    'pressure': [10, 20, 30, 35],
    'temperature_C': [25, 25, 25, 40],
    'humidity_percent': [60, 60, 60, 80]
})
test_preds = model.predict(test_inputs)
print("\n🎯 WEB APP TEST PREDICTIONS:")
for i, pred in enumerate(test_preds):
    print(f"P={test_inputs.iloc[i]['pressure']} → {pred:.1f}mV")

# Save
joblib.dump(model, 'models/best_voltage_model.pkl')
print("\n✅ SAVED: Tree model (NO scaler needed)!")
