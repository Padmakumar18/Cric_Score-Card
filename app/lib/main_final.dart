import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/match_provider.dart';
import 'screens/home_screen.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const CricketScoreboardApp());
}

class CricketScoreboardApp extends StatelessWidget {
  const CricketScoreboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MatchProvider(),
      child: MaterialApp(
        title: 'Cricket Scoreboard',
        theme: AppTheme.modernDarkTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
        // Add error handling
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
      ),
    );
  }
}
