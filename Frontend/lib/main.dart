import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/match_provider.dart';
import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/match_setup_screen.dart';
import 'screens/view_scoreboard.dart';
import 'screens/scoreboard_screen.dart';
import 'screens/player_selection_screen.dart';
import 'screens/match_history_screen.dart';
import 'screens/statistics_screen.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CricketScoreboardApp());
}

class CricketScoreboardApp extends StatelessWidget {
  const CricketScoreboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => MatchProvider())],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (context, mode, _) {
          return MaterialApp(
            title: 'Cricket Scoreboard Pro',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
            initialRoute: '/',
            routes: {
              '/': (context) => const HomeScreen(),
              '/match-setup': (context) => const MatchSetupScreen(),
              '/player-selection': (context) => const PlayerSelectionScreen(),
              '/scoreboard': (context) => const ScoreboardScreen(),
              '/view-scoreboard': (context) => const ViewScoreBoard(),
              '/match-history': (context) => const MatchHistoryScreen(),
              '/statistics': (context) => const StatisticsScreen(),
            },
          );
        },
      ),
    );
  }
}
