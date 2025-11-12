# 🚀 Quick Start Guide

## What's Been Built

Your Cricket Scoreboard Backend has a **solid foundation** with:

✅ **Complete Project Structure**
✅ **All Database Models** (9 tables)
✅ **Migration System** (Alembic)
✅ **Authentication Utilities** (JWT, bcrypt)
✅ **File Upload System**
✅ **Docker Configuration**
✅ **CORS & Security Middleware**
✅ **Health Check Endpoint**

## 🏃 Get Started in 5 Minutes

### Option 1: Local Setup

```bash
# 1. Navigate to backend
cd backend

# 2. Run setup script
# On Linux/Mac:
chmod +x setup.sh
./setup.sh

# On Windows:
setup.bat

# 3. Configure database
# Edit .env file with your PostgreSQL credentials

# 4. Create database
createdb cricket_db

# 5. Run migrations
alembic upgrade head

# 6. Start server
uvicorn app.main:app --reload
```

### Option 2: Docker (Easiest!)

```bash
cd backend

# Start everything (backend + PostgreSQL)
docker-compose up -d

# Run migrations
docker-compose exec backend alembic upgrade head

# View logs
docker-compose logs -f backend
```

## 🌐 Access Your API

Once running, visit:

- **API Root**: http://localhost:8000
- **Swagger Docs**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/healthcheck

## 📊 What's Working Now

### ✅ Currently Functional

1. **Server Running** - FastAPI app with CORS, logging, security headers
2. **Database Connection** - PostgreSQL with all tables created
3. **Health Check** - `/healthcheck` endpoint
4. **Static Files** - `/uploads` directory for file serving
5. **API Documentation** - Auto-generated Swagger UI

### 🚧 What Needs Implementation

The **business logic and API endpoints** need to be added:

1. **Authentication Endpoints** - Signup, login, guest mode
2. **Profile Management** - User profiles with stats
3. **Match Management** - Create matches, ball-by-ball tracking
4. **Tournament Management** - Tournaments with standings
5. **Player Profiles** - Player database
6. **Statistics Calculation** - Auto-update from matches

## 📁 Project Structure

```
backend/
├── app/
│   ├── main.py              ✅ FastAPI app (working)
│   ├── config/
│   │   ├── settings.py      ✅ Configuration (working)
│   │   └── database.py      ✅ DB connection (working)
│   ├── models/              ✅ All models created
│   │   ├── user.py
│   │   ├── match.py
│   │   ├── tournament.py
│   │   └── player.py
│   ├── schemas/             ⏳ Need more schemas
│   │   └── auth.py          ✅ Auth schemas done
│   ├── routers/             ⏳ Need to create
│   ├── services/            ⏳ Need to create
│   ├── utils/               ✅ All utilities done
│   │   ├── auth.py
│   │   ├── file_upload.py
│   │   └── exceptions.py
│   └── seeders/             ⏳ Need to create
├── alembic/                 ✅ Migrations ready
├── tests/                   ⏳ Need to create
├── requirements.txt         ✅ All dependencies listed
├── docker-compose.yml       ✅ Docker ready
└── README.md               ✅ Full documentation
```

## 🔧 Environment Variables

Your `.env` file should contain:

```env
# Database
DATABASE_URL=postgresql://cricket_user:cricket_password@localhost:5432/cricket_db

# JWT (CHANGE THIS!)
JWT_SECRET_KEY=your-super-secret-jwt-key-change-this-in-production-min-32-chars
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440

# CORS
CORS_ORIGINS=http://localhost:3000,http://localhost:8080,http://localhost:5000

# File Upload
UPLOAD_DIR=./uploads
MAX_FILE_SIZE=5242880

# App
DEBUG=True
```

## 🎯 Next Steps to Complete Backend

### Priority 1: Authentication (Most Important)

Create these files:

1. `app/services/auth_service.py` - User registration, login logic
2. `app/routers/auth.py` - Auth API endpoints

This will enable:

- User signup
- User login
- Guest mode
- JWT token generation

### Priority 2: Core Features

3. `app/services/match_service.py` + `app/routers/matches.py`
4. `app/services/profile_service.py` + `app/routers/profiles.py`
5. `app/schemas/match.py` + `app/schemas/profile.py`

### Priority 3: Advanced Features

6. Tournament management
7. Player profiles
8. Statistics calculation

## 📱 Connecting Flutter App

Once endpoints are implemented, connect from Flutter:

```dart
import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
  baseUrl: 'http://localhost:8000',
  connectTimeout: Duration(seconds: 5),
  receiveTimeout: Duration(seconds: 3),
));

// Signup
final response = await dio.post('/api/auth/signup', data: {
  'email': 'user@example.com',
  'password': 'password123',
  'name': 'John Doe',
});

// Save token
final token = response.data['access_token'];

// Use token for authenticated requests
dio.options.headers['Authorization'] = 'Bearer $token';
```

## 🐛 Troubleshooting

### Database Connection Error

```bash
# Check PostgreSQL is running
pg_isready

# Create database if missing
createdb cricket_db
```

### Port Already in Use

```bash
# Change port in command
uvicorn app.main:app --reload --port 8001
```

### Import Errors

```bash
# Reinstall dependencies
pip install -r requirements.txt
```

### Migration Errors

```bash
# Reset migrations (WARNING: Deletes data!)
alembic downgrade base
alembic upgrade head
```

## 📚 Additional Resources

- **Full README**: See `README.md` for detailed documentation
- **Implementation Status**: See `IMPLEMENTATION_STATUS.md` for what's done
- **API Design**: See `.kiro/specs/cricket-backend-api/design.md`
- **Requirements**: See `.kiro/specs/cricket-backend-api/requirements.md`

## 💡 Tips

1. **Use Docker** - Easiest way to get started
2. **Check `/docs`** - Swagger UI shows all available endpoints
3. **Test with `/healthcheck`** - Verify server is running
4. **Read logs** - Server logs show all requests and errors
5. **Use Postman/Insomnia** - Test API endpoints before Flutter integration

## ✅ You're Ready!

The backend foundation is **solid and production-ready**. The remaining work is implementing the business logic (services) and API endpoints (routers) using the patterns already established in the utilities and models.

**Estimated time to complete**: 4-6 hours for core features

Good luck! 🏏
