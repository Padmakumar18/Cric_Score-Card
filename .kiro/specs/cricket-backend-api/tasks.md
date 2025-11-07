# Implementation Plan

- [x] 1. Set up project structure and dependencies

  - Create backend directory with FastAPI project structure
  - Create /app/main.py, /app/models, /app/schemas, /app/routers, /app/services, /app/utils, /app/config, /app/seeders directories
  - Create requirements.txt with FastAPI, SQLAlchemy, Alembic, PostgreSQL driver, JWT, bcrypt, pytest, and other dependencies
  - Create .env.example file with DATABASE_URL, JWT_SECRET_KEY, JWT_ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES, CORS_ORIGINS
  - Create README.md with setup instructions, running commands, and API documentation links
  - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [x] 2. Configure database connection and migrations

  - [x] 2.1 Create database configuration in /app/config/database.py

    - Set up SQLAlchemy engine with PostgreSQL connection
    - Create SessionLocal for database sessions
    - Create Base class for declarative models
    - _Requirements: 2.1, 2.5_

  - [x] 2.2 Initialize Alembic for migrations

    - Run alembic init alembic command
    - Configure alembic.ini with database URL
    - Update env.py to import models
    - _Requirements: 2.2_

  - [x] 2.3 Create database models in /app/models

    - Create User model with id, email, password_hash, name, is_guest, is_active, timestamps
    - Create UserProfile model with all profile fields and career statistics
    - Create Match model with team names, overs, players, toss, status, winner
    - Create Innings model with batting/bowling teams, runs, wickets, overs
    - Create BallEvent model with over, ball, batsman, bowler, runs, wicket details
    - Create Tournament model with name, format, teams
    - Create TournamentMatch model linking tournaments to matches
    - Create TournamentStanding model with team stats
    - Create PlayerProfile model with player details and statistics
    - _Requirements: 2.3_

  - [x] 2.4 Create initial migration

    - Run alembic revision --autogenerate -m "Initial migration"
    - Review generated migration file
    - Run alembic upgrade head to create tables
    - _Requirements: 2.2, 2.3_

- [-] 3. Implement authentication system

  - [x] 3.1 Create authentication utilities in /app/utils/auth.py

    - Implement password hashing with bcrypt (hash_password, verify_password)
    - Implement JWT token creation (create_access_token)
    - Implement JWT token verification (verify_token)
    - Create get_current_user dependency for protected routes
    - _Requirements: 3.1, 3.4_

  - [x] 3.2 Create authentication schemas in /app/schemas/auth.py

    - Create UserCreate schema with email, password, name validation
    - Create UserLogin schema with email and password
    - Create UserResponse schema with id, email, name, is_guest
    - Create TokenResponse schema with access_token, token_type, user
    - _Requirements: 3.1, 3.2_

  - [ ] 3.3 Create authentication service in /app/services/auth_service.py

    - Implement create_user method to register new users
    - Implement authenticate_user method to verify credentials
    - Implement create_guest_user method for guest sessions
    - Implement get_user_by_email method
    - _Requirements: 3.1, 3.2, 3.6_

  - [ ] 3.4 Create authentication router in /app/routers/auth.py
    - Implement POST /api/auth/signup endpoint
    - Implement POST /api/auth/login endpoint
    - Implement POST /api/auth/guest endpoint
    - Implement GET /api/auth/me endpoint with authentication
    - Add error handling for invalid credentials (401) and duplicate emails (400)
    - _Requirements: 3.1, 3.2, 3.3, 3.5, 3.6_

- [ ] 4. Implement user profile management

  - [ ] 4.1 Create profile schemas in /app/schemas/profile.py

    - Create UserProfileCreate schema with all profile fields
    - Create UserProfileUpdate schema with optional fields
    - Create UserProfileResponse schema with all fields including statistics
    - _Requirements: 4.1, 4.2_

  - [ ] 4.2 Create profile service in /app/services/profile_service.py

    - Implement create_profile method
    - Implement update_profile method with timestamp update
    - Implement get_profile method
    - Implement calculate_statistics method for career stats
    - _Requirements: 4.1, 4.2, 4.3, 4.5_

  - [ ] 4.3 Create profile router in /app/routers/profiles.py
    - Implement GET /api/profiles/me endpoint
    - Implement PUT /api/profiles/me endpoint
    - Add authentication requirement for all endpoints
    - _Requirements: 4.1, 4.2, 4.3_

