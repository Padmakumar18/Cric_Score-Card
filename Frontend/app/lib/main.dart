import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/match_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize auth provider
  final authProvider = AuthProvider();
  await authProvider.init();

  runApp(CricketScoreboardApp(authProvider: authProvider));
}

class CricketScoreboardApp extends StatelessWidget {
  final AuthProvider authProvider;

  const CricketScoreboardApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
      ],
      child: Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, themeProvider, authProvider, child) {
          return MaterialApp(
            title: 'Cricket Scoreboard',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: authProvider.isAuthenticated
                ? const HomeScreen()
                : const AuthScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
