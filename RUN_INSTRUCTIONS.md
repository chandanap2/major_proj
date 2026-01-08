# AceInterview - Quick Start Commands

## 🛠️ First Time Setup

Run these commands once to install dependencies.

### Terminal 1: Interview Analysis Service
```powershell
cd src/interview-analysis-service
conda env create -f environment.yml
```

### Terminal 2: Posture Analysis Service
```powershell
cd src/posture-analysis-service
conda env create -f environment.yml
```

### Terminal 3: Client (Frontend)
```powershell
cd src/client
bun install
```

---

## 🚀 Starting the Application

Open 3 separate terminal windows and run these commands.

### Terminal 1: Interview Analysis Service (Port 4000)
```powershell
cd src/interview-analysis-service
conda run -n interview-analysis-env python -u app.py
```

### Terminal 2: Posture Analysis Service (Port 5000)
```powershell
cd src/posture-analysis-service
conda run -n posture-analysis-env python -u app.py
```

### Terminal 3: Client (Frontend) (Port 5173)
```powershell
cd src/client
bun run dev
```