- [ ] 5. Implement file upload functionality

  - [ ] 5.1 Create file upload utilities in /app/utils/file_upload.py

    - Implement validate_file function for type and size checks
    - Implement save_file function to save to /uploads directory
    - Implement generate_unique_filename function
    - Implement delete_file function
    - _Requirements: 9.1, 9.2, 9.5_

  - [ ] 5.2 Add photo upload endpoints to profile router

    - Implement POST /api/profiles/me/photo endpoint
    - Validate file type (jpg, png, jpeg) and size (max 5MB)
    - Save file and update profile with image URL
    - Return error for invalid files (400)
    - _Requirements: 4.4, 9.1, 9.2, 9.3, 9.4_

  - [ ] 5.3 Create static file serving
    - Add StaticFiles mount for /uploads directory
    - Implement GET /api/uploads/{filename} endpoint
    - _Requirements: 9.3_

- [ ] 6. Implement match management

  - [ ] 6.1 Create match schemas in /app/schemas/match.py

    - Create MatchCreate schema with team names, overs, players, toss
    - Create MatchUpdate schema
    - Create MatchResponse schema with all match details
    - Create BallEventCreate schema with runs, wicket, extras details
    - Create InningsResponse schema
    - _Requirements: 5.1, 5.2_

  - [ ] 6.2 Create match service in /app/services/match_service.py

    - Implement create_match method
    - Implement add_ball_event method to record ball-by-ball data
    - Implement complete_innings method
    - Implement calculate_match_result method
    - Implement get_match_summary method
    - _Requirements: 5.1, 5.2, 5.3, 5.4_

  - [ ] 6.3 Create match router in /app/routers/matches.py
    - Implement POST /api/matches endpoint
    - Implement GET /api/matches endpoint with pagination
    - Implement GET /api/matches/{match_id} endpoint
    - Implement PUT /api/matches/{match_id} endpoint
    - Implement DELETE /api/matches/{match_id} endpoint
    - Implement POST /api/matches/{match_id}/ball-events endpoint
    - Add guest user check - block player details entry (403)
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

- [ ] 7. Implement tournament management

  - [ ] 7.1 Create tournament schemas in /app/schemas/tournament.py

    - Create TournamentCreate schema with name, teams, format
    - Create TournamentResponse schema
    - Create TournamentMatchResponse schema
    - Create TournamentStandingResponse schema
    - _Requirements: 6.1, 6.3_

  - [ ] 7.2 Create tournament service in /app/services/tournament_service.py

    - Implement create_tournament method
    - Implement generate_fixtures method for round-robin/knockout
    - Implement update_match_result method
    - Implement calculate_standings method with points calculation
    - Implement get_next_match method
    - _Requirements: 6.1, 6.2, 6.3_

  - [ ] 7.3 Create tournament router in /app/routers/tournaments.py
    - Implement POST /api/tournaments endpoint (registered users only)
    - Implement GET /api/tournaments endpoint
    - Implement GET /api/tournaments/{tournament_id} endpoint
    - Implement PUT /api/tournaments/{tournament_id}/matches/{match_id}/result endpoint
    - Implement DELETE /api/tournaments/{tournament_id} endpoint
    - Add guest user restriction (403) for create/delete operations
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5_

