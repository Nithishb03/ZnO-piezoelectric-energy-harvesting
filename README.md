# Piezoelectric Energy Prediction

[![Python](https://img.shields.io/badge/Python-3.11-blue.svg)](https://www.python.org/)
[![Flask](https://img.shields.io/badge/Flask-Web%20App-black.svg)](https://flask.palletsprojects.com/)
[![Machine Learning](https://img.shields.io/badge/ML-Gradient%20Boosting-green.svg)](https://scikit-learn.org/)
[![Research](https://img.shields.io/badge/Domain-Piezoelectric%20Energy%20Harvesting-orange.svg)]()
[![Status](https://img.shields.io/badge/Project-Active%20Research-brightgreen.svg)]()

A hybrid machine learning and DFT-based framework for piezoelectric energy harvesting using **ZnO** and **Fe-doped ZnO**.

This project presents an integrated scientific workflow that combines density functional theory (DFT), Gaussian simulation outputs, MATLAB-based post-processing, and machine learning for predicting piezoelectric voltage response. A Flask web application is provided for real-time inference and interactive visualization.

---

## Abstract

Piezoelectric nanomaterials have attracted significant attention for their ability to convert mechanical stress into electrical energy, enabling applications in self-powered sensors, energy harvesters, and intelligent electronic systems. Among such materials, zinc oxide (ZnO) and doped ZnO systems are especially promising due to their favorable structural, electronic, and piezoelectric properties.

This project proposes a hybrid framework for piezoelectric energy prediction that integrates simulation-derived descriptors with machine learning. The pipeline includes molecular and structural analysis, Gaussian/DFT-based feature extraction, MATLAB post-processing, and a trained Gradient Boosting regression model. The resulting system supports fast prediction of piezoelectric voltage and provides a practical platform for comparative analysis of ZnO and Fe-doped ZnO materials.

---

## Overview

The objective of this project is to estimate piezoelectric voltage behavior using a data-driven model trained on features obtained from scientific simulations and material descriptors. The workflow is designed to bridge the gap between computational materials science and practical prediction systems.

The application includes:
- scientific dataset preparation,
- hybrid model training,
- reusable preprocessing artifacts,
- and a web-based interface for demonstration and inference.

---

## Key Features

- Real-time voltage prediction.
- Gradient Boosting regression model.
- DFT-inspired feature engineering.
- Gaussian simulation data integration.
- MATLAB-based post-processing and figure generation.
- Flask web dashboard for interactive predictions.
- Modular scripts for dataset preparation and model training.
- Comparative analysis of ZnO and Fe-doped ZnO.
- Suitable for research, prototyping, and academic demonstration.

---

## Project Structure

```text
piezo_ml/
├── app.py
├── README.md
├── requirements.txt
├── run.bat
├── data/
│   └── processed/
├── figures/
├── matlab/
├── models/
├── MOlecules/
├── scripts/
├── static/
└── templates/
```

### Folder Guide

- `app.py` — Flask application entry point.
- `data/processed/` — Cleaned datasets and train/test splits.
- `figures/` — Generated plots and result visualizations.
- `matlab/` — MATLAB scripts for analysis and plotting.
- `models/` — Serialized model and scaler files.
- `MOlecules/` — Molecular structures and Gaussian simulation files.
- `scripts/` — Dataset update, feature engineering, and training scripts.
- `static/` — CSS and JavaScript files for the dashboard.
- `templates/` — HTML templates used by Flask.

---

## Methodology

The framework follows a hybrid scientific workflow:

1. **Simulation stage**  
   Molecular and structural data are generated through DFT/Gaussian-based simulations.

2. **Feature extraction stage**  
   Relevant descriptors are derived from atomic, electronic, and structural properties.

3. **Post-processing stage**  
   MATLAB scripts are used to analyze outputs and generate comparative plots.

4. **Machine learning stage**  
   A Gradient Boosting model is trained using the processed dataset.

5. **Deployment stage**  
   A Flask dashboard enables real-time prediction and user interaction.

This design supports both scientific interpretability and practical usability.

---

## Requirements

- Python 3.11
- `pip`
- Dependencies listed in `requirements.txt`

Install packages with:

```bash
pip install -r requirements.txt
```

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/Sanjay028055/ZnO-piezoelectric-energy-harvesting.git
cd ZnO-piezoelectric-energy-harvesting
```

### 2. Create a virtual environment

Windows:

```bash
python -m venv piezo_env
piezo_env\Scripts\activate
```

Linux/macOS:

```bash
python3 -m venv piezo_env
source piezo_env/bin/activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

---

## Usage

### Start the application

```bash
python app.py
```

Then open the local server address shown in the terminal, typically:

```text
http://127.0.0.1:5000
```

### Windows launcher

You can also run:

```bash
run.bat
```

---

## Model Details

The predictive engine is based on a machine learning regression pipeline using Gradient Boosting.

### Stored artifacts

- `models/best_voltage_model.pkl` — Trained model.
- `models/feature_scaler.pkl` — Feature scaler used during preprocessing.

### Model inputs

The model uses processed descriptors derived from:
- atomic properties,
- structural measurements,
- molecular features,
- simulation-based numerical values.

---

## Outputs

The system can generate:
- predicted voltage values,
- scientific comparison plots,
- material property visualizations,
- trained model artifacts,
- processed datasets for reproducibility.

---

## Screenshots

Add the following screenshots to the `figures/` folder and update the file names below.

### Dashboard Home
```md

```

### Prediction Page
```md

```

### Results Output
```md

```

### Scientific Plots
```md

```

---

## Future Scope

- Extend the model to additional piezoelectric materials.
- Incorporate feature importance and explainability analysis.
- Add more advanced ensemble or deep learning models.
- Deploy the dashboard to cloud infrastructure.
- Integrate IoT sensor data for real-time prediction.
- Generate automatic research summaries and reports.

---

## License

Add your preferred license before public release.

---

## Author

Developed for research in piezoelectric energy harvesting, ZnO-based materials, and machine learning-assisted material prediction.