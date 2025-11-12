# Cricket Scoreboard Backend API

Complete backend API system for the Cricket Scoreboard Flutter application built with Python FastAPI and PostgreSQL.

## 🚀 Features

- **User Authentication**: Signup, login, JWT tokens, guest mode
- **Match Management**: Create matches, ball-by-ball tracking, live scoring
- **Tournament Management**: Round-robin/knockout tournaments, fixtures, standings
- **Player Profiles**: Comprehensive player database with statistics
- **Auto-calculated Statistics**: Automatic stat updates from match performances
- **File Uploads**: Profile and player photo uploads
- **CORS Support**: Flutter web compatibility
- **Security**: Rate limiting, security headers, password hashing
- **API Documentation**: Auto-generated Swagger and ReDoc

## 📋 Requirements

- Python 3.11+
- PostgreSQL 15+
- pip or poetry for package management

## 🛠️ Installation

### Local Setup

1. **Clone the repository**

```bash
cd backend
```

2. **Create virtual environment**

```bash
python -m venv venv

# On Windows
venv\Scripts\activate

# On macOS/Linux
source venv/bin/activate
```

3. **Install dependencies**

```bash
pip install -r requirements.txt
```

4. **Set up environment variables**

```bash
# Copy example env file
cp .env.example .env

# Edit .env with your configuration
# Update DATABASE_URL, JWT_SECRET_KEY, etc.
```

5. **Set up PostgreSQL database**

```bash
# Create database
createdb cricket_db

# Or using psql
psql -U postgres
CREATE DATABASE cricket_db;
CREATE USER cricket_user WITH PASSWORD 'cricket_password';
GRANT ALL PRIVILEGES ON DATABASE cricket_db TO cricket_user;
```

6. **Run database migrations**

```bash
# Initialize Alembic (first time only)
alembic init alembic

# Create initial migration
alembic revision --autogenerate -m "Initial migration"

# Apply migrations
alembic upgrade head
```

7. **Run the application**

```bash
# Development mode with auto-reload
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Or using Python directly
python -m app.main
```

8. **Access the API**

- API: http://localhost:8000
- Swagger Docs: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc
- Health Check: http://localhost:8000/healthcheck

### Docker Setup

1. **Build and run with Docker Compose**

```bash
docker-compose up -d
```

2. **Run migrations in Docker**

```bash
docker-compose exec backend alembic upgrade head
```

3. **View logs**

```bash
docker-compose logs -f backend
```

4. **Stop containers**

```bash
docker-compose down
```

## 📁 Project Structure

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py                 # FastAPI application entry point
│   ├── config/
│   │   ├── __init__.py
│   │   ├── settings.py         # Environment configuration
│   │   └── database.py         # Database connection
│   ├── models/                 # SQLAlchemy models
│   │   ├── __init__.py
│   │   ├── user.py
│   │   ├── match.py
│   │   ├── tournament.py
│   │   └── player.py
│   ├── schemas/                # Pydantic schemas
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   ├── match.py
│   │   └── tournament.py
│   ├── routers/                # API endpoints
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   ├── profiles.py
│   │   ├── matches.py
│   │   ├── tournaments.py
│   │   ├── players.py
│   │   └── statistics.py
│   ├── services/               # Business logic
│   │   ├── __init__.py
│   │   ├── auth_service.py
│   │   ├── match_service.py
│   │   ├── tournament_service.py
│   │   └── statistics_service.py
│   ├── utils/                  # Helper functions
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   ├── file_upload.py
│   │   └── exceptions.py
│   └── seeders/                # Database seeders
│       ├── __init__.py
│       └── seed.py
├── tests/                      # Test files
│   ├── __init__.py
│   ├── conftest.py
│   ├── test_auth.py
│   ├── test_matches.py
│   └── test_tournaments.py
├── alembic/                    # Database migrations
├── uploads/                    # Uploaded files
├── requirements.txt            # Python dependencies
├── .env.example               # Example environment variables
├── Dockerfile                 # Docker configuration
├── docker-compose.yml         # Docker Compose configuration
└── README.md                  # This file
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file with the following variables:

