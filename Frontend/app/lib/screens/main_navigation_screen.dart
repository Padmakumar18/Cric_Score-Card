import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'quick_match_screen.dart';
import 'tournament_screen.dart';
import 'match_browser_screen.dart';
import 'settings_screen.dart';

/// Main navigation screen with bottom navigation bar (Instagram-style)
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const QuickMatchScreen(),
    const TournamentScreen(),
    const MatchBrowserScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      body: Row(
        children: [
          // Side navigation for tablets and desktops
          if (isLargeScreen)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: IconThemeData(
                color: AppTheme.primaryGreen,
                size: 28,
              ),
              selectedLabelTextStyle: TextStyle(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
              unselectedIconTheme: const IconThemeData(
                color: Colors.grey,
                size: 24,
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.sports_cricket),
                  label: Text('Quick Match'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.emoji_events),
                  label: Text('Tournament'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.explore),
                  label: Text('Explore'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),

          // Main content
          Expanded(
            child: IndexedStack(index: _currentIndex, children: _screens),
          ),
        ],
      ),
      // Bottom navigation for mobile
      bottomNavigationBar: isLargeScreen
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.primaryGreen,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_cricket),
                  label: 'Quick Match',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.emoji_events),
                  label: 'Tournament',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
    );
  }
}
