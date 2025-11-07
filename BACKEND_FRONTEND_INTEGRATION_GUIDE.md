# Backend-Frontend Integration Guide

## 🎯 Overview

Your Flutter frontend is now fully integrated with the FastAPI backend! This guide will help you set up PostgreSQL and run both applications.

---

## 📋 Prerequisites

- ✅ Python 3.13.5 (installed)
- ✅ Flutter 3.32.4 (installed)
- ⏳ PostgreSQL 15+ (needs setup)
- ⏳ pgAdmin 4 (for database management)

---

## 🗄️ Step 1: PostgreSQL Setup

### Option A: Install PostgreSQL Locally

1. **Download PostgreSQL**

   - Visit: https://www.postgresql.org/download/windows/
   - Download PostgreSQL 15 or higher
   - Run the installer

2. **During Installation:**

   - Set a password for the `postgres` superuser (remember this!)
   - Default port: `5432`
   - Install pgAdmin 4 (included in installer)

3. **Create Database Using pgAdmin:**

   - Open pgAdmin 4
   - Connect to your PostgreSQL server (use the password you set)
   - Right-click on "Databases" → "Create" → "Database"
   - Database name: `cricket_db`
   - Owner: `postgres` (or create a new user)
   - Click "Save"

4. **Create Database User (Optional but Recommended):**

   - In pgAdmin, expand your server
   - Right-click "Login/Group Roles" → "Create" → "Login/Group Role"
   - General tab: Name = `cricket_user`
   - Definition tab: Password = `cricket_password`
   - Privileges tab: Check "Can login?" and "Create databases?"
   - Click "Save"

5. **Grant Permissions:**
   - Right-click on `cricket_db` → "Properties"
   - Go to "Security" tab
   - Add `cricket_user` with all privileges
   - Click "Save"

### Option B: Use Docker (Alternative)

```bash
cd Backend
docker-compose up -d db
```

This will start PostgreSQL in a container with the correct configuration.

---

## 🔧 Step 2: Configure Backend

### Update Database Connection

1. **Open `Backend/.env`** (already created)

2. **Update DATABASE_URL with your credentials:**

   If using default postgres user:

   ```env
   DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/cricket_db
   ```

   If using cricket_user:

   ```env
   DATABASE_URL=postgresql://cricket_user:cricket_password@localhost:5432/cricket_db
   ```

3. **Your complete `.env` should look like:**

   ```env
   # Database Configuration
   DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/cricket_db

   # JWT Configuration
   JWT_SECRET_KEY=your-super-secret-jwt-key-change-this-in-production-min-32-chars
   JWT_ALGORITHM=HS256
   ACCESS_TOKEN_EXPIRE_MINUTES=1440

   # CORS Configuration (JSON array format)
   CORS_ORIGINS=["http://localhost:3000","http://localhost:8080","http://localhost:5000"]

   # File Upload Configuration
   UPLOAD_DIR=./uploads
   MAX_FILE_SIZE=5242880

   # Application Configuration
   APP_NAME=Cricket Scoreboard API
   APP_VERSION=1.0.0
   DEBUG=True
   ```

---

## 🚀 Step 3: Run Database Migrations

```bash
cd Backend

# Run migrations to create all tables
alembic upgrade head
```

**Expected Output:**

```
INFO  [alembic.runtime.migration] Context impl PostgresqlImpl.
INFO  [alembic.runtime.migration] Will assume transactional DDL.
INFO  [alembic.runtime.migration] Running upgrade  -> 001, Initial migration
```

**Verify in pgAdmin:**

- Refresh your database
- Expand `cricket_db` → `Schemas` → `public` → `Tables`
- You should see: `users`, `user_profiles`, `matches`, `innings`, `ball_events`, `tournaments`, `tournament_matches`, `tournament_standings`, `player_profiles`

---

## 🎮 Step 4: Start the Backend

```bash
cd Backend

# Start the FastAPI server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**Expected Output:**

```
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
INFO:     Started reloader process
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

**Test the API:**

- Open browser: http://localhost:8000
- API Docs: http://localhost:8000/docs
- Health Check: http://localhost:8000/healthcheck

---

## 📱 Step 5: Configure Frontend

### Update API URL (if needed)

If your backend is running on a different URL, update:

**File:** `Frontend/app/lib/services/api_service.dart`

```dart
static const String baseUrl = 'http://localhost:8000';
```

For Android emulator, use: `http://10.0.2.2:8000`
For iOS simulator, use: `http://localhost:8000`
For physical device, use: `http://YOUR_COMPUTER_IP:8000`

---

## 🎯 Step 6: Run the Flutter App

```bash
cd Frontend/app

# Run on Chrome (Web)
flutter run -d chrome

# Or run on Windows
flutter run -d windows

# Or run on Android/iOS
flutter run
```

---

## ✅ Step 7: Test the Integration

### Test Authentication Flow

1. **Start Backend** (if not already running)

   ```bash
   cd Backend
   uvicorn app.main:app --reload
   ```

2. **Start Frontend**

   ```bash
   cd Frontend/app
   flutter run -d chrome
   ```

3. **Test Signup:**

   - Click "Sign Up"
   - Enter: Name, Email, Password
   - Click "Sign Up" button
   - Should redirect to Home Screen

