# AceInterview - AI-Driven Interview Preparation System

AceInterview is a comprehensive, multimodal AI system designed to help candidates prepare for interviews. It analyzes video interviews to provide actionable feedback on **verbal communication**, **emotional expression**, and **body posture**.

The system is built on a microservices architecture, separating concerns into three distinct components: a frontend client, an interview analysis backend, and a posture analysis backend.

---

## 🏗️ System Architecture

The project follows a decoupled **Microservices Architecture**:

1.  **Frontend Client (`src/client`)**: A React-based Single Page Application (SPA) where users record/upload videos and view results.
2.  **Interview Analysis Service (`src/interview-analysis-service`)**: A Python Flask service responsible for speech-to-text, prosody analysis, facial emotion recognition, and personality trait prediction.
3.  **Posture Analysis Service (`src/posture-analysis-service`)**: A Python Flask service responsible for analyzing body language and posture using computer vision.

---

## 🔍 Deep Dive: Services & Models

### 1. Interview Analysis Service (Port 4000)
This service performs comprehensive behavioral analysis using multiple models and libraries.

#### **Core Workflow**
1.  **Input**: Receives a `video` file via API.
2.  **Transcription**: Uses **AssemblyAI** API to convert speech to text with high accuracy.
3.  **Feature Extraction**:
    *   **Lexical (Text) Analysis**: Uses **NLTK (Natural Language Toolkit)** to tokenize words and match them against a custom LIWC-like dictionary (Linguistic Inquiry and Word Count). It detects categories like *Positive Emotion*, *Cognitive Words*, *Filler Words* (Ah, Um), and *Tentative Language*.
    *   **Prosodic (Audio) Analysis**: Uses **Parselmouth (Praat)** to extract acoustic features such as:
        *   **Pitch (F0)**: Mean, standard deviation.
        *   **Jitter**: Micro-fluctuations in pitch (voice stability).
        *   **Shimmer**: Micro-fluctuations in amplitude (voice quality).
        *   **Formants**: Resonance frequencies of the vocal tract.
    *   **Visual (Emotion) Analysis**: Uses the **FER (Facial Expression Recognition)** library to detect 7 basic emotions (angry, disgust, fear, happy, sad, surprise, neutral) from video frames.
4.  **Prediction**: Features are aggregated and passed into a **Custom Machine Learning Model** (`model_custom.pkl`) to predict personality traits based on the **Big Five (OCEAN)** model:
    *   Openness
    *   Conscientiousness
    *   Extraversion
    *   Agreeableness
    *   Neuroticism
5.  **Scoring**: Results are compared against a baseline dataset (`medians.csv`) to provide relative scores.

#### **Key Models & Libraries**
*   **Speech-to-Text**: AssemblyAI
*   **NLP**: NLTK, PorterStemmer
*   **Audio Processing**: Praat (Parselmouth), Librosa
*   **Vision**: FER (using MTCNN/OpenCV under the hood)
*   **ML Classifier**: Custom Pickle Model (Scikit-Learn based)

---

### 2. Posture Analysis Service (Port 5000)
This service focuses purely on non-verbal body language cues.

#### **Core Workflow**
1.  **Input**: Receives a `video` file.
2.  **Frame Processing**: Uses **OpenCV** to read the video frame-by-frame.
3.  **Pose Detection**: Uses **Google MediaPipe Pose**, a state-of-the-art ML solution for high-fidelity body pose tracking. It extracts 33 3D landmarks on the whole body.
4.  **Geometric Analysis**: Calculates vector angles between key body parts:
    *   **Shoulder Alignment**: Angle between left and right shoulders (checking for slouching/leaning).
    *   **Arm Openness**: Angles at the elbows and armpits to detect "closed" or "defensive" postures.
    *   **Hand Gestures**: Tracking wrist movement relative to elbows.
5.  **Rule-Based Feedback**: Angles are compared against ergonomic thresholds.
    *   *Example*: If shoulder tilt > 16 degrees, flag as "Poor Alignment".
    *   *Example*: If elbow angles remain static, suggest "More Hand Gestures".

