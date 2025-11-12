# Stat Chips Border Radius Update

## Overview

Reduced the border radius of the stat chips (Target, CRR, Players/RRR) in the score display for a more rectangular, modern appearance.

## Change Made

### Border Radius

- **Before**: `BorderRadius.circular(20)` - Very rounded, pill-shaped
- **After**: `BorderRadius.circular(6)` - Slightly rounded rectangle

### Visual Comparison

#### Before (Border Radius: 20)

```
┌──────────────┐
│   Target     │  ← Very rounded corners (pill shape)
│     180      │
└──────────────┘
```

#### After (Border Radius: 6)

```
┌─────────────┐
│   Target    │  ← Slightly rounded corners (rectangle)
│     180     │
└─────────────┘
```

## Affected Components

### Stat Chips in Score Display

1. **Target** - Shows target runs (second innings)
2. **CRR** - Current Run Rate
3. **Players** - Active players (first innings)
4. **RRR** - Required Run Rate (second innings)

## Technical Details

### File Modified

- `app/lib/widgets/modern_score_display.dart`

### Code Change

```dart
// Before
borderRadius: BorderRadius.circular(20),

// After
borderRadius: BorderRadius.circular(6),
```

### Location

- Method: `_buildStatChip()`
- Line: BoxDecoration in Container

## Visual Impact

### Benefits

1. **More Modern**: Rectangular chips look more contemporary
2. **Better Alignment**: Matches other UI elements with similar border radius
3. **Professional**: Less "bubbly", more serious appearance
4. **Consistent**: Aligns with card border radius (12-16px)
5. **Space Efficient**: Slightly more compact appearance

### Appearance

- Still has rounded corners (not sharp)
- More rectangular than pill-shaped
- Better visual balance with other components
- Maintains readability and clarity

## Consistency

### Border Radius Values Across App

- **Cards**: 12-16px (main containers)
- **Buttons**: 8-12px (action buttons)
- **Stat Chips**: 6px (small info badges) ← Updated
- **Dialogs**: 20px (modal windows)

## No Breaking Changes

- Only visual styling updated
- All functionality remains the same
- No impact on responsiveness
- No impact on data display

## Testing

- [x] Stat chips display correctly on mobile
- [x] Stat chips display correctly on tablet
- [x] Stat chips display correctly on desktop
- [x] Border radius looks appropriate at all sizes
- [x] No visual glitches or overlapping
