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
    title: 'Генератор персонажа',
    description: 'Имя, пол, возраст и класс',
    icon: CupertinoIcons.person_crop_circle_badge_plus,
    builder: (_) => const CharacterRandomizerScreen(),
  ),
  RandomizerDefinition(
    id: 'wheel',
    title: 'Колесо удачи',
    description: 'Классический барабан с секторами',
    icon: CupertinoIcons.circle_grid_3x3_fill,
    builder: (_) => const WheelScreen(),
  ),
  RandomizerDefinition(
    id: 'fortune_bar',
    title: 'Полоса удачи',
    description: 'Линейный выбор с FortuneBar',
    icon: CupertinoIcons.slider_horizontal_3,
    builder: (_) => const FortuneBarScreen(),
  ),
  RandomizerDefinition(
    id: 'color_randomizer',
    title: 'Случайный цвет',
    description: 'Цвет, HEX и RGB',
    icon: CupertinoIcons.color_filter,
    builder: (_) => const ColorRandomizerScreen(),
  ),
  RandomizerDefinition(
    id: 'dice_d4',
    title: 'Кубик D-4',
    description: 'Случайное число от 1 до 4',
    icon: CupertinoIcons.number_square,
    builder: (_) => const DiceD4Screen(),
  ),
  RandomizerDefinition(
    id: 'dice_d6',
    title: 'Кубик D-6',
    description: 'Случайное число от 1 до 6',
    icon: CupertinoIcons.cube_box,
    builder: (_) => const DiceRandomizerScreen(),
  ),
  RandomizerDefinition(
    id: 'dice_d8',
    title: 'Кубик D-8',
    description: 'Случайное число от 1 до 8',
    icon: CupertinoIcons.number_square,
    builder: (_) => const DiceD8Screen(),
  ),
  RandomizerDefinition(
    id: 'dice_d10',
    title: 'Кубик D-10',
    description: 'Случайное число от 1 до 10',
    icon: CupertinoIcons.number_square,
    builder: (_) => const DiceD10Screen(),
  ),
  RandomizerDefinition(
    id: 'dice_d12',
    title: 'Кубик D-12',
    description: 'Случайное число от 1 до 12',
    icon: CupertinoIcons.number_square,
    builder: (_) => const DiceD12Screen(),
  ),
  RandomizerDefinition(
    id: 'dice_d100',
    title: 'Кубик D-100',
    description: 'Случайное число от 1 до 100',
    icon: CupertinoIcons.number_square,
    builder: (_) => const DiceD100Screen(),
  ),
];