4. **Test Login:**

   - Logout (if logged in)
   - Click "Login"
   - Enter your email and password
   - Should redirect to Home Screen

5. **Test Guest Mode:**

   - Click "Continue as Guest"
   - Should redirect to Home Screen
   - Guest users can only create Quick Matches

6. **Verify in Database (pgAdmin):**
   - Open pgAdmin
   - Navigate to `cricket_db` → `Schemas` → `public` → `Tables` → `users`
   - Right-click → "View/Edit Data" → "All Rows"
   - You should see your registered users!

---

## 🔍 Troubleshooting

### Backend Issues

**Problem:** `connection to server at "localhost" failed`

- **Solution:** Make sure PostgreSQL is running
- Check in pgAdmin or Task Manager
- Verify DATABASE_URL in `.env` is correct

**Problem:** `password authentication failed`

- **Solution:** Check your PostgreSQL password
- Update DATABASE_URL with correct credentials

**Problem:** `relation "users" does not exist`

- **Solution:** Run migrations: `alembic upgrade head`

### Frontend Issues

**Problem:** `Network error` or `Connection refused`

- **Solution:** Make sure backend is running on http://localhost:8000
- Check if you can access http://localhost:8000/docs

**Problem:** `XMLHttpRequest error` on web

- **Solution:** CORS is already configured, but make sure backend is running

**Problem:** Can't connect from Android emulator

- **Solution:** Use `http://10.0.2.2:8000` instead of `localhost`

---

## 📊 Database Schema

Your database now has these tables:

### Core Tables

- **users** - User accounts (registered and guest)
- **user_profiles** - Extended user information and statistics
- **matches** - Cricket match records
- **innings** - Innings data for each match
- **ball_events** - Ball-by-ball tracking
- **tournaments** - Tournament information
- **tournament_matches** - Tournament fixtures
- **tournament_standings** - Team standings
- **player_profiles** - Player database

### View Data in pgAdmin

1. Open pgAdmin
2. Navigate to: `cricket_db` → `Schemas` → `public` → `Tables`
3. Right-click any table → "View/Edit Data" → "All Rows"
4. You can view, edit, and query data directly!

---

## 🔐 API Endpoints Available

### Authentication (✅ Implemented)

- `POST /api/auth/signup` - Register new user
- `POST /api/auth/login` - Login existing user
- `POST /api/auth/guest` - Create guest session
- `GET /api/auth/me` - Get current user info

### Coming Soon (Need Implementation)

- `POST /api/matches` - Create match
- `GET /api/matches` - List matches
- `POST /api/tournaments` - Create tournament
- `GET /api/players` - List players
- And more...

---

## 🎨 Frontend Features

### Implemented

- ✅ Authentication (Signup, Login, Guest)
- ✅ Token storage (secure)
- ✅ Auto-login on app restart
- ✅ API service layer
- ✅ Error handling

### Ready to Use (Local Mode)

- ✅ Match scoring
- ✅ Tournament management
- ✅ Player profiles
- ✅ Statistics tracking

---

## 🚀 Quick Start Commands

### Terminal 1 - Backend

```bash
cd Backend
uvicorn app.main:app --reload
```

### Terminal 2 - Frontend

```bash
cd Frontend/app
flutter run -d chrome
```

### Terminal 3 - Database (Optional)

```bash
# View logs
cd Backend
alembic history

# Create new migration
alembic revision --autogenerate -m "Description"

# Apply migrations
alembic upgrade head
```

---

## 📝 Next Steps

1. ✅ **Setup Complete!** - Backend and Frontend are connected
2. ⏳ **Implement Remaining API Endpoints:**
   - Matches API
   - Tournaments API
   - Players API
   - Statistics API
3. ⏳ **Update Frontend Providers:**
   - MatchProvider to use API
   - TournamentProvider to use API
   - PlayerProfileProvider to use API

---

## 🎉 Success Indicators

You'll know everything is working when:

1. ✅ Backend starts without errors
2. ✅ You can access http://localhost:8000/docs
3. ✅ Flutter app starts without errors
4. ✅ You can signup/login successfully
5. ✅ You see user data in pgAdmin
6. ✅ Token is saved and persists after app restart

---

## 💡 Tips

- **Use pgAdmin** to view and manage your database visually
- **Check Backend Logs** in the terminal for API requests
- **Use Swagger Docs** at http://localhost:8000/docs to test API endpoints
- **Enable Debug Mode** in Flutter to see detailed error messages
- **Check Network Tab** in browser DevTools to see API calls

---

## 📞 Common pgAdmin Tasks

### View All Users

```sql
SELECT id, email, name, is_guest, created_at FROM users;
```

### View User Profiles

```sql
SELECT u.name, up.role, up.matches_played, up.total_runs
FROM users u
JOIN user_profiles up ON u.id = up.user_id;
```

### Delete Test Data

```sql
-- Delete all guest users
DELETE FROM users WHERE is_guest = true;

-- Delete specific user
DELETE FROM users WHERE email = 'test@example.com';
```

### Reset Database

```bash
cd Backend
alembic downgrade base
alembic upgrade head
```

---

## 🎯 You're All Set!

Your Cricket Scoreboard app is now fully integrated with a PostgreSQL database via FastAPI backend. Users can signup, login, and their data is persisted in the database!

Happy coding! 🏏
