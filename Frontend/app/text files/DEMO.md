# Cricket Scoreboard Demo

## Quick Start Guide

### 1. Launch the App

```bash
cd app
flutter run
```

The app will start and bypass authentication, taking you directly to the Home Screen.

### 2. Home Screen Features

- **Welcome Section**: Professional cricket-themed interface
- **New Match**: Start a fresh cricket match
- **Continue Match**: Resume current match (if available)
- **Match Status**: View current match progress

### 3. Creating a New Match

#### Step 1: Match Setup

1. Tap "New Match" from home screen
2. Enter team names (default: Team A vs Team B)
3. Select match format:
   - 5 overs (quick match)
   - 10 overs (practice)
   - 20 overs (T20 - default)
   - 50 overs (ODI)

#### Step 2: Toss Configuration

1. Select toss winner (Team A or Team B)
2. Choose toss decision:
   - **Bat First**: Winner bats first
   - **Bowl First**: Winner bowls first

#### Step 3: Start Match

- Tap "Start Match" to begin scoring

### 4. Live Scoreboard Interface

#### Score Header

- **Current Score**: Runs/Wickets (Overs)
- **Run Rate**: Current scoring rate
- **Required RR**: Required run rate (when chasing)
- **Projected Total**: Estimated final score
- **Extras**: Wide balls, no-balls, byes, leg-byes

#### Last 6 Balls Summary

- Visual representation of recent balls
- Color-coded for easy identification:
  - **Red**: Wicket
  - **Green**: Six
  - **Orange**: Four
  - **Blue**: Wide
  - **Purple**: No Ball
  - **Gray**: Dot ball
  - **Light Green**: Singles/doubles

#### Batting Section

- **Current Batsmen**: On-strike indicator
- **Live Stats**: Runs, balls, 4s, 6s, strike rate
- **Status**: Not out / dismissal type
- **Complete Statistics**: All batsmen performance

#### Bowling Section

- **Current Bowler**: Active bowler highlighted
- **Live Figures**: Overs, runs, wickets, economy
- **Change Bowler**: Switch bowler between overs
- **Complete Statistics**: All bowlers performance

### 5. Scoring Controls

#### Run Scoring

- **0, 1, 2, 3**: Regular runs
- **4**: Boundary (automatic four counter)
- **6**: Six (automatic six counter)

#### Extras

- **Wide**: Adds 1 run, doesn't count as ball
- **No Ball**: Adds 1 run, doesn't count as ball
- **Bye**: Runs without bat contact
- **Leg Bye**: Runs off body/pad

#### Special Actions

- **Wicket**: Record dismissal with type selection
- **Switch Strike**: Change batsman on strike
- **New Batsman**: Add replacement after dismissal

### 6. Advanced Features

#### Wicket Recording

1. Tap "Wicket" button
2. Select dismissal type:
   - Bowled, Caught, LBW, Run Out
   - Stumped, Hit Wicket, etc.
3. Add new batsman automatically

#### Over Management

- Automatic over completion after 6 valid balls
- Prompt for bowler change
- Strike rotation at over end

#### Match Controls

- **Undo**: Remove last ball (top menu)
- **Reset**: Start fresh match (confirmation required)
- **Edit**: Manual score correction (coming soon)

### 7. Responsive Design

#### Mobile Layout

- Vertical stack of all sections
- Touch-optimized controls
- Swipe-friendly interface

#### Tablet Layout

- Side-by-side batting/bowling sections
- Larger touch targets
- Enhanced readability

#### Desktop/Web Layout

- Three-column layout
- Scoring controls in sidebar
- Maximum information density

### 8. Sample Match Flow

#### Starting Innings

1. Create match: "Mumbai vs Chennai", 20 overs
2. Toss: Mumbai wins, chooses to bat
3. Opening batsmen: Player 1 (on strike), Player 2
4. Opening bowler: Bowler 1

#### Scoring Examples

1. **Dot Ball**: Tap "0" - no runs, ball count increases
2. **Single**: Tap "1" - 1 run, strike switches
3. **Boundary**: Tap "4" - 4 runs, boundary count increases
4. **Wide Ball**: Tap "Wide" - 1 extra run, ball count unchanged
5. **Wicket**: Tap "Wicket" → Select "Bowled" → Add new batsman

#### Over Completion

1. After 6 valid balls, over completes
2. Strike automatically switches
3. Prompt to change bowler
4. New over begins

#### Innings Completion

- **All Out**: 10 wickets fallen
- **Overs Complete**: 20 overs bowled
- **Target Achieved**: Chasing team reaches target

### 9. Key Statistics Tracked

#### Batsman Statistics

- Runs scored
- Balls faced
- Boundaries (4s and 6s)
- Strike rate (runs per 100 balls)
- Dismissal details

#### Bowler Statistics

- Overs bowled (including partial)
- Runs conceded
- Wickets taken
- Economy rate (runs per over)
- Maiden overs

#### Team Statistics

- Total runs and wickets
- Current run rate
- Required run rate (when chasing)
- Extras breakdown
- Partnership details

### 10. Professional Features

#### Color-Coded Interface

- **Green Theme**: Cricket field colors
- **Saffron Accents**: Professional highlights
- **Status Colors**: Clear visual feedback

#### Accessibility

- Large touch targets (48dp minimum)
- High contrast text
- Screen reader support
- Keyboard navigation (web)

#### Performance

- Smooth animations
- Instant score updates
- Responsive layout changes
- Memory-efficient state management

## Testing the App

### Unit Tests

```bash
flutter test
```

Tests cover:

- Ball event logic
- Batsman statistics
- Bowler calculations
- Innings management
- Score calculations

### Manual Testing Scenarios

#### Basic Scoring

1. Score various runs (0,1,2,3,4,6)
2. Verify strike rotation
3. Check statistics updates

#### Extras Handling

1. Bowl wides and no-balls
2. Verify ball count doesn't increase
3. Check extra runs added

#### Wicket Management

1. Record different dismissal types
2. Add new batsmen
3. Verify statistics

#### Over Management

1. Complete full overs
2. Change bowlers
3. Verify over calculations

This demo showcases a complete, professional cricket scoring application with all essential features for match management and live scoring.
