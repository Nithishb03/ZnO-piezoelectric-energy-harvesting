# ✅ FIXED Train-Test Split Code - Handles Missing File & NameError
import pandas as pd
import numpy as np
import os
from sklearn.model_selection import train_test_split

print("🔍 Step 1: Scanning ALL locations for your CSV file...")
print("Current directory:", os.getcwd())

# Step 1: Search for CSV file in current directory AND parent directories
possible_paths = [
    'final_dataset_ml.csv',
    'final_dataset_ml.csv', 
    '../final_dataset_ml.csv',  # parent directory
    './final_dataset_ml.csv'
]

df = None
for path in possible_paths:
    if os.path.exists(path):
        print(f"✅ FOUND file: {path}")
        df = pd.read_csv(path, header=None)
        break

# Step 2: If still not found, list ALL files to help you locate it
if df is None:
    print("\n📁 ALL FILES in current directory:")
    all_files = os.listdir('.')
    csv_files = [f for f in all_files if f.endswith('.csv')]
    print("CSV files found:", csv_files)
    
    # Search parent directory too
    parent = os.path.dirname(os.getcwd())
    if os.path.exists(parent):
        parent_files = os.listdir(parent)
        parent_csvs = [f for f in parent_files if f.endswith('.csv')]
        print("CSV files in parent directory:", parent_csvs)
    
    # MANUAL PATH - Update this line with your actual file path
    print("\n❌ CSV not auto-found. UPDATE THIS PATH:")
    manual_path = input("Enter full path to final_dataset_ml.csv: ").strip()
    if os.path.exists(manual_path):
        df = pd.read_csv(manual_path, header=None)
    else:
        print("❌ Still can't find file. Copy CSV to script folder first!")
        exit()

# Step 3: Now safely process data (df exists!)
if df is not None:
    print("✅ Dataset loaded!")
    df.columns = ['pressure', 'temperature_C', 'humidity_percent', 'voltage_mV']
    
    # Convert to numeric SAFELY
    numeric_cols = ['pressure', 'temperature_C', 'humidity_percent', 'voltage_mV']
    for col in numeric_cols:
        df[col] = pd.to_numeric(df[col], errors='coerce')
    
    # Remove any bad rows
    df = df.dropna()
    print(f"Clean dataset shape: {df.shape}")
    
    # Step 4: Train-Test Split
    X = df[['pressure', 'temperature_C', 'humidity_percent']]
    y = df['voltage_mV']
    
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42, shuffle=True
    )
    
    # Step 5: Save splits for next steps
    print("\n✅ SPLIT SUCCESSFUL!")
    print(f"Training: {X_train.shape}, Test: {X_test.shape}")
    
    # Save to files for model training
    X_train.to_csv('X_train.csv', index=False)
    X_test.to_csv('X_test.csv', index=False)
    y_train.to_csv('y_train.csv', index=False)
    y_test.to_csv('y_test.csv', index=False)
    print("💾 Files saved: X_train.csv, X_test.csv, y_train.csv, y_test.csv")
    
    print("\nFirst 5 samples:")
    print("X_train:\n", X_train.head())
