# Total Players Feature

## Overview

Added a configurable "Total Players per Team" field in match setup that determines when an innings ends based on the number of wickets fallen.

## Key Changes

### 1. Match Setup Screen

- **New Section**: "Team Size" section added between "Match Format" and "Toss Details"
- **Quick Selection**: Predefined options for 5, 7, 9, and 11 players
- **Custom Input**: Text field to enter any number between 2 and 11
- **Helper Text**: "Innings ends when (players - 1) wickets fall"

### 2. Match Model

- **New Field**: `totalPlayers` (default: 11)
- **Type**: `int`
- **Purpose**: Stores the total number of players per team

### 3. Innings Completion Logic

- **Dynamic Wickets**: Innings ends when `(totalPlayers - 1)` wickets fall
- **Example**:
  - 11 players → Innings ends at 10 wickets
  - 7 players → Innings ends at 6 wickets
  - 5 players → Innings ends at 4 wickets

## User Interface

### Team Size Section

```
┌─────────────────────────────────────┐
│  Team Size                          │
│                                     │
│  Total Players per Team             │
│                                     │
│  [5 players] [7 players]            │
│  [9 players] [11 players]           │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Enter custom number of players│  │
│  │ 11                            │  │
│  └───────────────────────────────┘  │
│  Innings ends when (players - 1)   │
│  wickets fall                       │
└─────────────────────────────────────┘
```

## Logic Examples

### Example 1: Standard 11-Player Match

- **Total Players**: 11
- **Max Wickets**: 10 (11 - 1)
- **Innings Ends**: When 10 wickets fall or overs complete

### Example 2: 7-Player Match

- **Total Players**: 7
- **Max Wickets**: 6 (7 - 1)
- **Innings Ends**: When 6 wickets fall or overs complete

### Example 3: 5-Player Match

- **Total Players**: 5
- **Max Wickets**: 4 (5 - 1)
- **Innings Ends**: When 4 wickets fall or overs complete

## Match Result Messages

The result messages now use the dynamic player count:

### Team Wins by Wickets

```
"[Team] won by [totalPlayers - 1 - wickets] wickets"
```

**Examples:**

- 11 players, 5 wickets down: "Team won by 5 wickets"
- 7 players, 3 wickets down: "Team won by 3 wickets"
- 5 players, 1 wicket down: "Team won by 3 wickets"

### Team Wins by Runs

```
"[Team] won by [run difference] runs"
```

(No change - same as before)

## Technical Implementation

### Files Modified

1. **app/lib/models/match.dart**

   - Added `totalPlayers` field (default: 11)
   - Updated `copyWith()` method

2. **app/lib/screens/match_setup_screen.dart**

   - Added `_totalPlayers` state variable
   - Added `_buildTeamSize()` method
   - Updated `_startMatch()` to pass totalPlayers

3. **app/lib/providers/match_provider.dart**
   - Updated `createMatch()` to accept totalPlayers
   - Updated `_checkInningsCompletion()` to use dynamic maxWickets

### Code Changes

#### Match Model

```dart
final int totalPlayers; // Total players per team

const Match({
  // ...
  this.totalPlayers = 11,
  // ...
});
```

#### Innings Completion Logic

```dart
final maxWickets = _currentMatch!.totalPlayers - 1;

if (currentInnings.wickets >= maxWickets) {
  shouldComplete = true;
}
```

## Validation

### Input Validation

- **Minimum**: 2 players (at least 1 wicket to fall)
- **Maximum**: 11 players (standard cricket)
- **Default**: 11 players
- **Type**: Integer only

### Edge Cases Handled

1. **Minimum Players**: With 2 players, innings ends after 1 wicket
2. **Maximum Players**: With 11 players, innings ends after 10 wickets
3. **Custom Values**: Any value between 2-11 is accepted

## Benefits

1. **Flexibility**: Supports different match formats (street cricket, school matches, etc.)
2. **Realistic**: Matches real cricket rules where innings ends at (n-1) wickets
3. **User-Friendly**: Quick selection chips for common values
4. **Clear Guidance**: Helper text explains the logic
5. **Dynamic Results**: Match result messages adapt to player count

## Use Cases

### Street Cricket (5-7 players)

- Shorter matches with fewer players
- Innings ends quickly when wickets fall
- Perfect for casual games

### School Matches (9 players)

- Balanced between full and street cricket
- Good for practice matches
- Manageable team sizes

### Standard Cricket (11 players)

- Official match format
- Full team composition
- Traditional cricket rules

## Testing Scenarios

1. **5-Player Match**

   - Set total players to 5
   - Verify innings ends at 4 wickets
   - Check result message shows correct wickets remaining

2. **7-Player Match**

   - Set total players to 7
   - Verify innings ends at 6 wickets
   - Check result message shows correct wickets remaining

3. **11-Player Match (Default)**

   - Use default 11 players
   - Verify innings ends at 10 wickets
   - Check result message shows correct wickets remaining

4. **Custom Value**
   - Enter custom value (e.g., 8)
   - Verify innings ends at 7 wickets
   - Check result message shows correct wickets remaining

## Future Enhancements

Potential improvements:

- Add validation for minimum 2 players
- Show live wickets remaining in UI
- Add preset match formats (T20, ODI, Test with different player counts)
- Allow different player counts for each team
- Add player substitution rules
