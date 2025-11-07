# Design Document

## Overview

This document outlines the technical design for the Cricket Scoreboard Backend API system built with Python FastAPI and PostgreSQL. The system provides RESTful APIs for authentication, match management, tournament management, player profiles, and statistics tracking.

## Architecture

### High-Level Architecture

```
┌─────────────────┐
│  Flutter App    │
│  (Mobile/Web)   │
└────────┬────────┘
         │ HTTP/HTTPS
         │ REST APIs
         ▼
┌─────────────────────────────────┐
│      FastAPI Backend            │
│  ┌──────────────────────────┐  │
│  │   API Layer (Routers)    │  │
│  └──────────┬───────────────┘  │
│             │                   │
│  ┌──────────▼───────────────┐  │
│  │  Business Logic (Services)│  │
│  └──────────┬───────────────┘  │
│             │                   │
│  ┌──────────▼───────────────┐  │
│  │   Data Layer (Models)    │  │
│  └──────────┬───────────────┘  │
└─────────────┼───────────────────┘
              │
              ▼
      ┌───────────────┐
      │  PostgreSQL   │
      │   Database    │
      └───────────────┘
```

### Technology Stack

- **Framework**: FastAPI 0.104+
- **Database**: PostgreSQL 15+
- **ORM**: SQLAlchemy 2.0+
- **Migrations**: Alembic
- **Authentication**: JWT (PyJWT)
- **Password Hashing**: bcrypt
- **Validation**: Pydantic v2
- **Testing**: pytest
- **CORS**: fastapi-cors-middleware
- **File Upload**: python-multipart
- **Environment**: python-dotenv

## Database Schema

### Users Table

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    is_guest BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### User Profiles Table

```sql
CREATE TABLE user_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    phone VARCHAR(50),
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100),
    date_of_birth DATE,
    role VARCHAR(50),
    batting_style VARCHAR(50),
    bowling_style VARCHAR(100),
    favorite_team VARCHAR(100),
    bio TEXT,
    profile_image_url VARCHAR(500),

    -- Career Statistics
    matches_played INTEGER DEFAULT 0,
    total_runs INTEGER DEFAULT 0,
    total_wickets INTEGER DEFAULT 0,
    batting_average DECIMAL(5,2) DEFAULT 0.00,
    bowling_average DECIMAL(5,2) DEFAULT 0.00,
    centuries INTEGER DEFAULT 0,
    half_centuries INTEGER DEFAULT 0,
    five_wicket_hauls INTEGER DEFAULT 0,
    highest_score INTEGER DEFAULT 0,
    best_bowling VARCHAR(20),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Matches Table

```sql
CREATE TABLE matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_by UUID REFERENCES users(id),
    team1 VARCHAR(100) NOT NULL,
    team2 VARCHAR(100) NOT NULL,
    overs_per_innings INTEGER NOT NULL,
    total_players INTEGER NOT NULL,
    toss_winner VARCHAR(100),
    toss_decision VARCHAR(20),
    status VARCHAR(50) DEFAULT 'not_started',
    winner VARCHAR(100),
    result TEXT,
    match_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Innings Table

```sql
CREATE TABLE innings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    match_id UUID REFERENCES matches(id) ON DELETE CASCADE,
    batting_team VARCHAR(100) NOT NULL,
    bowling_team VARCHAR(100) NOT NULL,
    innings_number INTEGER NOT NULL,
    total_runs INTEGER DEFAULT 0,
    wickets INTEGER DEFAULT 0,
    overs_completed DECIMAL(3,1) DEFAULT 0.0,
    extras INTEGER DEFAULT 0,
    is_complete BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Ball Events Table

```sql
CREATE TABLE ball_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    innings_id UUID REFERENCES innings(id) ON DELETE CASCADE,
    over_number INTEGER NOT NULL,
    ball_number INTEGER NOT NULL,
    batsman_name VARCHAR(100),
    bowler_name VARCHAR(100),
    runs INTEGER DEFAULT 0,
    is_wicket BOOLEAN DEFAULT FALSE,
    wicket_type VARCHAR(50),
    is_wide BOOLEAN DEFAULT FALSE,
    is_no_ball BOOLEAN DEFAULT FALSE,
    is_bye BOOLEAN DEFAULT FALSE,
    is_leg_bye BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Tournaments Table

