import 'package:flutter/cupertino.dart';

import 'randomizers/favorites_tab.dart';
import 'randomizers/randomizers_tab.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: const Color(0xFF3B0A21),
      tabBar: CupertinoTabBar(
        backgroundColor: const Color(0xFF3B0A21),
        activeColor: const Color(0xFFFF8A38),
        inactiveColor: const Color(0x66FFFFFF),
        border: const Border(
          top: BorderSide(color: Color(0x33FFFFFF), width: 0.5),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shuffle_medium),
              label: 'Random',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart_fill),
              label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gear_alt_fill),
              label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const RandomizersTab();
          case 1:
            return const FavoritesRandomizersTab();
          case 2:
            return const SettingsScreen();
          default:
            return const RandomizersTab();
        }
      },
    );
  }
}
