# 🚀 Quick Start Guide

## Prerequisites Setup

### 1. Install PostgreSQL

- Download: https://www.postgresql.org/download/windows/
- Install with pgAdmin 4
- Remember your postgres password!

### 2. Create Database in pgAdmin

1. Open pgAdmin 4
2. Right-click "Databases" → Create → Database
3. Name: `cricket_db`
4. Click Save

### 3. Update Backend Configuration

Edit `Backend/.env`:

```env
DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/cricket_db
```

Replace `YOUR_PASSWORD` with your PostgreSQL password.

---

## 🎯 Run the Application

### Terminal 1: Start Backend

```bash
cd Backend

# Run migrations (first time only)
alembic upgrade head

# Start server
uvicorn app.main:app --reload
```

**Backend running at:** http://localhost:8000
**API Docs:** http://localhost:8000/docs

### Terminal 2: Start Frontend

```bash
cd Frontend/app

# Run on Chrome
flutter run -d chrome

# Or run on Windows
flutter run -d windows
```

---

## ✅ Test It Works

1. **Backend Test:**

   - Open: http://localhost:8000/docs
   - Try the `/healthcheck` endpoint
   - Should show: `{"status": "healthy", "database": "connected"}`

2. **Frontend Test:**

   - Click "Sign Up"
   - Create an account
   - Should redirect to Home Screen

3. **Database Test:**
   - Open pgAdmin
   - Navigate to: `cricket_db` → Tables → `users`
   - Right-click → View/Edit Data → All Rows
   - See your new user!

---

## 🔧 Troubleshooting

**Backend won't start?**

- Check PostgreSQL is running
- Verify DATABASE_URL in `.env`
- Run: `alembic upgrade head`

**Frontend can't connect?**

- Make sure backend is running on port 8000
- Check: http://localhost:8000/docs

**Database connection failed?**

- Verify PostgreSQL password
- Check database `cricket_db` exists
- Test connection in pgAdmin

---

## 📚 Full Documentation

See `BACKEND_FRONTEND_INTEGRATION_GUIDE.md` for complete setup instructions.

---

## 🎉 You're Ready!

Both backend and frontend are now connected to PostgreSQL!
