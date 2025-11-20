import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'placeholder_tab.dart';
import 'randomizers/favorites_tab.dart';
import 'randomizers/randomizers_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: CupertinoColors.white.withOpacity(0.2),
      tabBar: CupertinoTabBar(
        backgroundColor: const Color.fromARGB(38, 13, 18, 29),
        activeColor: const Color(0xFFFF8A38),
        inactiveColor: const Color(0x66FFFFFF),
        border: Border(
          top: BorderSide(
            color: CupertinoColors.white.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shuffle_medium),
            label: 'Рандом',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart_fill),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.clock),
            label: 'История',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_crop_circle),
            label: 'Профиль',
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
            return const PlaceholderTab(title: 'История');
          case 3:
            return const PlaceholderTab(title: 'Профиль');
          default:
            return const RandomizersTab();
        }
      },
    );
  }
}