- [ ] 8. Implement player profile management

  - [ ] 8.1 Create player schemas in /app/schemas/player.py

    - Create PlayerProfileCreate schema with name, role, styles, team
    - Create PlayerProfileUpdate schema
    - Create PlayerProfileResponse schema with statistics
    - _Requirements: 7.1_

  - [ ] 8.2 Create player service in /app/services/player_service.py

    - Implement create_player method
    - Implement update_player method
    - Implement get_players method with search and filtering
    - Implement calculate_player_stats method
    - _Requirements: 7.1, 7.2, 7.4_

  - [ ] 8.3 Create player router in /app/routers/players.py
    - Implement POST /api/players endpoint (registered users only)
    - Implement GET /api/players endpoint with search, role filter, pagination
    - Implement GET /api/players/{player_id} endpoint
    - Implement PUT /api/players/{player_id} endpoint
    - Implement DELETE /api/players/{player_id} endpoint
    - Implement POST /api/players/{player_id}/photo endpoint
    - Add guest user restriction (403) for create/update/delete
    - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5_

- [ ] 9. Implement statistics auto-calculation

  - [ ] 9.1 Create statistics service in /app/services/statistics_service.py

    - Implement calculate_from_match method to extract player performances
    - Implement update_user_stats method to update user career statistics
    - Implement update_player_stats method
    - Implement calculate_batting_average method
    - Implement calculate_bowling_average method
    - Implement check_milestones method (50s, 100s, 5-wicket hauls)
    - _Requirements: 8.1, 8.2, 8.3, 8.4_

  - [ ] 9.2 Create statistics router in /app/routers/statistics.py

    - Implement GET /api/statistics/user/{user_id} endpoint
    - Implement GET /api/statistics/player/{player_id} endpoint
    - Implement POST /api/statistics/calculate/{match_id} endpoint
    - _Requirements: 8.1, 8.5_

  - [ ] 9.3 Integrate statistics calculation with match completion
    - Add automatic statistics update when match status changes to completed
    - Update user profiles with new statistics
    - Update player profiles with new statistics
    - _Requirements: 8.1, 8.2, 8.3, 8.4_

- [ ] 10. Implement error handling and validation

  - [ ] 10.1 Create custom exceptions in /app/utils/exceptions.py

    - Create AuthenticationError exception
    - Create AuthorizationError exception
    - Create ResourceNotFoundError exception
    - Create GuestUserRestrictionError exception
    - _Requirements: 10.2, 10.3, 10.4, 10.5_

  - [ ] 10.2 Create error handlers in /app/main.py

    - Add exception handler for AuthenticationError (401)
    - Add exception handler for AuthorizationError (403)
    - Add exception handler for ResourceNotFoundError (404)
    - Add exception handler for ValidationError (422)
    - Add generic exception handler (500)
    - _Requirements: 10.2, 10.3, 10.4, 10.5_

  - [ ] 10.3 Add API documentation
    - Configure Swagger UI at /docs
    - Configure ReDoc at /redoc
    - Add descriptions and examples to all endpoints
    - _Requirements: 10.1_

- [ ] 11. Configure CORS and security

  - [ ] 11.1 Add CORS middleware in /app/main.py

    - Configure allowed origins from environment variable
    - Set allowed methods (GET, POST, PUT, DELETE)
    - Set allowed headers
    - _Requirements: 11.1_

  - [ ] 11.2 Add security headers middleware

    - Add X-Content-Type-Options header
    - Add X-Frame-Options header
    - Add X-XSS-Protection header
    - _Requirements: 11.2_

  - [ ] 11.3 Add rate limiting middleware

    - Implement rate limiter (100 requests per minute per IP)
    - Add rate limit headers to responses
    - _Requirements: 11.3_

  - [ ] 11.4 Add request logging middleware

    - Log all requests with timestamp, method, path, status
    - Configure logging to file and console
    - _Requirements: 11.4_

  - [ ] 11.5 Create health check endpoint
    - Implement GET /healthcheck endpoint
    - Check database connection status
    - Return status, database status, and timestamp
    - _Requirements: 11.5_

