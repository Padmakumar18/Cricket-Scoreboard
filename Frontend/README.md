# Cricket Scoreboard Pro 🏏

A comprehensive, professional-grade cricket scoreboard application built with Flutter. This app provides real-time scoring, detailed statistics, and advanced features that set it apart from other cricket scoring apps.

## ✨ Unique Features

### 1. **Advanced Statistics Engine**

- Real-time player performance analytics
- Team statistics with win/loss tracking
- Top batsmen and bowlers leaderboards
- Strike rate, economy rate, and bowling average calculations
- Interactive charts and visualizations using FL Chart

### 2. **Comprehensive Match Management**

- Ball-by-ball commentary tracking
- Over-by-over breakdown
- Fall of wickets with detailed information
- Partnership tracking
- Extras management (wides, no-balls, byes, leg-byes)
- Multiple dismissal types (Bowled, Caught, LBW, Run Out, etc.)

### 3. **Match History & Persistence**

- Automatic match saving with SharedPreferences
- Browse past matches with filtering
- Detailed match summaries
- Resume interrupted matches
- Export match data (coming soon)

### 4. **Responsive Design**

- Optimized for mobile, tablet, and desktop
- Adaptive layouts based on screen size
- Touch-friendly scoring interface
- Dark and light theme support

### 5. **Professional UI/UX**

- Material Design 3
- Smooth animations with Flutter Animate
- Google Fonts integration
- Intuitive navigation
- Real-time score updates

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK (3.8.1 or higher)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/yourusername/cricket-scoreboard.git
cd cricket-scoreboard/Frontend
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run the app**

```bash
flutter run
```

4. **Run tests**

```bash
flutter test
```

## 📱 Features Overview

### Home Screen

- Quick access to new match setup
- Resume current match
- View match history
- Access statistics
- Theme toggle (Dark/Light mode)

### Match Setup

- Configure team names
- Set number of overs (1-50)
- Set players per team (6-15)
- Toss management
- Choose batting/bowling first

### Live Scoring

- **Run Scoring**: 0, 1, 2, 3, 4, 6 runs
- **Extras**: Wide, No Ball, Bye, Leg Bye
- **Wickets**: Multiple dismissal types with fielder tracking
- **Strike Management**: Easy strike rotation
- **Current Stats**: Live batsman and bowler statistics
- **Match Progress**: Real-time score, overs, run rate

### Scorecard View

- Detailed batting statistics
  - Runs, balls faced, fours, sixes
  - Strike rate
  - Dismissal information
- Bowling statistics
  - Overs, maidens, runs, wickets
  - Economy rate
- Fall of wickets timeline
- Partnership details

### Match History

- Chronological list of completed matches
- Filter by team
- Match summaries with results
- Quick access to detailed scorecards
- Delete individual matches
- Clear all history

### Statistics Dashboard

- **Overview Tab**
  - Total matches played
  - Total runs scored
  - Total wickets taken
  - Total boundaries (4s and 6s)
  - Runs trend chart
- **Top Batsmen Tab**
  - Ranked by total runs
  - Strike rate, fours, sixes
  - Highest score
  - Matches played
- **Top Bowlers Tab**
  - Ranked by total wickets
  - Economy rate
  - Bowling average
  - Best bowling figures

## 🏗️ Project Structure

```
Frontend/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   └── utils/
│   ├── models/
│   │   ├── match_models.dart
│   │   └── statistics_models.dart
│   ├── providers/
│   │   └── match_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── match_setup_screen.dart
│   │   ├── player_selection_screen.dart
│   │   ├── scoreboard_screen.dart
│   │   ├── view_scoreboard.dart
│   │   ├── match_history_screen.dart
│   │   └── statistics_screen.dart
│   ├── services/
│   │   ├── match_history_service.dart
│   │   └── statistics_service.dart
│   ├── widgets/
│   │   └── responsive_layout.dart
│   └── main.dart
├── test/
│   ├── models/
│   │   └── match_models_test.dart
│   ├── services/
│   │   └── statistics_service_test.dart
│   └── widget_test.dart
├── pubspec.yaml
└── README.md
```

## 🧪 Testing

The app includes comprehensive unit tests for:

- Match models (serialization, deserialization)
- Batsman statistics calculations
- Bowler statistics calculations
- Ball and over tracking
- Wicket management
- Statistics service
- Team and player analytics

**Run all tests:**

```bash
flutter test
```

**Run specific test suites:**

```bash
flutter test test/models
flutter test test/services
```

**Test Coverage:**

- ✅ 24+ unit tests
- ✅ Model validation
- ✅ Business logic
- ✅ Statistics calculations
- ✅ Data persistence

## 📦 Dependencies

### Core Dependencies

- **flutter**: SDK
- **provider**: ^6.1.1 - State management
- **shared_preferences**: ^2.2.2 - Local data persistence
- **google_fonts**: ^6.1.0 - Typography
- **flutter_animate**: ^4.5.0 - Animations
- **intl**: ^0.19.0 - Internationalization
- **fl_chart**: ^0.69.0 - Charts and graphs
- **share_plus**: ^10.1.2 - Sharing functionality
- **path_provider**: ^2.1.5 - File system access
- **pdf**: ^3.11.1 - PDF generation

### Dev Dependencies

- **flutter_test**: SDK
- **flutter_lints**: ^5.0.0 - Linting rules

## 🎨 Design Principles

1. **Material Design 3**: Modern, clean interface
2. **Responsive**: Works on all screen sizes
3. **Accessible**: High contrast, readable fonts
4. **Intuitive**: Easy to learn and use
5. **Fast**: Optimized performance
6. **Reliable**: Comprehensive error handling

## 🔄 State Management

The app uses **Provider** for state management with a centralized `MatchProvider` that handles:

- Match initialization
- Ball-by-ball recording
- Player statistics updates
- Innings management
- Data persistence
- Match completion logic

## 💾 Data Persistence

- **SharedPreferences** for lightweight data storage
- Automatic match saving after each ball
- Match history with up to 50 matches
- Resume capability for interrupted matches
- JSON serialization for complex objects

## 🎯 Roadmap

### Upcoming Features

- [ ] PDF scorecard export
- [ ] Match sharing via social media
- [ ] Cloud sync (Firebase)
- [ ] Multi-language support
- [ ] Voice commentary
- [ ] Live streaming integration
- [ ] Tournament management
- [ ] Player profiles
- [ ] Advanced analytics (wagon wheel, pitch map)
- [ ] Comparison tools
- [ ] Custom match formats (Test, ODI, T20)

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- Your Name - Initial work

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- Cricket community for feature suggestions
- Open source contributors

## 📞 Support

For support, email support@cricketscoreboard.com or open an issue on GitHub.

## 🐛 Known Issues

- Widget tests fail due to flutter_animate timers (unit tests pass)
- Windows Developer Mode required for symlink support

## 📊 Performance

- Smooth 60 FPS animations
- Instant ball recording
- Real-time statistics updates
- Minimal memory footprint
- Efficient data storage

## 🔐 Privacy

- All data stored locally on device
- No data collection or tracking
- No internet connection required
- Complete privacy and security

---

**Made with ❤️ and Flutter**
