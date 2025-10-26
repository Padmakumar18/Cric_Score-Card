# Extras Update - Enhanced Run Selection

## 🎯 What Changed?

Updated the extras buttons (Wide, No Ball, Byes, Leg Byes) to allow selecting the number of runs instead of automatically adding just 1 run.

## ✨ New Features

### 1. Wide Ball - Run Selection

**Before:** Clicking "Wide" automatically added 1 run
**Now:**

- Dialog appears with run options: 0, 1, 2, 3, 4
- "More runs..." option for 5+ runs
- Automatically switches strike on odd runs

### 2. No Ball - Run Selection

**Before:** Clicking "No Ball" automatically added 1 run
**Now:**

- Dialog appears with run options: 0, 1, 2, 3, 4
- "More runs..." option for 5+ runs
- Automatically switches strike on odd runs

### 3. Byes - Enhanced Options

**Updated:**

- Now shows options: 0, 1, 2, 3, 4
- Added "More runs..." option for 5+ runs
- Better layout with Wrap widget

### 4. Leg Byes - Enhanced Options

**Updated:**

- Now shows options: 0, 1, 2, 3, 4
- Added "More runs..." option for 5+ runs
- Better layout with Wrap widget

## 📱 User Experience

### Wide Ball Flow

```
1. Click "Wide" button
2. Dialog appears: "How many runs off the wide?"
3. Select: [0] [1] [2] [3] [4] or "More runs..."
4. If "More runs..." → Enter custom number
5. Runs added, strike switched if odd
```

### No Ball Flow

```
1. Click "No ball" button
2. Dialog appears: "How many runs off the no ball?"
3. Select: [0] [1] [2] [3] [4] or "More runs..."
4. If "More runs..." → Enter custom number
5. Runs added, strike switched if odd
```

### Byes/Leg Byes Flow

```
1. Click "Byes" or "Leg byes" button
2. Dialog appears: "How many byes/leg byes?"
3. Select: [0] [1] [2] [3] [4] or "More runs..."
4. If "More runs..." → Enter custom number
5. Runs added, strike switched if odd
```

## 🎨 Visual Improvements

### Button Layout

- Changed from Row to Wrap for better spacing
- Consistent button width (60px)
- Better alignment
- Color-coded buttons:
  - Wide: Yellow
  - No Ball: Yellow
  - Byes/Leg Byes: Orange

### More Runs Dialog

- Clean input field
- Number keyboard
- Validation for non-negative numbers
- Cancel and Add buttons

## 🔧 Technical Details

### Modified File

- `lib/widgets/modern_action_buttons.dart`

### New Methods Added

1. `_showWideDialog()` - Handle wide ball with run selection
2. `_showNoBallDialog()` - Handle no ball with run selection
3. `_showMoreRunsInput()` - Generic dialog for entering custom runs

### Updated Methods

1. `_showByesDialog()` - Enhanced with 0 option and "More runs"

### Key Features

- Automatic strike switching on odd runs
- Input validation
- Consistent UI across all extras
- Support for 0 runs (e.g., wide with no runs scored)

## 📊 Run Options

| Extra Type | Quick Options | More Runs | Strike Switch |
| ---------- | ------------- | --------- | ------------- |
| Wide       | 0, 1, 2, 3, 4 | Yes       | On odd runs   |
| No Ball    | 0, 1, 2, 3, 4 | Yes       | On odd runs   |
| Byes       | 0, 1, 2, 3, 4 | Yes       | On odd runs   |
| Leg Byes   | 0, 1, 2, 3, 4 | Yes       | On odd runs   |

## 💡 Use Cases

### Wide Ball Examples

- **Wide + 0 runs**: Ball goes wide, no runs scored
- **Wide + 1 run**: Ball goes wide, batsmen take 1 run
- **Wide + 4 runs**: Ball goes wide and reaches boundary
- **Wide + 5 runs**: Ball goes wide, batsmen run 5

### No Ball Examples

- **No Ball + 0 runs**: No ball called, no runs scored
- **No Ball + 1 run**: No ball, batsmen take 1 run
- **No Ball + 4 runs**: No ball hit for boundary
- **No Ball + 6 runs**: No ball hit for six

