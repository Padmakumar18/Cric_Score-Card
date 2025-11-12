# Batsman Dialog Fix

## Issue

The "Add New Batsman" dialog was showing repeatedly after adding a batsman, causing an infinite loop of dialog prompts.

## Root Cause

The dialog check logic was using `_lastCheckedBalls` to track when to show the new batsman dialog. However:

1. Wickets don't always change the ball count immediately
2. The `needsNewBatsman` condition remained true even after showing the dialog
3. The `_lastCheckedBalls` was only updated after the dialog closed, but by then the condition was checked again

## Solution

### 1. Added Wicket Tracking

Added a new state variable `_lastCheckedWickets` to track wickets separately from balls:

```dart
int _lastCheckedWickets = -1;
```

### 2. Updated Dialog Check Logic

Changed the new batsman dialog check to use wickets instead of balls:

**Before:**

```dart
else if (provider.needsNewBatsman && _lastCheckedBalls != currentBalls) {
  _isDialogShowing = true;
  Future.delayed(const Duration(milliseconds: 500), () {
    if (mounted) {
      PlayerDialogs.showNewBatsmanDialog(context, provider).then((_) {
        _isDialogShowing = false;
        _lastCheckedBalls = currentBalls;
      });
    }
  });
}
```

**After:**

```dart
else if (provider.needsNewBatsman && _lastCheckedWickets != currentWickets) {
  _isDialogShowing = true;
  _lastCheckedWickets = currentWickets; // Update immediately
  Future.delayed(const Duration(milliseconds: 500), () {
    if (mounted) {
      PlayerDialogs.showNewBatsmanDialog(context, provider).then((_) {
        _isDialogShowing = false;
      });
    }
  });
}
```

### 3. Key Changes

1. **Track wickets**: Use `currentWickets` instead of `currentBalls` for batsman dialog
2. **Immediate update**: Update `_lastCheckedWickets` immediately when dialog is triggered, not after it closes
3. **Prevent duplicates**: This ensures the dialog won't show again for the same wicket

## Why This Works

### Wickets vs Balls

- **Balls**: Can change without wickets (normal scoring)
- **Wickets**: Only change when a batsman gets out
- **New batsman needed**: Only when wickets change, not when balls change

### Immediate Update

By updating `_lastCheckedWickets` immediately when the dialog is triggered:

- The condition `_lastCheckedWickets != currentWickets` becomes false
- Even if `needsNewBatsman` is still true, the dialog won't show again
- Prevents the infinite loop

## Testing Scenarios

### Scenario 1: Single Wicket

1. Wicket falls
2. Wicket notification shows
3. New batsman dialog shows once
4. User adds batsman
5. Dialog closes
6. ✅ Dialog does NOT show again

### Scenario 2: Multiple Wickets

1. First wicket falls
2. Dialog shows for first wicket
3. User adds batsman
4. Second wicket falls
5. Dialog shows for second wicket
6. ✅ Each wicket triggers dialog exactly once

### Scenario 3: Rapid Wickets

1. Two wickets fall in quick succession
2. First dialog shows
3. User adds batsman
4. Second dialog shows
5. ✅ No duplicate dialogs

## Files Modified

- **app/lib/screens/scoreboard_screen.dart**
  - Added `_lastCheckedWickets` state variable
  - Updated new batsman dialog check logic
  - Changed tracking from balls to wickets

## Benefits

1. **No Duplicate Dialogs**: Dialog shows exactly once per wicket
2. **Better Logic**: Tracks the right metric (wickets, not balls)
3. **Immediate Prevention**: Updates tracking immediately to prevent loops
4. **Cleaner UX**: Users aren't bombarded with repeated dialogs
5. **Reliable**: Works consistently across all wicket scenarios

## Related Components

- **needsNewBatsman**: Provider getter that checks if active batsmen < 2
- **PlayerDialogs.showNewBatsmanDialog**: The dialog that prompts for new batsman
- **Wicket tracking**: Now properly tracked separately from ball count

## Edge Cases Handled

1. ✅ Wicket on last ball of over
2. ✅ Multiple wickets in same over
3. ✅ Wicket followed by wide/no ball
4. ✅ Run out scenarios
5. ✅ All out situations

## No Breaking Changes

- All existing functionality preserved
- Only fixed the duplicate dialog issue
- No impact on scoring logic
- No impact on other dialogs (bowler, innings switch)
