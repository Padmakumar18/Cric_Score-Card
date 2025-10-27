# Quick Reference - New Features

## 🎯 What's New?

### 1. Pre-Match Player Setup

- Enter 2 opening batsmen + 1 opening bowler before match starts
- **Screen:** Player Setup (after Match Setup)

### 2. Auto New Batsman Prompt

- Dialog appears automatically when batsman gets out
- **Trigger:** Any wicket (Bowled, Caught, LBW, Run Out, etc.)

### 3. Auto New Bowler Prompt

- Dialog appears after 6 valid balls (over complete)
- Shows previous bowlers for quick selection
- **Trigger:** Over completion

### 4. Auto Innings Switch

- First innings summary + target display
- Enter second innings players
- **Trigger:** 10 wickets or overs complete

### 5. Current Over Display

- Real-time ball-by-ball visualization
- Color-coded indicators
- **Location:** Below main score

## 🎨 Color Codes (Current Over)

| Color          | Meaning              |
| -------------- | -------------------- |
| 🔴 Red         | Wicket (W)           |
| 🟢 Green       | Six (6)              |
| 🔵 Blue        | Four (4)             |
| 🟡 Yellow      | Wide/No Ball         |
| 🟠 Orange      | Byes/Leg Byes        |
| ⚫ Gray        | Dot Ball (0)         |
| 🟢 Light Green | Other Runs (1,2,3,5) |

## 📱 Quick Actions

### Scoring

- Tap 0-6 buttons for runs
- Odd runs auto-switch strike
- Use "More" for 7+ runs

### Wickets

1. Tap "Wicket"
2. Select type
3. Enter new batsman (auto-prompt)

### Over Complete

1. After 6 balls → Auto-prompt
2. Select previous bowler OR
3. Enter new bowler name

### Innings Switch

1. 10 wickets → Auto-prompt
2. View first innings summary
3. Enter second innings players

## 🔄 Match Flow

```
Match Setup
    ↓
Player Setup (NEW!)
    ↓
Scoreboard
    ↓
Score Runs → See Current Over (NEW!)
    ↓
Wicket → New Batsman Dialog (NEW!)
    ↓
Over Complete → New Bowler Dialog (NEW!)
    ↓
10 Wickets → Innings Switch (NEW!)
    ↓
Second Innings
    ↓
Match Complete
```

## 📋 Checklist for Starting Match

- [ ] Enter team names
- [ ] Set overs per innings
- [ ] Select toss winner & decision
- [ ] Click "Start Match"
- [ ] Enter Batsman 1 (on strike)
- [ ] Enter Batsman 2 (non-striker)
- [ ] Enter opening bowler
- [ ] Click "Start Innings"
- [ ] Begin scoring!

## 💡 Pro Tips

1. **Previous Bowlers**: Tap chips for instant selection
2. **Current Over**: Watch for over completion
3. **Validation**: All dialogs require valid input
4. **Undo**: Available if you make mistakes
5. **Strike**: Odd runs auto-switch, even runs don't

## 🐛 Common Issues

**Dialog won't close?**
→ Enter a valid player name

**Wrong bowler selected?**
→ Use Undo button

**Batsmen mixed up?**
→ Use "Swap striker" button

## 📁 Key Files

- `player_setup_screen.dart` - Pre-match setup
- `player_dialogs.dart` - All player prompts
- `current_over_display.dart` - Over visualization
- `scoreboard_screen.dart` - Main scoring screen

## 🚀 Run Commands

```bash
cd app
flutter pub get
flutter run
```

## 📖 Full Documentation

- **NEW_FEATURES.md** - Technical details
- **USAGE_GUIDE.md** - Complete user guide
- **IMPLEMENTATION_SUMMARY.md** - Development overview

---

**Version:** 2.0 with Dynamic Player Management
**Last Updated:** 2025