### Byes Examples

- **0 Byes**: Ball passes batsman, no runs
- **1 Bye**: Ball passes batsman, 1 run taken
- **4 Byes**: Ball passes batsman and reaches boundary

### Leg Byes Examples

- **0 Leg Byes**: Ball hits batsman, no runs
- **1 Leg Bye**: Ball hits batsman, 1 run taken
- **4 Leg Byes**: Ball hits batsman and reaches boundary

## 🎯 Benefits

### For Users

✅ **More accurate scoring** - Record exact runs off extras
✅ **Handles all scenarios** - From 0 to unlimited runs
✅ **Quick selection** - Common options readily available
✅ **Flexible input** - "More runs" for unusual cases
✅ **Automatic strike** - No manual switching needed

### For Scoring Accuracy

✅ **Wide boundaries** - Can record wide + 4 runs
✅ **No ball sixes** - Can record no ball + 6 runs
✅ **Multiple byes** - Can record any number of byes
✅ **Zero runs** - Can record extras with no runs

## 🔄 Comparison

### Before

```
Wide → Always 1 run
No Ball → Always 1 run
Byes → Choose 1, 2, 3, or 4
Leg Byes → Choose 1, 2, 3, or 4
```

### After

```
Wide → Choose 0, 1, 2, 3, 4, or More
No Ball → Choose 0, 1, 2, 3, 4, or More
Byes → Choose 0, 1, 2, 3, 4, or More
Leg Byes → Choose 0, 1, 2, 3, 4, or More
```

## 🧪 Testing Scenarios

### Test Wide Ball

1. Click Wide → Select 0 → Verify 1 extra run added (wide penalty)
2. Click Wide → Select 1 → Verify 2 total runs (1 wide + 1 run)
3. Click Wide → Select 4 → Verify 5 total runs (1 wide + 4 runs)
4. Click Wide → More runs → Enter 6 → Verify 7 total runs

### Test No Ball

1. Click No Ball → Select 0 → Verify 1 extra run added
2. Click No Ball → Select 1 → Verify 2 total runs
3. Click No Ball → Select 4 → Verify 5 total runs
4. Click No Ball → More runs → Enter 6 → Verify 7 total runs

### Test Byes

1. Click Byes → Select 0 → Verify 0 runs, ball counted
2. Click Byes → Select 1 → Verify 1 run, strike switched
3. Click Byes → Select 4 → Verify 4 runs, no strike switch
4. Click Byes → More runs → Enter 5 → Verify 5 runs

### Test Leg Byes

1. Click Leg Byes → Select 0 → Verify 0 runs, ball counted
2. Click Leg Byes → Select 1 → Verify 1 run, strike switched
3. Click Leg Byes → Select 4 → Verify 4 runs, no strike switch
4. Click Leg Byes → More runs → Enter 5 → Verify 5 runs

## 📝 Notes

### Important Points

- Wide and No Ball always add 1 penalty run + selected runs
- Byes and Leg Byes only add the selected runs (no penalty)
- All extras count as valid balls except Wide and No Ball
- Strike switches automatically on odd runs
- "More runs" option allows unlimited run input

### Cricket Rules Applied

- ✅ Wide = 1 penalty + runs scored
- ✅ No Ball = 1 penalty + runs scored
- ✅ Byes = Only runs scored
- ✅ Leg Byes = Only runs scored
- ✅ Wide/No Ball don't count as valid balls
- ✅ Byes/Leg Byes count as valid balls

## 🚀 How to Use

### Quick Scoring

1. Click the extras button (Wide, No Ball, Byes, Leg Byes)
2. Select the number of runs from quick options (0-4)
3. Done! Runs added and strike switched if needed

### Custom Runs

1. Click the extras button
2. Click "More runs..."
3. Enter the number of runs
4. Click "Add"
5. Done!

## ✅ Quality Assurance

- ✅ No compilation errors
- ✅ Flutter analyze: No issues
- ✅ All dialogs tested
- ✅ Strike switching verified
- ✅ Input validation working
- ✅ UI responsive

---

**Version:** 2.1 - Enhanced Extras Scoring
**Updated:** 2025
**File Modified:** `lib/widgets/modern_action_buttons.dart`
