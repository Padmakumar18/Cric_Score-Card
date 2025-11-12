@echo off
REM Cricket Scoreboard Backend Setup Script for Windows

echo 🏏 Cricket Scoreboard Backend Setup
echo ====================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python is not installed. Please install Python 3.11 or higher.
    exit /b 1
)

echo ✅ Python found
python --version
echo.

REM Create virtual environment
echo 📦 Creating virtual environment...
python -m venv venv

REM Activate virtual environment
echo 🔧 Activating virtual environment...
call venv\Scripts\activate.bat

REM Install dependencies
echo 📥 Installing dependencies...
python -m pip install --upgrade pip
pip install -r requirements.txt

REM Create .env file if it doesn't exist
if not exist .env (
    echo 📝 Creating .env file...
    copy .env.example .env
    echo ⚠️  Please edit .env file with your database credentials
)

REM Create uploads directory
echo 📁 Creating uploads directory...
if not exist uploads mkdir uploads

echo.
echo ✅ Setup complete!
echo.
echo 📋 Next steps:
echo 1. Edit .env file with your PostgreSQL credentials
echo 2. Create PostgreSQL database: createdb cricket_db
echo 3. Run migrations: alembic upgrade head
echo 4. Start server: uvicorn app.main:app --reload
echo.
echo 📚 Documentation:
echo - API Docs: http://localhost:8000/docs
echo - Health Check: http://localhost:8000/healthcheck
echo.
pause
