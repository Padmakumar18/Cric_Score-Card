# Cricket Scoreboard

A complete, modular, and production-quality Flutter application for managing cricket matches with live scoring, statistics, and match management.

## Features

### Core Functionality

- **Match Setup**: Configure team names, overs per innings, toss details
- **Live Scoreboard**: Real-time score updates with runs, wickets, overs
- **Ball-by-Ball Scoring**: Track every ball with runs, extras, wickets
- **Batting Statistics**: Individual batsman stats including runs, balls, 4s, 6s, strike rate
- **Bowling Statistics**: Bowler stats with overs, runs, wickets, economy rate
- **Extras Tracking**: Wides, no-balls, byes, leg-byes with proper ball counting
- **Wicket Management**: Record dismissals with type and new batsman selection
- **Over Management**: Automatic over completion and bowler change prompts

### UI/UX Features

- **Responsive Design**: Optimized for mobile, tablet, and web
- **Cricket Theme**: Professional green and saffron color scheme
- **Smooth Animations**: Subtle transitions for score updates
- **Accessibility**: Screen reader support and keyboard navigation
- **Touch-Friendly**: Large buttons and touch targets

### Technical Features

- **Clean Architecture**: Separated UI, state management, and models
- **State Management**: Provider pattern for scalable state handling
- **Type Safety**: Strong typed models for all cricket entities
- **Unit Tests**: Comprehensive test coverage for core logic
- **Modular Components**: Reusable widgets and clear separation of concerns

## Architecture

### State Management

This app uses the **Provider** pattern for state management, chosen for its:

- Simplicity and ease of use
- Excellent integration with Flutter
- Clear separation of business logic from UI
- Testability and maintainability

### Project Structure

```
lib/
├── constants/          # App constants and configuration
├── models/            # Data models (Match, Innings, Batsman, etc.)
├── providers/         # State management (MatchProvider)
├── screens/           # Main app screens
├── theme/             # App theme and styling
├── widgets/           # Reusable UI components
└── main.dart         # App entry point

test/
├── models/           # Unit tests for data models
└── widget_test.dart  # Widget tests
```

### Key Models

- **Match**: Complete match state with teams, innings, and status
- **Innings**: Single innings with batting/bowling statistics
- **Batsman**: Individual batsman statistics and status
- **Bowler**: Individual bowler statistics and figures
- **BallEvent**: Single ball event with runs, extras, wickets
- **Over**: Complete over with all balls and statistics

## Color Palette

The app uses a professional cricket-themed color scheme:

- **Primary Green**: `#1B5E20` - Deep cricket field green
- **Light Green**: `#4CAF50` - Accent green for positive actions
- **Pitch Tan**: `#D7CCC8` - Cricket pitch color for backgrounds
- **Accent Saffron**: `#FF9800` - Vibrant saffron for highlights
- **Dark Brown**: `#5D4037` - Earth tone for contrast
- **Error Red**: `#D32F2F` - For wickets and errors
- **Success Green**: `#388E3C` - For successful actions

## Setup Instructions

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
2. Navigate to the app directory:
   ```bash
   cd app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

### Running Tests

Execute unit tests:

```bash
flutter test
```

### Building for Production

- **Android**: `flutter build apk --release`
- **iOS**: `flutter build ios --release`
- **Web**: `flutter build web --release`

## Usage

### Starting a New Match

1. Launch the app (bypasses authentication as specified)
2. Tap "New Match" on the home screen
3. Enter team names and select match format
4. Configure toss details (winner and decision)
5. Tap "Start Match" to begin

### Live Scoring

1. The scoreboard shows current score, run rate, and statistics
2. Use scoring controls to record:
   - **Runs**: Tap 0, 1, 2, 3, 4, or 6
   - **Extras**: Wide, No Ball, Bye, Leg Bye
   - **Wickets**: Select dismissal type and add new batsman
   - **Actions**: Switch strike, add new batsman

### Match Management

- **Undo**: Remove last ball from the over
- **Reset**: Start fresh match (all data lost)
- **Edit**: Manual score correction (coming soon)

## Testing

The app includes comprehensive unit tests covering:

### Ball Event Logic

- Normal runs (0, 1, 2, 3, 4, 6)
- Extras (wides, no-balls, byes, leg-byes)
- Wickets with dismissal types
- Ball counting and over progression

### Batsman Statistics

- Run accumulation and ball counting
- Strike rate calculations
- Boundary counting (4s and 6s)
- Dismissal handling

### Bowler Statistics

- Over calculations (complete and partial)
- Economy rate calculations
- Wicket and run tracking
- Bowling restrictions

### Innings Management

- Score aggregation
- Run rate calculations
- Target and required run rate
- Current batsmen and bowler identification

Run tests with: `flutter test`

## Limitations & Future Enhancements

### Current Limitations

- **No Persistence**: All data is in-memory only
- **No Authentication**: UI-only login/signup screens
- **No Backend**: Pure client-side application
- **Basic Undo**: Simple last-ball removal only

### Planned Features

- Match history and statistics
- Advanced scoring features (partnerships, fall of wickets)
- Export scorecards and match reports
- Multi-format support (Test, ODI, T20)
- Player profiles and career statistics
- Live match sharing and commentary

## Dependencies

### Production Dependencies

- `flutter`: Flutter SDK
- `provider`: State management
- `google_fonts`: Typography
- `cupertino_icons`: iOS-style icons

### Development Dependencies

- `flutter_test`: Testing framework
- `flutter_lints`: Code analysis and linting

## Contributing

This is a demonstration project showcasing Flutter development best practices. The codebase is designed to be:

- **Maintainable**: Clear structure and documentation
- **Scalable**: Modular architecture for easy extension
- **Testable**: Comprehensive test coverage
- **Accessible**: Support for all users and devices

## License

This project is created for demonstration purposes and showcases modern Flutter development practices for cricket scoring applications.
