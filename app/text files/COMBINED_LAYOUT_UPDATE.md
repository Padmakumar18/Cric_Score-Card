# Combined Layout Update

## Overview

Updated the scoreboard layout to combine related components into single containers for a cleaner, more organized appearance.

## Changes Made

### 1. Combined Players Card

**Before**: Batsmen and Bowler were in separate cards
**After**: Both are now in one unified card with a divider

#### Mobile Layout

- Single container with both sections
- Vertical layout (stacked)
- Divider line between batsmen and bowler
- Shared background and border

#### Tablet Layout

- Single container with both sections
- Horizontal layout (side by side)
- Vertical divider line between batsmen and bowler
- Shared background and border

#### Desktop Layout

- Single container with both sections
- Horizontal layout (side by side)
- Vertical divider line between batsmen and bowler
- Shared background and border

### 2. Combined Controls Card

**Before**: Actions and Score Runs were in separate cards
**After**: Both are now in one unified card with a divider

#### Mobile Layout

- Single container with both sections
- Vertical layout (stacked)
- Divider line between actions and score buttons
- Shared background and border

#### Tablet Layout

- Single container with both sections
- Horizontal layout (side by side)
- Vertical divider line between actions and score buttons
- Shared background and border

#### Desktop Layout

- Single container with both sections
- Vertical layout (stacked)
- Divider line between actions and score buttons
- Shared background and border

## Visual Structure

### Mobile Layout

```
┌─────────────────────────────────┐
│  Score Display                  │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│  Batsmen                        │
│  ─────────────────────────────  │
│  Bowler                         │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│  Actions                        │
│  ─────────────────────────────  │
│  Score Runs                     │
└─────────────────────────────────┘
```

### Tablet Layout

```
┌─────────────────────────────────┐
│  Score Display                  │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│  Batsmen  │  Bowler             │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│  Actions  │  Score Runs         │
└─────────────────────────────────┘
```

### Desktop Layout

```
┌─────────────────────────────────┐  ┌──────────────┐
│  Score Display                  │  │  Actions     │
└─────────────────────────────────┘  │  ──────────  │
                                     │  Score Runs  │
┌─────────────────────────────────┐  └──────────────┘
│  Batsmen  │  Bowler             │
└─────────────────────────────────┘
```

## Technical Implementation

### Files Modified

1. **app/lib/screens/scoreboard_screen.dart**

   - Added `_buildCombinedPlayersCard()` method
   - Added `_buildCombinedControlsCard()` method
   - Updated all three layout methods (mobile, tablet, desktop)

2. **app/lib/widgets/modern_batsmen_card.dart**

   - Removed individual card container
   - Changed to SizedBox (no background)

3. **app/lib/widgets/modern_bowler_card.dart**

   - Removed individual card container
   - Changed to SizedBox (no background)

4. **app/lib/widgets/modern_action_buttons.dart**

   - Removed individual card container
   - Changed to SizedBox (no background)

5. **app/lib/widgets/modern_score_buttons.dart**
   - Removed individual card container
   - Changed to SizedBox (no background)

### Container Specifications

#### Combined Players Card

```dart
Container(
  padding: EdgeInsets.all(16-20),
  decoration: BoxDecoration(
    color: AppTheme.cardBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppTheme.textTertiary.withValues(alpha: 0.3),
      width: 1,
    ),
  ),
)
```

#### Combined Controls Card

```dart
Container(
  padding: EdgeInsets.all(16-20),
  decoration: BoxDecoration(
    color: AppTheme.cardBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppTheme.textTertiary.withValues(alpha: 0.3),
      width: 1,
    ),
  ),
)
```

#### Dividers

- **Horizontal** (Mobile): `Divider` widget with 1px thickness
- **Vertical** (Tablet/Desktop): `Container` with 1px width and 200px height
- **Color**: `AppTheme.textTertiary` with 30% opacity

## Benefits

1. **Cleaner UI**: Fewer visual boundaries, less cluttered
2. **Better Organization**: Related components grouped together
3. **Improved Hierarchy**: Clear separation between different functional areas
4. **Consistent Styling**: Unified background and borders
5. **Space Efficient**: Reduced padding and margins
6. **Professional Look**: More polished and organized appearance

## Responsive Behavior

### Mobile (< 768px)

- Vertical stacking for all components
- Horizontal dividers between sections
- Compact padding (12-16px)

### Tablet (768px - 1200px)

- Horizontal layout for players (side by side)
- Horizontal layout for controls (side by side)
- Vertical dividers between sections
- Medium padding (16-20px)

### Desktop (>= 1200px)

- Horizontal layout for players (side by side)
- Vertical layout for controls (stacked)
- Appropriate dividers for each layout
- Full padding (20px)

## Visual Improvements

### Before

- 4 separate cards with individual backgrounds
- More visual noise from multiple borders
- Inconsistent spacing between related components
- More scrolling required on mobile

### After

- 2 combined cards with unified backgrounds
- Cleaner appearance with fewer borders
- Logical grouping of related components
- Less scrolling required on mobile
- More professional and organized look

## Testing Checklist

- [ ] Mobile layout displays correctly with vertical stacking
- [ ] Tablet layout displays correctly with horizontal arrangement
- [ ] Desktop layout displays correctly with mixed arrangement
- [ ] Dividers appear correctly in all layouts
- [ ] All components remain functional
- [ ] Responsive transitions work smoothly
- [ ] No visual glitches or overlapping elements
