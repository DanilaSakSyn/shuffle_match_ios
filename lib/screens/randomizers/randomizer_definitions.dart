import 'package:flutter/cupertino.dart';

import 'character_randomizer_screen.dart';
import 'color_randomizer_screen.dart';
import 'dice_randomizer_screen.dart';
import 'fortune_bar_screen.dart';
import 'polyhedral_dice_screen.dart';
import 'wheel_screen.dart';

class RandomizerDefinition {
  const RandomizerDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.builder,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final WidgetBuilder builder;
}

final randomizerDefinitions = [
  RandomizerDefinition(
    id: 'character_randomizer',
    title: 'Character Generator',
    description: 'Name, gender, age, and class',
    icon: CupertinoIcons.person_crop_circle_badge_plus,
    builder: (_) => const CharacterRandomizerScreen(),
  ),
  RandomizerDefinition(
    id: 'wheel',
    title: 'Wheel of Fortune',
    description: 'Classic wheel with prize segments',
    icon: CupertinoIcons.circle_grid_3x3_fill,
    builder: (_) => const WheelScreen(),
  ),
  RandomizerDefinition(
    id: 'fortune_bar',
    title: 'Fortune Bar',
    description: 'Linear picker powered by FortuneBar',
    icon: CupertinoIcons.slider_horizontal_3,
    builder: (_) => const FortuneBarScreen(),
  ),
  RandomizerDefinition(
    id: 'color_randomizer',
    title: 'Random Color',
    description: 'Color, HEX, and RGB',
    icon: CupertinoIcons.color_filter,
    builder: (_) => const ColorRandomizerScreen(),
  ),
  RandomizerDefinition(
    id: 'dice_d4',
    title: 'D4 Dice',
    description: 'Random number from 1 to 4',
    icon: CupertinoIcons.number_square,
    builder: (_) => const DiceD4Screen(),
  ),
  RandomizerDefinition(
    id: 'dice_d6',
    title: 'D6 Dice',
    description: 'Random number from 1 to 6',
    icon: CupertinoIcons.cube_box,
    builder: (_) => const DiceRandomizerScreen(),
  ),
  RandomizerDefinition(
    id: 'dice_d8',
    title: 'D8 Dice',
    description: 'Random number from 1 to 8',
    icon: CupertinoIcons.number_square,
    builder: (_) => const DiceD8Screen(),
  ),
  RandomizerDefinition(
    id: 'dice_d10',
    title: 'D10 Dice',
    description: 'Random number from 1 to 10',
    icon: CupertinoIcons.number_square,
    builder: (_) => const DiceD10Screen(),
  ),
  RandomizerDefinition(
    id: 'dice_d12',
    title: 'D12 Dice',
    description: 'Random number from 1 to 12',
    icon: CupertinoIcons.number_square,
    builder: (_) => const DiceD12Screen(),
  ),
  RandomizerDefinition(
    id: 'dice_d100',
    title: 'D100 Dice',
    description: 'Random number from 1 to 100',
    icon: CupertinoIcons.number_square,
    builder: (_) => const DiceD100Screen(),
  ),
];