```sql
CREATE TABLE tournaments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_by UUID REFERENCES users(id),
    name VARCHAR(255) NOT NULL,
    format VARCHAR(50) NOT NULL,
    teams TEXT[] NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Tournament Matches Table

```sql
CREATE TABLE tournament_matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tournament_id UUID REFERENCES tournaments(id) ON DELETE CASCADE,
    match_id UUID REFERENCES matches(id) ON DELETE CASCADE,
    team1 VARCHAR(100) NOT NULL,
    team2 VARCHAR(100) NOT NULL,
    scheduled_date TIMESTAMP,
    is_complete BOOLEAN DEFAULT FALSE,
    winner VARCHAR(100),
    team1_score INTEGER DEFAULT 0,
    team2_score INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Tournament Standings Table

```sql
CREATE TABLE tournament_standings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tournament_id UUID REFERENCES tournaments(id) ON DELETE CASCADE,
    team_name VARCHAR(100) NOT NULL,
    played INTEGER DEFAULT 0,
    won INTEGER DEFAULT 0,
    lost INTEGER DEFAULT 0,
    points INTEGER DEFAULT 0,
    net_run_rate DECIMAL(5,2) DEFAULT 0.00,
    UNIQUE(tournament_id, team_name)
);
```

### Player Profiles Table

