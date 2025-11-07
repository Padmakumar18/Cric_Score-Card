"""
User and UserProfile Models

Handles user authentication and profile information including career statistics.
"""

from sqlalchemy import Column, String, Boolean, DateTime, Integer, Float, Date, Text, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid

from app.config.database import Base


class User(Base):
    """
    User model for authentication and account management.

    Attributes:
        id: Unique user identifier
        email: User email (unique)
        password_hash: Hashed password
        name: User's full name
        is_guest: Flag for guest users
        is_active: Account active status
        created_at: Account creation timestamp
        updated_at: Last update timestamp
    """
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(String(255), unique=True, nullable=False, index=True)
    password_hash = Column(String(255), nullable=False)
    name = Column(String(255), nullable=False)
    is_guest = Column(Boolean, default=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow,
                        onupdate=datetime.utcnow)

    # Relationships
    profile = relationship("UserProfile", back_populates="user",
                           uselist=False, cascade="all, delete-orphan")
    matches = relationship(
        "Match", back_populates="creator", cascade="all, delete-orphan")
    tournaments = relationship(
        "Tournament", back_populates="creator", cascade="all, delete-orphan")
    player_profiles = relationship(
        "PlayerProfile", back_populates="creator", cascade="all, delete-orphan")


class UserProfile(Base):
    """
    User profile model with personal details and cricket statistics.

    Attributes:
        id: Unique profile identifier
        user_id: Foreign key to User
        phone: Contact phone number
        address: Street address
        city: City name
        country: Country name
        date_of_birth: Date of birth
        role: Cricket role (Player, Coach, Umpire, Scorer, Fan)
        batting_style: Batting style (Right-hand, Left-hand)
        bowling_style: Bowling style (Right-arm fast, Left-arm spin, etc.)
        favorite_team: Favorite cricket team
        bio: Personal biography
        profile_image_url: URL to profile photo

        Career Statistics:
        matches_played: Total matches played
        total_runs: Career runs scored
        total_wickets: Career wickets taken
        batting_average: Batting average
        bowling_average: Bowling average
        centuries: Number of centuries (100+ runs)
        half_centuries: Number of half centuries (50+ runs)
        five_wicket_hauls: Number of 5-wicket hauls
        highest_score: Highest individual score
        best_bowling: Best bowling figures (e.g., "5/23")
    """
    __tablename__ = "user_profiles"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey(
        "users.id", ondelete="CASCADE"), unique=True, nullable=False)

    # Personal Information
    phone = Column(String(50))
    address = Column(Text)
    city = Column(String(100))
    country = Column(String(100))
    date_of_birth = Column(Date)
    role = Column(String(50))  # Player, Coach, Umpire, Scorer, Fan
    batting_style = Column(String(50))  # Right-hand, Left-hand
    bowling_style = Column(String(100))  # Right-arm fast, Left-arm spin, etc.
    favorite_team = Column(String(100))
    bio = Column(Text)
    profile_image_url = Column(String(500))

    # Career Statistics
    matches_played = Column(Integer, default=0)
    total_runs = Column(Integer, default=0)
    total_wickets = Column(Integer, default=0)
    batting_average = Column(Float, default=0.0)
    bowling_average = Column(Float, default=0.0)
    centuries = Column(Integer, default=0)
    half_centuries = Column(Integer, default=0)
    five_wicket_hauls = Column(Integer, default=0)
    highest_score = Column(Integer, default=0)
    best_bowling = Column(String(20))

    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow,
                        onupdate=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="profile")
