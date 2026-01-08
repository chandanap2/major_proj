@echo off
echo Starting AI Mock Interview System...
echo.

start "Interview Analysis" cmd /k ^
"call %USERPROFILE%\anaconda3\Scripts\activate.bat interview-analysis-env && ^
cd /d %~dp0src\interview-analysis-service && ^
python -u app.py"

start "Posture Analysis" cmd /k ^
"call %USERPROFILE%\anaconda3\Scripts\activate.bat posture-analysis-env && ^
cd /d %~dp0src\posture-analysis-service && ^
python -u app.py"

start "Client" cmd /k ^
"cd /d %~dp0src\client && ^
bun run dev"

echo.
echo All services launched.
pause