```sql
CREATE TABLE player_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_by UUID REFERENCES users(id),
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    batting_style VARCHAR(50),
    bowling_style VARCHAR(100),
    date_of_birth DATE,
    team VARCHAR(100),
    nationality VARCHAR(100),

    -- Career Statistics
    matches_played INTEGER DEFAULT 0,
    total_runs INTEGER DEFAULT 0,
    total_wickets INTEGER DEFAULT 0,
    batting_average DECIMAL(5,2) DEFAULT 0.00,
    bowling_average DECIMAL(5,2) DEFAULT 0.00,
    centuries INTEGER DEFAULT 0,
    half_centuries INTEGER DEFAULT 0,
    five_wicket_hauls INTEGER DEFAULT 0,
    highest_score INTEGER DEFAULT 0,
    best_bowling VARCHAR(20),

    notes TEXT,
    profile_image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## API Endpoints

### Authentication Endpoints

#### POST /api/auth/signup

- **Description**: Register a new user
- **Request Body**:

```json
{
  "email": "user@example.com",
  "password": "securepassword",
  "name": "John Doe"
}
```

- **Response**: 201 Created

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

- **Description**: Login existing user
- **Request Body**:

```json
{
  "email": "user@example.com",
  "password": "securepassword"
}
```

- **Response**: 200 OK

```json
{
  "access_token": "jwt_token",
  "token_type": "bearer",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "John Doe",
    "is_guest": false
  }
}
```

#### POST /api/auth/guest

- **Description**: Create guest user session
- **Response**: 200 OK

```json
{
  "access_token": "jwt_token",
  "token_type": "bearer",
  "user": {
    "id": "uuid",
    "email": "guest@cricket.app",
    "name": "Guest User",
    "is_guest": true
  }
}
```

#### GET /api/auth/me

- **Description**: Get current user info
- **Headers**: Authorization: Bearer {token}
- **Response**: 200 OK

```json
{
  "id": "uuid",
  "email": "user@example.com",
  "name": "John Doe",
  "is_guest": false
}
```

### User Profile Endpoints

#### GET /api/profiles/me

- **Description**: Get current user's profile
- **Headers**: Authorization: Bearer {token}
- **Response**: 200 OK

#### PUT /api/profiles/me

- **Description**: Update current user's profile
- **Headers**: Authorization: Bearer {token}
- **Request Body**: Profile fields
- **Response**: 200 OK

#### POST /api/profiles/me/photo

- **Description**: Upload profile photo
- **Headers**: Authorization: Bearer {token}
- **Request**: multipart/form-data with file
- **Response**: 200 OK with image URL

### Match Endpoints

#### POST /api/matches

- **Description**: Create a new match
- **Headers**: Authorization: Bearer {token}
- **Request Body**:

```json
{
  "team1": "Team A",
  "team2": "Team B",
  "overs_per_innings": 20,
  "total_players": 11,
  "toss_winner": "Team A",
  "toss_decision": "bat"
}
```

- **Response**: 201 Created

#### GET /api/matches

- **Description**: Get all matches with pagination
- **Query Params**: page, limit, status
- **Response**: 200 OK

#### GET /api/matches/{match_id}

- **Description**: Get match details
- **Response**: 200 OK

#### PUT /api/matches/{match_id}

- **Description**: Update match details
- **Response**: 200 OK

#### DELETE /api/matches/{match_id}

- **Description**: Delete a match
- **Response**: 204 No Content

#### POST /api/matches/{match_id}/ball-events

- **Description**: Add ball event to match
- **Request Body**: Ball event details
- **Response**: 201 Created

### Tournament Endpoints

#### POST /api/tournaments

- **Description**: Create a new tournament (Registered users only)
- **Headers**: Authorization: Bearer {token}
- **Request Body**:

```json
{
  "name": "Summer Cup 2024",
  "teams": ["Team A", "Team B", "Team C", "Team D"],
  "format": "round_robin"
}
```

- **Response**: 201 Created

#### GET /api/tournaments

- **Description**: Get all tournaments
- **Response**: 200 OK

#### GET /api/tournaments/{tournament_id}

- **Description**: Get tournament details with standings
- **Response**: 200 OK

#### PUT /api/tournaments/{tournament_id}/matches/{match_id}/result

- **Description**: Update tournament match result
- **Response**: 200 OK

#### DELETE /api/tournaments/{tournament_id}

- **Description**: Delete tournament
- **Response**: 204 No Content

### Player Profile Endpoints

#### POST /api/players

- **Description**: Create player profile (Registered users only)
- **Headers**: Authorization: Bearer {token}
- **Response**: 201 Created

#### GET /api/players

- **Description**: Get all player profiles
- **Query Params**: search, role, page, limit
- **Response**: 200 OK

#### GET /api/players/{player_id}

- **Description**: Get player details
- **Response**: 200 OK

#### PUT /api/players/{player_id}

- **Description**: Update player profile
- **Response**: 200 OK

#### DELETE /api/players/{player_id}

- **Description**: Delete player profile
- **Response**: 204 No Content

#### POST /api/players/{player_id}/photo

- **Description**: Upload player photo
- **Response**: 200 OK

### Statistics Endpoints

#### GET /api/statistics/user/{user_id}

- **Description**: Get user career statistics
- **Response**: 200 OK

#### GET /api/statistics/player/{player_id}

- **Description**: Get player career statistics
- **Response**: 200 OK

#### POST /api/statistics/calculate/{match_id}

- **Description**: Calculate and update statistics from completed match
- **Response**: 200 OK

### Utility Endpoints

#### GET /healthcheck

- **Description**: Health check endpoint
- **Response**: 200 OK

```json
{
  "status": "healthy",
  "database": "connected",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

#### GET /api/uploads/{filename}

- **Description**: Serve uploaded files
- **Response**: File content

## Components and Interfaces

### Authentication Service

- **Purpose**: Handle user authentication and JWT token management
- **Methods**:
  - `create_user(email, password, name)`: Create new user
  - `authenticate_user(email, password)`: Verify credentials
  - `create_access_token(user_id)`: Generate JWT token
  - `verify_token(token)`: Validate JWT token
  - `get_current_user(token)`: Extract user from token
  - `create_guest_user()`: Create temporary guest user

### Match Service

- **Purpose**: Handle match creation, updates, and ball-by-ball tracking
- **Methods**:
  - `create_match(match_data, user_id)`: Create new match
  - `add_ball_event(match_id, ball_data)`: Record ball event
  - `complete_innings(innings_id)`: Mark innings as complete
  - `calculate_match_result(match_id)`: Determine winner
  - `get_match_summary(match_id)`: Get match statistics

### Tournament Service

- **Purpose**: Handle tournament management and standings
- **Methods**:
  - `create_tournament(tournament_data, user_id)`: Create tournament
  - `generate_fixtures(teams, format)`: Create match schedule
  - `update_match_result(tournament_id, match_id, result)`: Update standings
  - `calculate_standings(tournament_id)`: Recalculate points table
  - `get_next_match(tournament_id)`: Get upcoming match

### Statistics Service

- **Purpose**: Calculate and update player/user statistics
- **Methods**:
  - `calculate_from_match(match_id)`: Extract performances from match
  - `update_user_stats(user_id, performance)`: Update user statistics
  - `update_player_stats(player_id, performance)`: Update player statistics
  - `calculate_batting_average(runs, dismissals)`: Calculate average
  - `calculate_bowling_average(runs_conceded, wickets)`: Calculate average

### File Upload Service

- **Purpose**: Handle file uploads and storage
- **Methods**:
  - `validate_file(file)`: Check file type and size
  - `save_file(file, directory)`: Save file to disk
  - `generate_unique_filename(original_name)`: Create unique name
  - `delete_file(file_path)`: Remove file from storage
  - `get_file_url(filename)`: Generate accessible URL

## Data Models

### Pydantic Schemas

#### UserCreate

```python
class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(min_length=6)
    name: str = Field(min_length=1)
```

#### UserResponse

```python
class UserResponse(BaseModel):
    id: UUID
    email: str
    name: str
    is_guest: bool
    created_at: datetime
```

#### TokenResponse

```python
class TokenResponse(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse
```

#### MatchCreate

```python
class MatchCreate(BaseModel):
    team1: str
    team2: str
    overs_per_innings: int = Field(ge=1, le=50)
    total_players: int = Field(ge=1, le=11)
    toss_winner: str
    toss_decision: str
```

#### BallEventCreate

```python
class BallEventCreate(BaseModel):
    runs: int = Field(ge=0, le=6)
    is_wicket: bool = False
    wicket_type: Optional[str] = None
    is_wide: bool = False
    is_no_ball: bool = False
    batsman_name: str
    bowler_name: str
```

## Error Handling

### Error Response Format

```json
{
  "detail": "Error message",
  "error_code": "ERROR_CODE",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

### HTTP Status Codes

- **200**: Success
- **201**: Created
- **204**: No Content
- **400**: Bad Request (validation errors)
- **401**: Unauthorized (authentication failed)
- **403**: Forbidden (insufficient permissions)
- **404**: Not Found
- **422**: Unprocessable Entity (Pydantic validation)
- **500**: Internal Server Error

### Custom Exceptions

- `AuthenticationError`: Invalid credentials
- `AuthorizationError`: Insufficient permissions
- `ResourceNotFoundError`: Resource doesn't exist
- `ValidationError`: Data validation failed
- `GuestUserRestrictionError`: Guest user accessing restricted feature

## Testing Strategy

### Unit Tests

- Test individual service methods
- Mock database calls
- Test authentication logic
- Test statistics calculations

### Integration Tests

- Test complete API workflows
- Test database operations
- Test file uploads
- Test authentication flow

### Test Coverage Goals

- Minimum 80% code coverage
- 100% coverage for authentication
- 100% coverage for critical business logic

## Security Considerations

### Password Security

- Use bcrypt for password hashing
- Minimum password length: 6 characters
- Store only hashed passwords

### JWT Security

- Use strong secret key (256-bit)
- Set reasonable expiration (24 hours)
- Include user_id and is_guest in payload

### API Security

- Validate all inputs with Pydantic
- Sanitize file uploads
- Rate limit API endpoints
- Use HTTPS in production

### CORS Configuration

- Allow specific Flutter origins
- Restrict allowed methods
- Set appropriate headers

## Deployment Configuration

### Environment Variables

```
DATABASE_URL=postgresql://user:password@localhost:5432/cricket_db
JWT_SECRET_KEY=your-secret-key-here
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
CORS_ORIGINS=http://localhost:3000,https://yourapp.com
UPLOAD_DIR=./uploads
MAX_FILE_SIZE=5242880
```

### Docker Configuration

- Use Python 3.11 slim image
- Multi-stage build for optimization
- Include PostgreSQL in docker-compose
- Volume mount for uploads directory

### Production Considerations

- Use Gunicorn with Uvicorn workers
- Set up database connection pooling
- Configure logging to file
- Set up monitoring and alerts
- Use environment-specific configs
