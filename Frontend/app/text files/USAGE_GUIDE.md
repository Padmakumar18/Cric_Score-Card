# Cricket Scoreboard App - Usage Guide

## Quick Start Guide

### 1. Starting a New Match

1. **Launch the app** - You'll see the Match Setup screen
2. **Enter Team Details:**
   - Team 1 Name (e.g., "India")
   - Team 2 Name (e.g., "Australia")
3. **Select Match Format:**
   - Choose from preset options: 5, 10, 15, 20, 25, or 50 overs
   - Or enter a custom number of overs
4. **Toss Details:**
   - Select which team won the toss
   - Choose whether they elected to bat or bowl first
5. **Click "Start Match"**

### 2. Player Setup (NEW!)

After clicking Start Match, you'll be taken to the Player Setup screen:

1. **Enter Opening Batsmen:**
   - Batsman 1 (On Strike) - This player will face the first ball
   - Batsman 2 (Non-Striker) - This player will be at the other end
2. **Enter Opening Bowler:**
   - Bowler Name - The player who will bowl the first over
3. **Click "Start Innings"**

The scoreboard will now appear with your entered players!

### 3. Scoring During the Match

#### Basic Scoring

- **Tap run buttons** (0, 1, 2, 3, 4, 5, 6) to record runs
- **Odd runs** (1, 3, 5) automatically switch the strike
- **Even runs** (0, 2, 4, 6) keep the same batsman on strike

#### Special Deliveries

- **Wide**: Adds 1 run to extras, doesn't count as a ball
- **No Ball**: Adds 1 run to extras, doesn't count as a ball
- **Byes/Leg Byes**: Select number of runs (1-4), counts as a ball

#### Wickets

1. **Click "Wicket"** button
2. **Select dismissal type:**
   - Bowled
   - Caught
   - LBW
   - Stumped
   - Hit Wicket
3. **New Batsman Dialog appears automatically**
4. **Enter the new batsman's name**
5. **Click "Add Batsman"**

#### Run Outs

1. **Click "Run out"** button
2. **Select runs scored** before the run out (0, 1, 2, or 3)
3. **New Batsman Dialog appears automatically**
4. **Enter the new batsman's name**

### 4. Over Completion (NEW!)

When 6 valid balls are bowled:

1. **New Bowler Dialog appears automatically**
2. **Two options:**
   - **Quick Select**: Tap on any previous bowler's name chip
   - **New Bowler**: Enter a new bowler's name in the text field
3. **Click "Set Bowler"**
4. **New over begins**

**Note:** The same bowler cannot bowl consecutive overs (cricket rule)

### 5. Current Over Display (NEW!)

Watch the current over progress in real-time:

- **Located below the main score**
- **Shows up to 6 balls** with color-coded indicators:
  - 🔴 Red = Wicket (W)
  - 🟢 Green = Six (6)
  - 🔵 Blue = Four (4)
  - 🟡 Yellow = Wide (WD) or No Ball (NB)
  - 🟠 Orange = Byes/Leg Byes
  - ⚫ Gray = Dot ball (0)
  - 🟢 Light Green = Other runs (1, 2, 3, 5)
- **Shows total runs** scored in the current over

### 6. Innings Switch (NEW!)

When 10 wickets fall or overs are complete:

1. **First Innings Summary appears**
   - Shows final score
   - Displays target for second innings
2. **Enter Second Innings Players:**
   - Opening Batsman 1 (On Strike)
   - Opening Batsman 2 (Non-Striker)
   - Opening Bowler
3. **Click "Start Second Innings"**
4. **Second innings begins automatically**

### 7. Other Actions

#### Swap Strike

- **Use when:** Batsmen cross but you need to manually adjust
- **Click:** "Swap striker" button
- **Effect:** Changes which batsman is on strike

#### Undo Last Ball

- **Use when:** You made a mistake on the last ball
- **Click:** Undo button (top right or in Actions)
- **Effect:** Reverts the last ball and all its effects

#### Reset Match

- **Use when:** You want to start over
- **Click:** Reset button (top right)
- **Confirm:** Click "Reset" in the dialog
- **Effect:** Returns to home screen

## Tips for Best Experience

### Player Names

- Use clear, distinguishable names
- Avoid duplicate names
- Can use nicknames or jersey numbers

### Scoring Accuracy

- Score each ball immediately after it's bowled
- Use Undo if you make a mistake
- Double-check the current over display

### Over Management

- The app automatically prompts for new bowler after 6 balls
- Keep track of bowler overs if playing limited-overs format
- Previous bowlers list makes it easy to rotate bowlers

### Wicket Management

- Always enter the new batsman name immediately
- The app won't let you continue until a new batsman is added
- This ensures accurate player tracking

## Keyboard Shortcuts (Desktop)

While not implemented yet, future versions may include:

- Number keys (0-6) for quick scoring
- Space bar for dot ball
- W for wicket
- U for undo

## Troubleshooting

### Dialog Won't Close

- **Cause:** Required field not filled
- **Solution:** Enter a valid player name

### Wrong Bowler Selected

- **Solution:** Use Undo button, then select correct bowler

### Batsman Names Mixed Up

- **Solution:** Use "Swap striker" button to correct

### App Crashed/Closed

- **Note:** Match data is not persisted yet
- **Solution:** Restart match from beginning

## Match Completion

When the match ends:

- **Second innings complete** (all overs or 10 wickets)
- **Target achieved** (chasing team wins)
- **Result displayed** on screen
- **Options:** Reset to start new match

## Advanced Features

### Match Statistics

- View batsman stats: Runs, Balls, 4s, 6s, Strike Rate
- View bowler stats: Overs, Runs, Wickets, Economy
- Track match progress: Run rate, Required run rate

### Responsive Design

- **Mobile:** Vertical layout, easy thumb access
- **Tablet:** Two-column layout for better visibility
- **Desktop:** Three-column layout with all info visible

## Support

For issues or feature requests:

- Check NEW_FEATURES.md for latest updates
- Review code in lib/ directory
- Test on different screen sizes

Enjoy scoring your cricket matches! 🏏
