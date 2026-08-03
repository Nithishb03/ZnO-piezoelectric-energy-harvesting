document.addEventListener('DOMContentLoaded', function() {
    // DOM Elements - ML Predictor
    const form = document.getElementById('predictForm');
    const resultsPanel = document.getElementById('resultsPanel');
    const voltageOutput = document.getElementById('voltageOutput');
    const inputEcho = document.getElementById('inputEcho');
    const historyCount = document.getElementById('historyCount');
    const loadingOverlay = document.getElementById('loadingOverlay');
    const buttonLoader = document.getElementById('buttonLoader');
    const predictButton = document.querySelector('.predict-button');
    
    // 🔥 PLATE CALCULATOR ELEMENTS
    const plateSlider = document.getElementById('plateSlider');
    const plateValue = document.getElementById('plateValue');
    const plateVoltageDisplay = document.getElementById('plateVoltageDisplay');
    const plateVoltageOutput = document.getElementById('plateVoltageOutput');
    
    // 🔥 CHART GLOBAL
    let historyChart = null;

    // 🔥 FIXED PLATE VOLTAGE CALCULATOR - CORRECT JSON FORMAT!
    if (plateSlider) {
        plateSlider.addEventListener('input', async function() {
            const plates = parseInt(this.value);
            plateValue.textContent = `${plates} plates`;
            
            try {
                // ✅ FIXED: Send {"plates": 10} not just "10"
                const response = await fetch('/plate-voltage', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({ plates: plates })  // ← FIXED HERE!
                });
                
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}`);
                }
                
                const result = await response.json();
                console.log(`📊 PLATE CALC: ${plates} plates → ${result.voltage_mV}mV`);
                
                // Update displays
                plateVoltageOutput.textContent = `${result.voltage_mV} mV`;
                if (plateVoltageDisplay) {
                    plateVoltageDisplay.textContent = `${result.voltage_mV} mV`;
                }
                
                // Animate voltage number
                plateVoltageOutput.style.animation = 'pulse 0.4s ease-out';
                setTimeout(() => {
                    plateVoltageOutput.style.animation = '';
                }, 400);
                
            } catch (error) {
                console.error('❌ Plate calc error:', error);
                plateVoltageOutput.textContent = `Error (${error.message.slice(0,15)}...)`;
            }
        });
    }

    // ML Predictor Form Submit (UNCHANGED)
    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        // Show loading states
        loadingOverlay.style.display = 'flex';
        resultsPanel.style.display = 'none';
        predictButton.disabled = true;
        buttonLoader.style.display = 'inline-block';
        predictButton.querySelector('.button-text').textContent = 'AI Predicting...';

        try {
            // Get input values
            const pressure = parseFloat(document.getElementById('pressure').value);
            const temperature = parseFloat(document.getElementById('temperature').value);
            const humidity = parseFloat(document.getElementById('humidity').value);

            console.log(`🔍 Predicting: P=${pressure}, T=${temperature}°C, H=${humidity}%`);

            // API call
            const response = await fetch('/predict', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    pressure: pressure,
                    temperature_C: temperature,
                    humidity_percent: humidity
                })
            });

            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }

            const result = await response.json();
            console.log('✅ API Response:', result);

            // Animate result reveal
            setTimeout(() => {
                // Update voltage display
                voltageOutput.textContent = `${result.voltage_mV} mV`;
                
                // Update input echo
                inputEcho.innerHTML = `
                    <div><i class="fas fa-compress-arrows-alt"></i> ${result.inputs.pressure}</div>
                    <div><i class="fas fa-thermometer-half"></i> ${result.inputs.temperature_C}°C</div>
                    <div><i class="fas fa-tint-drop"></i> ${result.inputs.humidity_percent}%</div>
                `;
                
                // 🔥 UPDATE HISTORY COUNT
                if (historyCount) {
                    historyCount.textContent = result.history.length;
                }
                
                // 🔥 UPDATE LIVE CHART
                if (result.history && result.history.length > 0) {
                    updateHistoryChart(result.history);
                }
                
                // Show results with smooth scroll
                resultsPanel.style.display = 'block';
                resultsPanel.scrollIntoView({ behavior: 'smooth' });
                
                // Animate voltage number
                voltageOutput.style.animation = 'pulse 0.6s ease-out';
                setTimeout(() => {
                    voltageOutput.style.animation = '';
                }, 600);
                
            }, 800);

        } catch (error) {
            console.error('❌ Prediction error:', error);
            alert(`Prediction failed!\n\nError: ${error.message}\n\nCheck console (F12) for details.`);
        } finally {
            // Reset UI
            loadingOverlay.style.display = 'none';
            predictButton.disabled = false;
            buttonLoader.style.display = 'none';
            predictButton.querySelector('.button-text').textContent = 'Predict Voltage';
        }
    });

    // 🔥 LIVE HISTORY CHART FUNCTION (UNCHANGED)
    function updateHistoryChart(historyData) {
        const canvas = document.getElementById('historyChart');
        if (!canvas) {
            console.log('📊 Chart canvas not found');
            return;
        }
        
        const ctx = canvas.getContext('2d');
        
        // Destroy existing chart
        if (historyChart) {
            historyChart.destroy();
        }
        
        // Prepare data
        const labels = historyData.map((h, i) => `#${i+1} (P${h.pressure})`);
        const voltages = historyData.map(h => h.voltage_mV);
        
        console.log('📊 Chart data:', { labels: labels.slice(-5), voltages: voltages.slice(-5) });
        
        // Create new chart
        historyChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Voltage (mV)',
                    data: voltages,
                    borderColor: '#00d4ff',
                    backgroundColor: 'rgba(0, 212, 255, 0.15)',
                    tension: 0.4,
                    fill: true,
                    pointBackgroundColor: '#ff00d4',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    pointRadius: 6,
                    pointHoverRadius: 8,
                    pointHoverBorderWidth: 3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: {
                    intersect: false,
                    mode: 'index'
                },
                plugins: {
                    legend: {
                        labels: {
                            color: '#e2e8f0',
                            font: { size: 14, weight: '600' },
                            padding: 20
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(15, 15, 35, 0.95)',
                        titleColor: '#ffffff',
                        bodyColor: '#e2e8f0',
                        borderColor: '#00d4ff',
                        borderWidth: 1,
                        cornerRadius: 12,
                        displayColors: false,
                        callbacks: {
                            title: function(context) {
                                return `Prediction #${context[0].dataIndex + 1}`;
                            },
                            label: function(context) {
                                return `P${historyData[context.dataIndex].pressure}: ${context.parsed.y} mV`;
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { 
                            color: 'rgba(255, 255, 255, 0.1)',
                            drawBorder: false
                        },
                        ticks: { 
                            color: '#a0a0ff',
                            font: { size: 12 }
                        },
                        title: {
                            display: true,
                            text: 'Voltage (mV)',
                            color: '#60a5fa',
                            font: { size: 14, weight: '600' }
                        }
                    },
                    x: {
                        grid: { 
                            color: 'rgba(255, 255, 255, 0.05)',
                            drawBorder: false
                        },
                        ticks: { 
                            color: '#a0a0ff',
                            maxRotation: 45,
                            font: { size: 11 }
                        },
                        title: {
                            display: true,
                            text: 'Prediction # (Pressure)',
                            color: '#60a5fa',
                            font: { size: 14, weight: '600' }
                        }
                    }
                },
                animation: {
                    duration: 1200,
                    easing: 'easeOutQuart'
                },
                hover: {
                    animationDuration: 200
                }
            }
        });
        
        // Animate chart appearance
        canvas.style.opacity = '0';
        canvas.style.transform = 'translateY(20px)';
        setTimeout(() => {
            canvas.style.transition = 'all 0.6s ease-out';
            canvas.style.opacity = '1';
            canvas.style.transform = 'translateY(0)';
        }, 100);
    }

    // Real-time input validation (ML inputs only)
    ['pressure', 'temperature', 'humidity'].forEach(id => {
        const input = document.getElementById(id);
        if (input) {
            input.addEventListener('input', function() {
                const value = parseFloat(this.value) || 0;
                const min = parseFloat(this.min);
                const max = parseFloat(this.max);
                
                if (value < min || value > max || isNaN(value)) {
                    this.style.borderColor = '#ef4444';
                    this.style.boxShadow = '0 0 0 3px rgba(239, 68, 68, 0.3)';
                } else {
                    this.style.borderColor = '#00d4ff';
                    this.style.boxShadow = '0 0 0 3px rgba(0, 212, 255, 0.2)';
                }
            });
        }
    });

    // Page load message
    console.log('⚡ Voltage Predictor Pro + LIVE HISTORY CHARTS + PLATE SCALER FIXED!');
    console.log('✅ Plate slider: 6→50 plates → 114mV→950mV | ML predictions → Live charts');
});