```env
# Database
DATABASE_URL=postgresql://cricket_user:cricket_password@localhost:5432/cricket_db

# JWT
JWT_SECRET_KEY=your-super-secret-jwt-key-min-32-characters
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440

# CORS
CORS_ORIGINS=http://localhost:3000,http://localhost:8080

# File Upload
UPLOAD_DIR=./uploads
MAX_FILE_SIZE=5242880

# Application
APP_NAME=Cricket Scoreboard API
APP_VERSION=1.0.0
DEBUG=True
```

## 📚 API Documentation

### Authentication Endpoints

#### POST /api/auth/signup

Register a new user.

**Request:**

```json
{
  "email": "user@example.com",
  "password": "securepassword",
  "name": "John Doe"
}
```

**Response:**

```json
{
  "id": "uuid",
  "email": "user@example.com",
  "name": "John Doe",
  "access_token": "jwt_token",
  "token_type": "bearer"
}
```

#### POST /api/auth/login

Login existing user.

#### POST /api/auth/guest

Create guest user session.

#### GET /api/auth/me

Get current user information (requires authentication).

### Match Endpoints

#### POST /api/matches

Create a new match.

#### GET /api/matches

Get all matches with pagination.

#### GET /api/matches/{match_id}

Get match details.

#### POST /api/matches/{match_id}/ball-events

Add ball event to match.

### Tournament Endpoints

#### POST /api/tournaments

Create a new tournament (registered users only).

#### GET /api/tournaments

Get all tournaments.

#### GET /api/tournaments/{tournament_id}

Get tournament details with standings.

For complete API documentation, visit `/docs` or `/redoc` when the server is running.

## 🧪 Testing

### Run all tests

```bash
pytest
```

### Run with coverage

```bash
pytest --cov=app --cov-report=html
```

### Run specific test file

```bash
pytest tests/test_auth.py
```

## 🔒 Security

- **Password Hashing**: bcrypt with salt
- **JWT Tokens**: HS256 algorithm with expiration
- **CORS**: Configured for Flutter web
- **Rate Limiting**: 100 requests per minute per IP
- **Security Headers**: X-Content-Type-Options, X-Frame-Options, X-XSS-Protection
- **Input Validation**: Pydantic schemas for all requests

## 🚢 Deployment

### Production Checklist

1. Set strong `JWT_SECRET_KEY` (min 32 characters)
2. Set `DEBUG=False`
3. Use production PostgreSQL database
4. Configure proper CORS origins
5. Set up HTTPS/SSL
6. Configure logging to file
7. Set up monitoring and alerts
8. Use Gunicorn with Uvicorn workers

### Example Production Command

```bash
gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
```

## 📝 Database Migrations

### Create a new migration

```bash
alembic revision --autogenerate -m "Description of changes"
```

### Apply migrations

```bash
alembic upgrade head
```

### Rollback migration

```bash
alembic downgrade -1
```

### View migration history

```bash
alembic history
```

## 🌱 Seeding Data

Run seeders to populate database with sample data:

```bash
python -m app.seeders.seed
```

## 🐛 Troubleshooting

### Database connection error

- Verify PostgreSQL is running
- Check DATABASE_URL in .env
- Ensure database exists

### Import errors

- Activate virtual environment
- Install all requirements: `pip install -r requirements.txt`

### Port already in use

- Change port: `uvicorn app.main:app --port 8001`
- Or kill process using port 8000

## 📞 Support

For issues and questions:

- Check API documentation at `/docs`
- Review error logs
- Check database connection

## 📄 License

This project is part of the Cricket Scoreboard application.

## 🤝 Contributing

1. Follow PEP 8 style guide
2. Write tests for new features
3. Update documentation
4. Create meaningful commit messages

---

**Built with ❤️ using FastAPI and PostgreSQL**
