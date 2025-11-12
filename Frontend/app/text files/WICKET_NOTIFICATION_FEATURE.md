# Wicket Notification Feature

## Overview

Added a real-time notification system that displays how a player got out immediately when a wicket falls. The notification appears as a prominent snackbar with dismissal details.

## Features

### 1. Automatic Wicket Detection

- Monitors when a wicket falls during the match
- Captures the batsman name and dismissal type
- Triggers notification automatically

### 2. Wicket Notification Display

- **Style**: Floating snackbar with red background
- **Icon**: Close/X icon in a circular badge
- **Title**: "WICKET!" in bold
- **Details**: Shows "[Batsman Name] - [Dismissal Type]"
- **Duration**: 4 seconds (auto-dismiss)
- **Action**: "OK" button to dismiss manually

### 3. Dismissal Information

Shows various dismissal types:

- Bowled
- Caught
- LBW (Leg Before Wicket)
- Stumped
- Run Out
- Hit Wicket
- And other dismissal types

## Visual Design

### Notification Appearance

```
┌─────────────────────────────────────┐
│  ⊗  WICKET!                    [OK] │
│     Player Name - Bowled            │
└─────────────────────────────────────┘
```

### Specifications

- **Background**: Error Red (`AppTheme.errorRed`)
- **Shape**: Rounded rectangle (12px radius)
- **Behavior**: Floating (appears above content)
- **Margin**: 16px from edges
- **Icon**: White close icon in semi-transparent circle
- **Text**: White color, bold title

## Technical Implementation

### Files Modified

1. **app/lib/providers/match_provider.dart**

   - Added `_lastWicketInfo` property
   - Added `lastWicketInfo` getter
   - Added `clearLastWicketInfo()` method
   - Updated `addBallEvent()` to capture wicket info
   - Updated `_updateInningsWithBall()` to mark batsman as out

2. **app/lib/screens/scoreboard_screen.dart**
   - Added `_lastShownWicket` state variable
   - Added wicket check in `_checkForDialogs()`
   - Added `_showWicketNotification()` method

### Logic Flow

```
1. Wicket occurs (user clicks wicket button)
   ↓
2. MatchProvider captures:
   - Batsman name
   - Dismissal type
   ↓
3. Batsman marked as out in innings
   ↓
4. lastWicketInfo set in provider
   ↓
5. Scoreboard screen detects change
   ↓
6. Notification displayed
   ↓
7. After 100ms, wicket info cleared
   ↓
8. Notification auto-dismisses after 4 seconds
```

## Code Details

### Wicket Info Capture

```dart
if (isWicket && wicketType != null) {
  final batsmanName = _currentMatch?.currentInnings?.strikerBatsman?.name ?? 'Batsman';
  _lastWicketInfo = '$batsmanName - $wicketType';
}
```

### Batsman Marked as Out

```dart
if (ball.isWicket) {
  updatedBatsman = updatedBatsman.markOut(ball.wicketType ?? 'out');
}
```

### Notification Display

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Row(...),
    backgroundColor: AppTheme.errorRed,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 4),
  ),
);
```

## User Experience

### When Wicket Falls

1. User clicks wicket button and selects dismissal type
2. Wicket is recorded in the match
3. Red notification slides in from bottom
4. Shows "WICKET!" with player name and dismissal type
5. User can:
   - Wait 4 seconds for auto-dismiss
   - Click "OK" to dismiss immediately
   - Continue scoring while notification is visible

### Notification Behavior

- **Non-blocking**: User can continue using the app
- **Floating**: Appears above content, doesn't push layout
- **Dismissible**: Can be swiped away or clicked to dismiss
- **Timed**: Auto-dismisses after 4 seconds

## Examples

### Example Notifications

#### Bowled

```
WICKET!
Virat Kohli - Bowled
```

#### Caught

```
WICKET!
Rohit Sharma - Caught
```

#### LBW

```
WICKET!
Steve Smith - LBW
```

#### Run Out

```
WICKET!
David Warner - Run Out
```

#### Stumped

```
WICKET!
MS Dhoni - Stumped
```

## Benefits

1. **Immediate Feedback**: Users instantly see how the wicket fell
2. **Clear Information**: Batsman name and dismissal type clearly displayed
3. **Non-Intrusive**: Doesn't block the UI or require interaction
4. **Professional**: Matches real cricket scoring apps
5. **Celebratory**: Red color and "WICKET!" text create excitement
6. **Informative**: Helps track match progress and key moments

## Integration with Scorecard

The dismissal information is also:

- Stored in the batsman model
- Displayed in the detailed scorecard
- Shown under each out batsman's name
- Used for match statistics

## Responsive Design

### Mobile

- Full width with 16px margins
- Compact icon and text
- Easy to dismiss with swipe

### Tablet/Desktop

- Centered with appropriate width
- Larger text for better visibility
- Same dismiss behavior

## Testing Scenarios

1. **Bowled Wicket**

   - Click wicket button
   - Select "Bowled"
   - Verify notification shows "[Name] - Bowled"

2. **Caught Wicket**

   - Click wicket button
   - Select "Caught"
   - Verify notification shows "[Name] - Caught"

3. **Run Out**

   - Click run out button
   - Select runs before run out
   - Verify notification shows "[Name] - Run Out"

4. **Multiple Wickets**

   - Get multiple wickets in succession
   - Verify each shows separate notification
   - Verify correct batsman name for each

5. **Notification Dismiss**
   - Wait 4 seconds for auto-dismiss
   - Click "OK" to dismiss manually
   - Swipe to dismiss

## Future Enhancements

Potential improvements:

- Add sound effect for wicket
- Add animation (ball hitting stumps, etc.)
- Show bowler name for bowling dismissals
- Add fielder name for catches
- Show wicket celebration animation
- Add wicket replay option
- Include match situation (score, overs)
- Add to match highlights
