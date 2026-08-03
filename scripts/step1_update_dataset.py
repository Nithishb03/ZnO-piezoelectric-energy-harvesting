import pandas as pd
import os

# -------------------------------
# Load original cleaned dataset
# -------------------------------
df = pd.read_csv("data/piezo_ml_cleaned.csv")

print("Original Columns:")
print(df.columns)

# -------------------------------
# Keep ONLY ML-relevant columns
# -------------------------------
ml_df = df[
    ["pressure", "temperature_C", "humidity_percent", "voltage_mV"]
]

print("\nUpdated ML Columns:")
print(ml_df.columns)

# -------------------------------
# Create output directory
# -------------------------------
output_dir = "data/processed"
os.makedirs(output_dir, exist_ok=True)

# -------------------------------
# Save final ML dataset
# -------------------------------
output_path = os.path.join(output_dir, "final_dataset_ml.csv")
ml_df.to_csv(output_path, index=False)

print("\n✅ STEP 1 COMPLETED SUCCESSFULLY")
print(f"Saved file: {output_path}")