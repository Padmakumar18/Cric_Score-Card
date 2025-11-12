"""
Match, Innings, and BallEvent Models

Handles cricket match data, innings tracking, and ball-by-ball events.
"""

from sqlalchemy import Column, String, Integer, Float, Boolean, DateTime, Text, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid

from app.config.database import Base


class Match(Base):
    """
    Match model for cricket match information.

    Attributes:
        id: Unique match identifier
        created_by: User who created the match
        team1: First team name
        team2: Second team name
        overs_per_innings: Number of overs per innings
        total_players: Number of players per team
        toss_winner: Team that won the toss
        toss_decision: Toss decision (bat/bowl)
        status: Match status (not_started, first_innings, second_innings, completed)
        winner: Winning team name
        result: Match result description
        match_date: Date and time of match
    """
    __tablename__ = "matches"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    created_by = Column(UUID(as_uuid=True),
                        ForeignKey("users.id"), nullable=True)

    team1 = Column(String(100), nullable=False)
    team2 = Column(String(100), nullable=False)
    overs_per_innings = Column(Integer, nullable=False)
    total_players = Column(Integer, nullable=False)
    toss_winner = Column(String(100))
    toss_decision = Column(String(20))  # bat, bowl
    # not_started, first_innings, second_innings, completed
    status = Column(String(50), default="not_started")
    winner = Column(String(100))
    result = Column(Text)
    match_date = Column(DateTime, default=datetime.utcnow)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow,
                        onupdate=datetime.utcnow)

    # Relationships
    creator = relationship("User", back_populates="matches")
    innings = relationship(
        "Innings", back_populates="match", cascade="all, delete-orphan")
    tournament_matches = relationship(
        "TournamentMatch", back_populates="match", cascade="all, delete-orphan")


class Innings(Base):
    """
    Innings model for tracking innings data.

    Attributes:
        id: Unique innings identifier
        match_id: Foreign key to Match
        batting_team: Team batting in this innings
        bowling_team: Team bowling in this innings
        innings_number: Innings number (1 or 2)
        total_runs: Total runs scored
        wickets: Wickets fallen
        overs_completed: Overs completed (decimal, e.g., 19.4)
        extras: Extra runs (wides, no-balls, byes, leg-byes)
        is_complete: Whether innings is complete
    """
    __tablename__ = "innings"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    match_id = Column(UUID(as_uuid=True), ForeignKey(
        "matches.id", ondelete="CASCADE"), nullable=False)

    batting_team = Column(String(100), nullable=False)
    bowling_team = Column(String(100), nullable=False)
    innings_number = Column(Integer, nullable=False)  # 1 or 2
    total_runs = Column(Integer, default=0)
    wickets = Column(Integer, default=0)
    overs_completed = Column(Float, default=0.0)
    extras = Column(Integer, default=0)
    is_complete = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    match = relationship("Match", back_populates="innings")
    ball_events = relationship(
        "BallEvent", back_populates="innings", cascade="all, delete-orphan")


class BallEvent(Base):
    """
    BallEvent model for ball-by-ball tracking.

    Attributes:
        id: Unique ball event identifier
        innings_id: Foreign key to Innings
        over_number: Over number
        ball_number: Ball number in the over (1-6)
        batsman_name: Name of batsman on strike
        bowler_name: Name of bowler
        runs: Runs scored off this ball
        is_wicket: Whether a wicket fell
        wicket_type: Type of dismissal (bowled, caught, lbw, etc.)
        is_wide: Whether ball was a wide
        is_no_ball: Whether ball was a no-ball
        is_bye: Whether runs were byes
        is_leg_bye: Whether runs were leg-byes
    """
    __tablename__ = "ball_events"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    innings_id = Column(UUID(as_uuid=True), ForeignKey(
        "innings.id", ondelete="CASCADE"), nullable=False)

    over_number = Column(Integer, nullable=False)
    ball_number = Column(Integer, nullable=False)
    batsman_name = Column(String(100))
    bowler_name = Column(String(100))
    runs = Column(Integer, default=0)
    is_wicket = Column(Boolean, default=False)
    # bowled, caught, lbw, run_out, stumped, etc.
    wicket_type = Column(String(50))
    is_wide = Column(Boolean, default=False)
    is_no_ball = Column(Boolean, default=False)
    is_bye = Column(Boolean, default=False)
    is_leg_bye = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    innings = relationship("Innings", back_populates="ball_events")
