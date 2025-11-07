"""
PlayerProfile Model

Handles player profile information and statistics.
"""

from sqlalchemy import Column, String, Integer, Float, Date, Text, DateTime, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid

from app.config.database import Base


class PlayerProfile(Base):
    """
    PlayerProfile model for managing cricket player profiles.

    Attributes:
        id: Unique player profile identifier
        created_by: User who created the profile
        name: Player's full name
        role: Cricket role (Batsman, Bowler, All-rounder, Wicket-keeper)
        batting_style: Batting style (Right-hand, Left-hand)
        bowling_style: Bowling style (Right-arm fast, Left-arm spin, etc.)
        date_of_birth: Date of birth
        team: Current team name
        nationality: Player's nationality

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

        notes: Additional notes about the player
        profile_image_url: URL to player photo
    """
    __tablename__ = "player_profiles"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    created_by = Column(UUID(as_uuid=True), ForeignKey(
        "users.id"), nullable=False)

    # Basic Information
    name = Column(String(255), nullable=False)
    # Batsman, Bowler, All-rounder, Wicket-keeper
    role = Column(String(50), nullable=False)
    batting_style = Column(String(50))  # Right-hand, Left-hand
    bowling_style = Column(String(100))  # Right-arm fast, Left-arm spin, etc.
    date_of_birth = Column(Date)
    team = Column(String(100))
    nationality = Column(String(100))

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

    # Additional Information
    notes = Column(Text)
    profile_image_url = Column(String(500))

    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow,
                        onupdate=datetime.utcnow)

    # Relationships
    creator = relationship("User", back_populates="player_profiles")
