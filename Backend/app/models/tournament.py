"""
Tournament, TournamentMatch, and TournamentStanding Models

Handles tournament management, fixtures, and standings.
"""

from sqlalchemy import Column, String, Integer, Float, Boolean, DateTime, ForeignKey, ARRAY
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid

from app.config.database import Base


class Tournament(Base):
    """
    Tournament model for managing cricket tournaments.

    Attributes:
        id: Unique tournament identifier
        created_by: User who created the tournament
        name: Tournament name
        format: Tournament format (round_robin, knockout)
        teams: Array of team names
    """
    __tablename__ = "tournaments"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    created_by = Column(UUID(as_uuid=True), ForeignKey(
        "users.id"), nullable=False)

    name = Column(String(255), nullable=False)
    format = Column(String(50), nullable=False)  # round_robin, knockout
    teams = Column(ARRAY(String), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow,
                        onupdate=datetime.utcnow)

    # Relationships
    creator = relationship("User", back_populates="tournaments")
    tournament_matches = relationship(
        "TournamentMatch", back_populates="tournament", cascade="all, delete-orphan")
    standings = relationship(
        "TournamentStanding", back_populates="tournament", cascade="all, delete-orphan")


class TournamentMatch(Base):
    """
    TournamentMatch model linking tournaments to matches.

    Attributes:
        id: Unique tournament match identifier
        tournament_id: Foreign key to Tournament
        match_id: Foreign key to Match (nullable for scheduled matches)
        team1: First team name
        team2: Second team name
        scheduled_date: Scheduled match date
        is_complete: Whether match is complete
        winner: Winning team name
        team1_score: Team 1 final score
        team2_score: Team 2 final score
    """
    __tablename__ = "tournament_matches"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    tournament_id = Column(UUID(as_uuid=True), ForeignKey(
        "tournaments.id", ondelete="CASCADE"), nullable=False)
    match_id = Column(UUID(as_uuid=True), ForeignKey(
        "matches.id", ondelete="CASCADE"), nullable=True)

    team1 = Column(String(100), nullable=False)
    team2 = Column(String(100), nullable=False)
    scheduled_date = Column(DateTime)
    is_complete = Column(Boolean, default=False)
    winner = Column(String(100))
    team1_score = Column(Integer, default=0)
    team2_score = Column(Integer, default=0)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    tournament = relationship(
        "Tournament", back_populates="tournament_matches")
    match = relationship("Match", back_populates="tournament_matches")


class TournamentStanding(Base):
    """
    TournamentStanding model for tracking team standings.

    Attributes:
        id: Unique standing identifier
        tournament_id: Foreign key to Tournament
        team_name: Team name
        played: Matches played
        won: Matches won
        lost: Matches lost
        points: Total points
        net_run_rate: Net run rate
    """
    __tablename__ = "tournament_standings"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    tournament_id = Column(UUID(as_uuid=True), ForeignKey(
        "tournaments.id", ondelete="CASCADE"), nullable=False)

    team_name = Column(String(100), nullable=False)
    played = Column(Integer, default=0)
    won = Column(Integer, default=0)
    lost = Column(Integer, default=0)
    points = Column(Integer, default=0)
    net_run_rate = Column(Float, default=0.0)

    # Relationships
    tournament = relationship("Tournament", back_populates="standings")

    # Unique constraint
    __table_args__ = (
        {'schema': None},
    )
