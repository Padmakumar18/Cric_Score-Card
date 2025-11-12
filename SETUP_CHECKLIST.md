# ✅ Setup Checklist

## Before You Start

- [ ] Python 3.13.5 installed
- [ ] Flutter 3.32.4 installed
- [ ] PostgreSQL 15+ installed
- [ ] pgAdmin 4 installed

---

## Database Setup

- [ ] PostgreSQL service is running
- [ ] Created database: `cricket_db`
- [ ] Noted your PostgreSQL password
- [ ] Can connect to database in pgAdmin

---

## Backend Configuration

- [ ] Updated `Backend/.env` with your PostgreSQL password
- [ ] DATABASE_URL is correct
- [ ] Ran migrations: `alembic upgrade head`
- [ ] Can see tables in pgAdmin (users, matches, etc.)

---

## Backend Testing

- [ ] Backend starts without errors: `uvicorn app.main:app --reload`
- [ ] Can access: http://localhost:8000
- [ ] Can access API docs: http://localhost:8000/docs
- [ ] Health check works: http://localhost:8000/healthcheck
- [ ] Database status shows "connected"

---

## Frontend Configuration

- [ ] Ran: `flutter pub get`
- [ ] No errors in: `flutter analyze`
- [ ] API URL is correct in `api_service.dart`

---

## Frontend Testing

- [ ] Frontend starts: `flutter run -d chrome`
- [ ] Auth screen appears
- [ ] Can click "Sign Up"
- [ ] Can enter email/password

---

## Integration Testing

- [ ] Backend is running (Terminal 1)
- [ ] Frontend is running (Terminal 2)
- [ ] Created a test account via Sign Up
- [ ] Successfully logged in
- [ ] Can see user in pgAdmin → users table
- [ ] Logout works
- [ ] Login again works (persistent session)
- [ ] Guest mode works

---

## Verification

- [ ] User data appears in PostgreSQL
- [ ] JWT token is saved (check Flutter DevTools)
- [ ] Auto-login works after app restart
- [ ] No errors in backend terminal
- [ ] No errors in frontend terminal

---

## 🎉 All Done!

If all checkboxes are checked, your integration is complete!

### Quick Commands

**Start Backend:**

```bash
cd Backend
uvicorn app.main:app --reload
```

**Start Frontend:**

```bash
cd Frontend/app
flutter run -d chrome
```

**View Database:**

- Open pgAdmin
- Navigate to cricket_db → Tables → users
- Right-click → View/Edit Data → All Rows

---

## Need Help?

See these guides:

- `QUICK_START.md` - Quick reference
- `BACKEND_FRONTEND_INTEGRATION_GUIDE.md` - Detailed setup
- `INTEGRATION_SUMMARY.md` - What was implemented