- [ ] 12. Create database seeders

  - [ ] 12.1 Create user seeder in /app/seeders/user_seeder.py

    - Create sample admin user
    - Create sample regular users
    - Create sample guest user
    - _Requirements: 2.4_

  - [ ] 12.2 Create match seeder in /app/seeders/match_seeder.py

    - Create sample completed matches
    - Create sample ongoing matches
    - _Requirements: 2.4_

  - [ ] 12.3 Create tournament seeder in /app/seeders/tournament_seeder.py

    - Create sample tournament with fixtures
    - Create sample standings
    - _Requirements: 2.4_

  - [ ] 12.4 Create player seeder in /app/seeders/player_seeder.py

    - Create sample player profiles
    - Add sample statistics
    - _Requirements: 2.4_

  - [ ] 12.5 Create main seeder script
    - Create /app/seeders/seed.py to run all seeders
    - Add command to run seeders
    - _Requirements: 2.4_

- [ ] 13. Write tests

  - [ ] 13.1 Create test configuration in /tests/conftest.py

    - Set up test database
    - Create test client
    - Create fixtures for users, matches, tournaments
    - _Requirements: 12.1_

  - [ ] 13.2 Write authentication tests in /tests/test_auth.py

    - Test signup endpoint with valid data
    - Test signup with duplicate email
    - Test login with valid credentials
    - Test login with invalid credentials
    - Test guest user creation
    - Test token validation
    - _Requirements: 12.2_

  - [ ] 13.3 Write match tests in /tests/test_matches.py

    - Test match creation
    - Test ball event addition
    - Test match completion
    - Test match result calculation
    - _Requirements: 12.3_

  - [ ] 13.4 Write tournament tests in /tests/test_tournaments.py

    - Test tournament creation
    - Test fixture generation
    - Test standings calculation
    - Test guest user restriction
    - _Requirements: 12.3_

  - [ ] 13.5 Write statistics tests in /tests/test_statistics.py

    - Test statistics calculation from match
    - Test batting average calculation
    - Test bowling average calculation
    - Test milestone detection
    - _Requirements: 12.4_

  - [ ] 13.6 Run test coverage report
    - Run pytest with coverage
    - Verify 80%+ coverage
    - _Requirements: 12.5_

- [ ] 14. Create Docker configuration

  - [ ] 14.1 Create Dockerfile

    - Use Python 3.11 slim image
    - Copy requirements and install dependencies
    - Copy application code
    - Expose port 8000
    - Set CMD to run uvicorn
    - _Requirements: 1.5_

  - [ ] 14.2 Create docker-compose.yml

    - Define backend service
    - Define PostgreSQL service
    - Define volumes for database and uploads
    - Set environment variables
    - Configure networking
    - _Requirements: 1.5_

  - [ ] 14.3 Create .dockerignore
    - Exclude **pycache**, .env, venv, .git
    - _Requirements: 1.5_

- [ ] 15. Create documentation

  - [ ] 15.1 Update README.md

    - Add project description
    - Add setup instructions (local and Docker)
    - Add API documentation link
    - Add environment variables documentation
    - Add running tests instructions
    - _Requirements: 1.4_

  - [ ] 15.2 Create API_DOCUMENTATION.md

    - Document all endpoints with examples
    - Add Flutter Dio/http request examples
    - Add authentication flow examples
    - Add error response examples
    - _Requirements: 10.1_

  - [ ] 15.3 Create DEPLOYMENT.md
    - Add production deployment instructions
    - Add environment configuration guide
    - Add database migration guide
    - Add monitoring setup guide
    - _Requirements: 1.4_

- [ ] 16. Final integration and testing

  - [ ] 16.1 Test all endpoints manually

    - Test authentication flow
    - Test match creation and updates
    - Test tournament management
    - Test file uploads
    - Test guest user restrictions
    - _Requirements: 12.4_

  - [ ] 16.2 Verify CORS configuration

    - Test from Flutter web app
    - Verify preflight requests
    - _Requirements: 11.1_

  - [ ] 16.3 Performance testing

    - Test with multiple concurrent requests
    - Verify rate limiting
    - Check database query performance
    - _Requirements: 11.3_

  - [ ] 16.4 Create sample .env file
    - Create .env.example with all variables
    - Document each variable
    - _Requirements: 1.2_