#### **Key Models & Libraries**
*   **Pose Estimation**: MediaPipe Solutions
*   **Video Processing**: OpenCV (cv2)

---

### 3. Frontend Client (Port 5173)
The user interface that ties everything together.

#### **Tech Stack**
*   **Framework**: React 19
*   **Build Tool**: Vite (fast, modern bundler)
*   **Routing**: React Router v7
*   **Runtime**: Bun (super fast JavaScript runtime)
*   **Tailwind CSS**: For styling

#### **User Flow**
1.  **Home Page**: User selects analysis type (Interview or Posture).
2.  **Upload/Record**: User uploads a video file.
3.  **Async Processing**: Client polls the backend task status APIs until analysis is complete.
4.  **Result Interface**:
    *   **Interview Page**: Displays transcript, personality radar chart, and specific tips.
    *   **Posture Page**: Shows visual feedback on body alignment with pass/fail indicators.

---

## 🛠️ Setup & Installation

### Prerequisites
*   **OS**: Windows, macOS, or Linux
*   **Python 3.9+** (via Conda recommended)
*   **Node.js or Bun**
*   **AssemblyAI API Key** (Free tier available)

### Step 1: Install Dependencies

**1. Interview Analysis Service**
```bash
cd src/interview-analysis-service
conda env create -f environment.yml
```

**2. Posture Analysis Service**
```bash
cd src/posture-analysis-service
conda env create -f environment.yml
```

**3. Client**
```bash
cd src/client
bun install
```

### Step 2: Configuration (.env)

**Interview Service** (`src/interview-analysis-service/.env`):
```ini
ASSEMBLYAI_API_KEY=your_key_here
FLASK_DEBUG=1
```

**Posture Service** (`src/posture-analysis-service/.env`):
```ini
FLASK_DEBUG=1
```

**Client** (`src/client/.env`):
```ini
VITE_INTERVIEW_ANALYSIS_MICROSVC_BASE_URL=http://localhost:4000
VITE_POSTURE_ANALYSIS_MICROSVC_BASE_URL=http://localhost:5000
```

---

## 🚀 Running the Project

You need to run all three services simultaneously in separate terminals.

**Terminal 1: Interview Backend**
```bash
cd src/interview-analysis-service
conda run -n interview-analysis-env python -u app.py
```

**Terminal 2: Posture Backend**
```bash
cd src/posture-analysis-service
conda run -n posture-analysis-env python -u app.py
```

**Terminal 3: Frontend**
```bash
cd src/client
bun run dev
```

Visit the app at **http://localhost:5173**

---

## 📂 Project Structure

```
aceinterview/
├── src/
│   ├── client/                          # React Frontend
│   │   ├── app/
│   │   │   ├── routes/                  # Pages (Home, Analysis, About)
│   │   │   ├── components/              # UI Components (Navbar, Charts)
│   │   │   ├── backend/                 # API Clients (Axios setup)
│   │
│   ├── interview-analysis-service/      # Python Backend 1
│   │   ├── api/routes.py                # Flask Endpoints
│   │   ├── services/
│   │   │   └── prediction_service.py    # Main Logic Coordinator
│   │   ├── utils/
│   │   │   ├── emotion.py               # FER Logic
│   │   │   ├── lexical_extraction.py    # NLP Logic
│   │   │   └── praat_extraction.py      # Audio Logic
│   │   ├── models/                      # .pkl ML Models
│   │
│   ├── posture-analysis-service/        # Python Backend 2
│   │   ├── api/routes.py                # Flask Endpoints
│   │   ├── core/
│   │   │   ├── pose_detector.py         # MediaPipe Wrapper
│   │   │   └── video_processor.py       # Frame Loop
│   │   ├── services/analysis_service.py # Logic Coordinator
│   │   └── utils/angle_utils.py         # Geometry Math
```
