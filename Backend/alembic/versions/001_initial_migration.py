"""Initial migration - Create all tables

Revision ID: 001
Revises: 
Create Date: 2024-01-01 00:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = '001'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Create users table
    op.create_table('users',
                    sa.Column('id', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('email', sa.String(length=255), nullable=False),
                    sa.Column('password_hash', sa.String(
                        length=255), nullable=False),
                    sa.Column('name', sa.String(length=255), nullable=False),
                    sa.Column('is_guest', sa.Boolean(), nullable=True),
                    sa.Column('is_active', sa.Boolean(), nullable=True),
                    sa.Column('created_at', sa.DateTime(), nullable=True),
                    sa.Column('updated_at', sa.DateTime(), nullable=True),
                    sa.PrimaryKeyConstraint('id')
                    )
    op.create_index(op.f('ix_users_email'), 'users', ['email'], unique=True)

    # Create user_profiles table
    op.create_table('user_profiles',
                    sa.Column('id', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('user_id', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('phone', sa.String(length=50), nullable=True),
                    sa.Column('address', sa.Text(), nullable=True),
                    sa.Column('city', sa.String(length=100), nullable=True),
                    sa.Column('country', sa.String(length=100), nullable=True),
                    sa.Column('date_of_birth', sa.Date(), nullable=True),
                    sa.Column('role', sa.String(length=50), nullable=True),
                    sa.Column('batting_style', sa.String(
                        length=50), nullable=True),
                    sa.Column('bowling_style', sa.String(
                        length=100), nullable=True),
                    sa.Column('favorite_team', sa.String(
                        length=100), nullable=True),
                    sa.Column('bio', sa.Text(), nullable=True),
                    sa.Column('profile_image_url', sa.String(
                        length=500), nullable=True),
                    sa.Column('matches_played', sa.Integer(), nullable=True),
                    sa.Column('total_runs', sa.Integer(), nullable=True),
                    sa.Column('total_wickets', sa.Integer(), nullable=True),
                    sa.Column('batting_average', sa.Float(), nullable=True),
                    sa.Column('bowling_average', sa.Float(), nullable=True),
                    sa.Column('centuries', sa.Integer(), nullable=True),
                    sa.Column('half_centuries', sa.Integer(), nullable=True),
                    sa.Column('five_wicket_hauls',
                              sa.Integer(), nullable=True),
                    sa.Column('highest_score', sa.Integer(), nullable=True),
                    sa.Column('best_bowling', sa.String(
                        length=20), nullable=True),
                    sa.Column('created_at', sa.DateTime(), nullable=True),
                    sa.Column('updated_at', sa.DateTime(), nullable=True),
                    sa.ForeignKeyConstraint(
                        ['user_id'], ['users.id'], ondelete='CASCADE'),
                    sa.PrimaryKeyConstraint('id'),
                    sa.UniqueConstraint('user_id')
                    )

    # Create matches table
    op.create_table('matches',
                    sa.Column('id', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('created_by', postgresql.UUID(
                        as_uuid=True), nullable=True),
                    sa.Column('team1', sa.String(length=100), nullable=False),
                    sa.Column('team2', sa.String(length=100), nullable=False),
                    sa.Column('overs_per_innings',
                              sa.Integer(), nullable=False),
                    sa.Column('total_players', sa.Integer(), nullable=False),
                    sa.Column('toss_winner', sa.String(
                        length=100), nullable=True),
                    sa.Column('toss_decision', sa.String(
                        length=20), nullable=True),
                    sa.Column('status', sa.String(length=50), nullable=True),
                    sa.Column('winner', sa.String(length=100), nullable=True),
                    sa.Column('result', sa.Text(), nullable=True),
                    sa.Column('match_date', sa.DateTime(), nullable=True),
                    sa.Column('created_at', sa.DateTime(), nullable=True),
                    sa.Column('updated_at', sa.DateTime(), nullable=True),
                    sa.ForeignKeyConstraint(['created_by'], ['users.id'], ),
                    sa.PrimaryKeyConstraint('id')
                    )

    # Create innings table
    op.create_table('innings',
                    sa.Column('id', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('match_id', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('batting_team', sa.String(
                        length=100), nullable=False),
                    sa.Column('bowling_team', sa.String(
                        length=100), nullable=False),
                    sa.Column('innings_number', sa.Integer(), nullable=False),
                    sa.Column('total_runs', sa.Integer(), nullable=True),
                    sa.Column('wickets', sa.Integer(), nullable=True),
                    sa.Column('overs_completed', sa.Float(), nullable=True),
                    sa.Column('extras', sa.Integer(), nullable=True),
                    sa.Column('is_complete', sa.Boolean(), nullable=True),
                    sa.Column('created_at', sa.DateTime(), nullable=True),
                    sa.ForeignKeyConstraint(
                        ['match_id'], ['matches.id'], ondelete='CASCADE'),
                    sa.PrimaryKeyConstraint('id')
                    )

    # Create ball_events table
    op.create_table('ball_events',
                    sa.Column('id', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('innings_id', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('over_number', sa.Integer(), nullable=False),
                    sa.Column('ball_number', sa.Integer(), nullable=False),
                    sa.Column('batsman_name', sa.String(
                        length=100), nullable=True),
                    sa.Column('bowler_name', sa.String(
                        length=100), nullable=True),
                    sa.Column('runs', sa.Integer(), nullable=True),
                    sa.Column('is_wicket', sa.Boolean(), nullable=True),
                    sa.Column('wicket_type', sa.String(
                        length=50), nullable=True),
                    sa.Column('is_wide', sa.Boolean(), nullable=True),
                    sa.Column('is_no_ball', sa.Boolean(), nullable=True),
                    sa.Column('is_bye', sa.Boolean(), nullable=True),
                    sa.Column('is_leg_bye', sa.Boolean(), nullable=True),
                    sa.Column('created_at', sa.DateTime(), nullable=True),
                    sa.ForeignKeyConstraint(
                        ['innings_id'], ['innings.id'], ondelete='CASCADE'),
                    sa.PrimaryKeyConstraint('id')
                    )

    # Create tournaments table
    op.create_table('tournaments',
                    sa.Column('id', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('created_by', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('name', sa.String(length=255), nullable=False),
                    sa.Column('format', sa.String(length=50), nullable=False),
                    sa.Column('teams', postgresql.ARRAY(
                        sa.String()), nullable=False),
                    sa.Column('created_at', sa.DateTime(), nullable=True),
                    sa.Column('updated_at', sa.DateTime(), nullable=True),
                    sa.ForeignKeyConstraint(['created_by'], ['users.id'], ),
                    sa.PrimaryKeyConstraint('id')
                    )

    # Create tournament_matches table
    op.create_table('tournament_matches',
                    sa.Column('id', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('tournament_id', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('match_id', postgresql.UUID(
                        as_uuid=True), nullable=True),
                    sa.Column('team1', sa.String(length=100), nullable=False),
                    sa.Column('team2', sa.String(length=100), nullable=False),
                    sa.Column('scheduled_date', sa.DateTime(), nullable=True),
                    sa.Column('is_complete', sa.Boolean(), nullable=True),
                    sa.Column('winner', sa.String(length=100), nullable=True),
                    sa.Column('team1_score', sa.Integer(), nullable=True),
                    sa.Column('team2_score', sa.Integer(), nullable=True),
                    sa.Column('created_at', sa.DateTime(), nullable=True),
                    sa.ForeignKeyConstraint(
                        ['match_id'], ['matches.id'], ondelete='CASCADE'),
                    sa.ForeignKeyConstraint(
                        ['tournament_id'], ['tournaments.id'], ondelete='CASCADE'),
                    sa.PrimaryKeyConstraint('id')
                    )

    # Create tournament_standings table
    op.create_table('tournament_standings',
                    sa.Column('id', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('tournament_id', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('team_name', sa.String(
                        length=100), nullable=False),
                    sa.Column('played', sa.Integer(), nullable=True),
                    sa.Column('won', sa.Integer(), nullable=True),
                    sa.Column('lost', sa.Integer(), nullable=True),
                    sa.Column('points', sa.Integer(), nullable=True),
                    sa.Column('net_run_rate', sa.Float(), nullable=True),
                    sa.ForeignKeyConstraint(
                        ['tournament_id'], ['tournaments.id'], ondelete='CASCADE'),
                    sa.PrimaryKeyConstraint('id')
                    )

    # Create player_profiles table
    op.create_table('player_profiles',
                    sa.Column('id', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('created_by', postgresql.UUID(
                        as_uuid=True), nullable=False),
                    sa.Column('name', sa.String(length=255), nullable=False),
                    sa.Column('role', sa.String(length=50), nullable=False),
                    sa.Column('batting_style', sa.String(
                        length=50), nullable=True),
                    sa.Column('bowling_style', sa.String(
                        length=100), nullable=True),
                    sa.Column('date_of_birth', sa.Date(), nullable=True),
                    sa.Column('team', sa.String(length=100), nullable=True),
                    sa.Column('nationality', sa.String(
                        length=100), nullable=True),
                    sa.Column('matches_played', sa.Integer(), nullable=True),
                    sa.Column('total_runs', sa.Integer(), nullable=True),
                    sa.Column('total_wickets', sa.Integer(), nullable=True),
                    sa.Column('batting_average', sa.Float(), nullable=True),
                    sa.Column('bowling_average', sa.Float(), nullable=True),
                    sa.Column('centuries', sa.Integer(), nullable=True),
                    sa.Column('half_centuries', sa.Integer(), nullable=True),
                    sa.Column('five_wicket_hauls',
                              sa.Integer(), nullable=True),
                    sa.Column('highest_score', sa.Integer(), nullable=True),
                    sa.Column('best_bowling', sa.String(
                        length=20), nullable=True),
                    sa.Column('notes', sa.Text(), nullable=True),
                    sa.Column('profile_image_url', sa.String(
                        length=500), nullable=True),
                    sa.Column('created_at', sa.DateTime(), nullable=True),
                    sa.Column('updated_at', sa.DateTime(), nullable=True),
                    sa.ForeignKeyConstraint(['created_by'], ['users.id'], ),
                    sa.PrimaryKeyConstraint('id')
                    )


def downgrade() -> None:
    op.drop_table('player_profiles')
    op.drop_table('tournament_standings')
    op.drop_table('tournament_matches')
    op.drop_table('tournaments')
    op.drop_table('ball_events')
    op.drop_table('innings')
    op.drop_table('matches')
    op.drop_table('user_profiles')
    op.drop_index(op.f('ix_users_email'), table_name='users')
    op.drop_table('users')
