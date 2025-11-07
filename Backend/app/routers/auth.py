"""
Authentication Router

Handles user authentication endpoints: signup, login, guest mode.
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from datetime import timedelta

from app.config.database import get_db
from app.config.settings import settings
from app.models.user import User, UserProfile
from app.schemas.auth import (
    SignupRequest,
    LoginRequest,
    AuthResponse,
    UserResponse
)
from app.utils.auth import (
    hash_password,
    verify_password,
    create_access_token,
    get_current_user
)

router = APIRouter()


@router.post("/signup", response_model=AuthResponse, status_code=status.HTTP_201_CREATED)
async def signup(request: SignupRequest, db: Session = Depends(get_db)):
    """
    Register a new user.

    Creates a new user account with email, password, and name.
    Also creates an associated user profile.
    """
    # Check if email already exists
    existing_user = db.query(User).filter(
        User.email == request.email.lower()).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )

    # Create new user
    new_user = User(
        email=request.email.lower(),
        password_hash=hash_password(request.password),
        name=request.name,
        is_guest=False,
        is_active=True
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    # Create user profile
    user_profile = UserProfile(user_id=new_user.id)
    db.add(user_profile)
    db.commit()

    # Generate access token
    access_token = create_access_token(
        data={"sub": str(new_user.id)},
        expires_delta=timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    )

    return AuthResponse(
        id=str(new_user.id),
        email=new_user.email,
        name=new_user.name,
        is_guest=new_user.is_guest,
        access_token=access_token,
        token_type="bearer"
    )


@router.post("/login", response_model=AuthResponse)
async def login(request: LoginRequest, db: Session = Depends(get_db)):
    """
    Login existing user.

    Authenticates user with email and password.
    """
    # Find user by email
    user = db.query(User).filter(User.email == request.email.lower()).first()

    if not user or not verify_password(request.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password"
        )

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Account is inactive"
        )

    # Generate access token
    access_token = create_access_token(
        data={"sub": str(user.id)},
        expires_delta=timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    )

    return AuthResponse(
        id=str(user.id),
        email=user.email,
        name=user.name,
        is_guest=user.is_guest,
        access_token=access_token,
        token_type="bearer"
    )


@router.post("/guest", response_model=AuthResponse)
async def guest_login(db: Session = Depends(get_db)):
    """
    Create guest user session.

    Creates a temporary guest user account.
    """
    import uuid
    from datetime import datetime

    # Create guest user
    guest_user = User(
        email=f"guest_{uuid.uuid4().hex[:8]}@cricket.app",
        password_hash=hash_password(str(uuid.uuid4())),
        name=f"Guest User",
        is_guest=True,
        is_active=True
    )

    db.add(guest_user)
    db.commit()
    db.refresh(guest_user)

    # Create user profile
    user_profile = UserProfile(user_id=guest_user.id)
    db.add(user_profile)
    db.commit()

    # Generate access token
    access_token = create_access_token(
        data={"sub": str(guest_user.id)},
        expires_delta=timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    )

    return AuthResponse(
        id=str(guest_user.id),
        email=guest_user.email,
        name=guest_user.name,
        is_guest=guest_user.is_guest,
        access_token=access_token,
        token_type="bearer"
    )


@router.get("/me", response_model=UserResponse)
async def get_current_user_info(current_user: User = Depends(get_current_user)):
    """
    Get current authenticated user information.

    Requires valid JWT token.
    """
    return UserResponse(
        id=str(current_user.id),
        email=current_user.email,
        name=current_user.name,
        is_guest=current_user.is_guest,
        is_active=current_user.is_active,
        created_at=current_user.created_at
    )
