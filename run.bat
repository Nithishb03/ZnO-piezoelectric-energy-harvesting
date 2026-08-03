@echo off
echo Starting Voltage Predictor Pro...
pip install -r requirements.txt
mkdir models 2>nul
mkdir static 2>nul
mkdir templates 2>nul
echo.
echo ✅ Server starting at http://localhost:8501
echo ✅ API Docs: http://localhost:8501/docs
python app.py
pause
