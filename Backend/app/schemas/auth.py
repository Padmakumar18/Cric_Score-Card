"""
Authentication Schemas

Pydantic models for authentication requests and responses.
"""

from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime


class SignupRequest(BaseModel):
    """Schema for user registration."""
    email: EmailStr
    password: str = Field(
        min_length=6, description="Password must be at least 6 characters")
    name: str = Field(min_length=1, description="User's full name")


class LoginRequest(BaseModel):
    """Schema for user login."""
    email: EmailStr
    password: str


class UserResponse(BaseModel):
    """Schema for user response."""
    id: str
    email: str
    name: str
    is_guest: bool
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True


class AuthResponse(BaseModel):
    """Schema for authentication response with token."""
    id: str
    email: str
    name: str
    is_guest: bool
    access_token: str
    token_type: str = "bearer"


class TokenData(BaseModel):
    """Schema for token payload data."""
    sub: str
    is_guest: bool = False
