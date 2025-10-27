# Match Result Dialog

## Overview

A celebratory dialog that appears automatically when the match is completed, showing the winner and providing a button to return to the home screen.

## Features

### 1. Automatic Display

- **Trigger**: Appears when match status becomes "completed"
- **Delay**: 800ms after match completion for dramatic effect
- **Prevention**: Uses `_hasShownResultDialog` flag to prevent duplicate dialogs
- **Non-dismissible**: User must click "Go to Home" button (cannot dismiss by tapping outside)

### 2. Visual Design

```
┌─────────────────────────────────────┐
│                                     │
│          🏆 (Trophy Icon)           │
│                                     │
│       Match Completed!              │
│                                     │
│  ┌───────────────────────────────┐  │
│  │                               │  │
│  │  Team A won by 5 wickets      │  │
│  │                               │  │
│  └───────────────────────────────┘  │
│                                     │
│    🎉 Congratulations! 🎉          │
│                                     │
│  ┌───────────────────────────────┐  │
│  │   🏠 Go to Home               │  │
│  └───────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

### 3. Result Messages

The dialog displays different messages based on match outcome:

#### Team Wins by Wickets (Second Batting Team Wins)

```
"[Team Name] won by [X] wickets"
```

Example: "India won by 5 wickets"

#### Team Wins by Runs (First Batting Team Wins)

```
"[Team Name] won by [X] runs"
```

Example: "Australia won by 25 runs"

#### Match Tied

```
"Match tied"
```

### 4. Dialog Components

#### Trophy Icon

- **Icon**: `Icons.emoji_events`
- **Size**: 48px
- **Color**: Success Green
- **Background**: Circular with light green background
- **Purpose**: Celebratory visual element

#### Title

- **Text**: "Match Completed!"
- **Font Size**: 24px
- **Weight**: Bold
- **Color**: Primary text color

#### Result Box

- **Background**: Light blue with transparency
- **Border**: Blue with transparency
- **Padding**: 16px
- **Border Radius**: 12px
- **Text Size**: 18px
- **Text Weight**: Semi-bold
- **Alignment**: Center

#### Congratulations Message

- **Text**: "🎉 Congratulations! 🎉"
- **Font Size**: 16px
- **Color**: Secondary text color
- **Alignment**: Center

#### Go to Home Button

- **Type**: Full-width elevated button with icon
- **Icon**: `Icons.home`
- **Background**: Primary Blue
- **Text**: "Go to Home"
- **Font Size**: 16px
- **Font Weight**: Bold
- **Padding**: 16px vertical
- **Border Radius**: 12px

### 5. User Actions

#### Go to Home Button

When clicked:

1. Resets the match (clears all match data)
2. Closes the result dialog
3. Navigates back to the home screen

## Technical Implementation

### State Management

```dart
bool _hasShownResultDialog = false;
```

- Prevents showing the dialog multiple times
- Reset when new match starts

### Dialog Check Logic

```dart
if (match.status == AppConstants.statusCompleted && !_hasShownResultDialog) {
  _hasShownResultDialog = true;
  _isDialogShowing = true;
  Future.delayed(const Duration(milliseconds: 800), () {
    if (mounted) {
      _showMatchResultDialog(context, match.result ?? 'Match completed');
    }
  });
  return;
}
```

### Match Completion Scenarios

#### Scenario 1: Second Batting Team Wins

- **Condition**: Second innings total runs >= target
- **Result**: "[Team] won by [10 - wickets] wickets"
- **Example**: If team chases 150 with 5 wickets down → "Team won by 5 wickets"

#### Scenario 2: First Batting Team Wins

- **Condition**: Second innings all out or overs complete with runs < target
- **Result**: "[Team] won by [run difference] runs"
- **Example**: If first team scores 180 and second team scores 155 → "Team won by 25 runs"

#### Scenario 3: Match Tied

- **Condition**: Both teams score exactly the same runs
- **Result**: "Match tied"

#### Scenario 4: Second Batting Team All Out

- **Condition**: 10 wickets fall before reaching target
- **Result**: "[First Team] won by [run difference] runs"
- **Example**: Target 150, all out at 120 → "First Team won by 30 runs"

## Color Scheme

- **Trophy Background**: `AppTheme.successGreen` with 20% opacity
- **Trophy Icon**: `AppTheme.successGreen`
- **Result Box Background**: `AppTheme.primaryBlue` with 10% opacity
- **Result Box Border**: `AppTheme.primaryBlue` with 30% opacity
- **Button Background**: `AppTheme.primaryBlue`
- **Button Text**: White
- **Dialog Background**: `AppTheme.cardBackground`

## Responsive Design

The dialog automatically adapts to different screen sizes:

- **Mobile**: Compact layout with appropriate padding
- **Tablet**: Slightly larger with more spacing
- **Desktop**: Optimal size with balanced proportions

## User Experience

### Timing

- **800ms delay**: Allows users to see the final score before the dialog appears
- **Smooth transition**: Creates a celebratory moment

### Non-dismissible

- **Intentional**: Ensures users acknowledge the match result
- **Clear action**: Single button makes next step obvious

### Navigation

- **Clean exit**: Resets match state and returns to home
- **No confusion**: Users can't accidentally stay on completed match screen

## Future Enhancements

Potential improvements:

- Add match statistics summary
- Show player of the match
- Display match highlights
- Add share match result option
- Include match replay option
- Show detailed scorecard
