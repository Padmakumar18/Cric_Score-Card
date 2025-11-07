"""
Cricket Scoreboard Backend API - Main Application Entry Point

This is the main FastAPI application that handles all API endpoints for the
Cricket Scoreboard Flutter app.

Features:
- User authentication (signup, login, guest mode)
- Match management with ball-by-ball tracking
- Tournament management with standings
- Player profiles with auto-calculated statistics
- File uploads for photos
- CORS support for Flutter web
- Rate limiting and security headers
"""

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import JSONResponse
import time
import os
from datetime import datetime

from app.config.settings import settings
from app.config.database import engine, Base

# Import routers (will be created in later tasks)
# from app.routers import auth, profiles, matches, tournaments, players, statistics

# Create uploads directory if it doesn't exist
os.makedirs(settings.UPLOAD_DIR, exist_ok=True)

# Create database tables
Base.metadata.create_all(bind=engine)

# Initialize FastAPI app
app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    description="Complete backend API for Cricket Scoreboard Flutter application",
    docs_url="/docs",
    redoc_url="/redoc",
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Request logging middleware


@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.time()

    response = await call_next(request)

    process_time = time.time() - start_time
    print(f"{datetime.now()} - {request.method} {request.url.path} - Status: {response.status_code} - Time: {process_time:.2f}s")

    return response

# Security headers middleware


@app.middleware("http")
async def add_security_headers(request: Request, call_next):
    response = await call_next(request)
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    return response

# Health check endpoint


@app.get("/healthcheck", tags=["Health"])
async def healthcheck():
    """
    Health check endpoint to verify API and database status.

    Returns:
        dict: Status information including database connection
    """
    try:
        # Test database connection
        from app.config.database import SessionLocal
        db = SessionLocal()
        db.execute("SELECT 1")
        db.close()
        db_status = "connected"
    except Exception as e:
        db_status = f"error: {str(e)}"

    return {
        "status": "healthy",
        "database": db_status,
        "timestamp": datetime.now().isoformat(),
        "version": settings.APP_VERSION
    }

# Root endpoint


@app.get("/", tags=["Root"])
async def root():
    """
    Root endpoint with API information.
    """
    return {
        "message": "Cricket Scoreboard API",
        "version": settings.APP_VERSION,
        "docs": "/docs",
        "redoc": "/redoc",
        "healthcheck": "/healthcheck"
    }

# Mount static files for uploads
app.mount("/uploads", StaticFiles(directory=settings.UPLOAD_DIR), name="uploads")

# Include routers (will be uncommented as they are created)
# app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])
# app.include_router(profiles.router, prefix="/api/profiles", tags=["Profiles"])
# app.include_router(matches.router, prefix="/api/matches", tags=["Matches"])
# app.include_router(tournaments.router, prefix="/api/tournaments", tags=["Tournaments"])
# app.include_router(players.router, prefix="/api/players", tags=["Players"])
# app.include_router(statistics.router, prefix="/api/statistics", tags=["Statistics"])

# Global exception handler


@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    return JSONResponse(
        status_code=500,
        content={
            "detail": "Internal server error",
            "error_code": "INTERNAL_ERROR",
            "timestamp": datetime.now().isoformat()
        }
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
