# Scorecard Feature

## Overview

Added a comprehensive scorecard view that displays detailed statistics for all batsmen and bowlers, including how players got out. A "View Scorecard" button has been added to the score display for easy access.

## New Features

### 1. View Scorecard Button

- **Location**: Top-right corner of the score display
- **Style**: Semi-transparent white button with icon
- **Icon**: List icon (Icons.list_alt)
- **Label**: "Scorecard"
- **Action**: Opens the detailed scorecard screen

### 2. Scorecard Screen

A comprehensive view showing:

- Match header (Team A vs Team B)
- First innings details
- Second innings details (if available)
- Complete batting and bowling statistics

## Scorecard Details

### Batting Section

Shows for each batsman:

- **Name**: Player name
- **R**: Runs scored
- **B**: Balls faced
- **4s**: Number of fours
- **6s**: Number of sixes
- **SR**: Strike rate
- **Status**:
  - "batting\*" for on-strike batsman
  - "batting" for non-striker
  - Dismissal info (e.g., "Bowled", "Caught", "LBW") for out players

### Bowling Section

Shows for each bowler:

- **Name**: Bowler name
- **O**: Overs bowled
- **M**: Maidens
- **R**: Runs conceded
- **W**: Wickets taken
- **Econ**: Economy rate

### Additional Information

- **Extras**: Total extras (wides, no balls, byes, leg byes)
- **Total**: Final score with wickets and overs

## Visual Design

### Button Specifications

```dart
ElevatedButton.icon(
  backgroundColor: Colors.white.withValues(alpha: 0.2),
  foregroundColor: Colors.white,
  borderRadius: BorderRadius.circular(6),
  height: 32-40px (responsive),
)
```

### Scorecard Layout

```
┌─────────────────────────────────┐
│  Team A vs Team B               │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│  First Innings                  │
│  Team A          145/5 (15.3 ov)│
│                                 │
│  BATTING                        │
│  ┌───────────────────────────┐  │
│  │ Name    R  B  4s 6s  SR   │  │
│  │ Player1 45 32  4  2  140  │  │
│  │ Bowled                    │  │
│  │ Player2 32 28  3  1  114  │  │
│  │ batting*                  │  │
│  └───────────────────────────┘  │
│                                 │
│  Extras: 8                      │
│  Total: 145/5 (15.3 ov)         │
│                                 │
│  BOWLING                        │
│  ┌───────────────────────────┐  │
│  │ Name    O  M  R  W  Econ  │  │
│  │ Bowler1 4  0  28 2  7.0   │  │
│  │ Bowler2 3.3 0 35 1  10.0  │  │
│  └───────────────────────────┘  │
└─────────────────────────────────┘
```

## Technical Implementation

### Files Created

1. **app/lib/screens/scorecard_screen.dart**
   - New screen for displaying detailed scorecard
   - Separate sections for batting and bowling
   - Responsive layout

### Files Modified

1. **app/lib/widgets/modern_score_display.dart**

   - Added "View Scorecard" button
   - Imported scorecard screen
   - Adjusted layout to accommodate button

2. **app/lib/models/batsman.dart**
   - Added `dismissalInfo` getter
   - Returns dismissal type for out players

## Button Positioning

### Layout Structure

```
┌─────────────────────────────────────┐
│  145/5  15.3/20    [Scorecard]     │
│         Overs                       │
└─────────────────────────────────────┘
```

- **Left**: Main score (runs/wickets and overs)
- **Right**: View Scorecard button

## Responsive Behavior

### Button Size

- **Small Mobile** (< 700px height): 32px height, 11px font
- **Mobile** (700-768px): 36px height, 12px font
- **Tablet/Desktop** (>= 768px): 40px height, 13px font

### Scorecard Layout

- **Mobile**: Single column, full width
- **Tablet**: Single column, centered with padding
- **Desktop**: Single column, centered with more padding

## Color Scheme

### Button

- **Background**: White with 20% opacity
- **Text**: White
- **Border Radius**: 6px

### Scorecard

- **Header**: Gradient (Primary Blue to Light Blue)
- **Cards**: Card Background with border
- **Batting Header**: Accent Blue
- **Bowling Header**: Success Green
- **Out Players**: Surface Dark background
- **Current Bowler**: Success Green with 10% opacity

## User Flow

1. User views the scoreboard
2. Clicks "View Scorecard" button in top-right
3. Scorecard screen opens showing:
   - Match header
   - First innings (if available)
   - Second innings (if available)
4. User can scroll to view all details
5. User taps back button to return to scoreboard

## Benefits

1. **Detailed Statistics**: Complete view of all players' performance
2. **Dismissal Information**: Shows how each batsman got out
3. **Easy Access**: One-tap access from main scoreboard
4. **Professional Look**: Clean, organized layout
5. **Complete History**: Shows all batsmen and bowlers, not just current ones
6. **Match Summary**: Quick overview of both innings

## Features Displayed

### For Each Batsman

- Runs scored
- Balls faced
- Boundaries (4s and 6s)
- Strike rate
- Dismissal type (if out)
- Current status (batting/batting\*/out)

### For Each Bowler

- Overs bowled
- Maidens
- Runs conceded
- Wickets taken
- Economy rate
- Current bowler indicator

### Match Totals

- Total runs
- Wickets fallen
- Overs bowled
- Extras
- Target (for second innings)

## Testing Checklist

- [ ] Button appears correctly on all screen sizes
- [ ] Button opens scorecard screen
- [ ] First innings data displays correctly
- [ ] Second innings data displays correctly (when available)
- [ ] Batting statistics are accurate
- [ ] Bowling statistics are accurate
- [ ] Dismissal information shows correctly
- [ ] Current batsmen marked as "batting"
- [ ] Current bowler highlighted
- [ ] Back button returns to scoreboard
- [ ] Layout is responsive on all devices

## Future Enhancements

Potential improvements:

- Add fall of wickets timeline
- Show partnership details
- Add over-by-over breakdown
- Include match graphs (run rate, worm chart)
- Export scorecard as PDF/image
- Share scorecard on social media
- Add player photos
- Show ball-by-ball commentary
