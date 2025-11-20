import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/character.dart';
import '../../models/randomizer_favorites.dart';

class CharacterRandomizerScreen extends StatefulWidget {
  const CharacterRandomizerScreen({super.key});

  @override
  State<CharacterRandomizerScreen> createState() => _CharacterRandomizerScreenState();
}

class _CharacterRandomizerScreenState extends State<CharacterRandomizerScreen> {
  static const _randomizerId = 'character_randomizer';
  static const List<String> _genders = ['Мужчина', 'Женщина'];
  static const List<String> _maleNames = [
    'Андрей',
    'Борис',
    'Виктор',
    'Григорий',
    'Дмитрий',
    'Егор',
    'Илья',
    'Кирилл',
    'Леонид',
    'Максим',
    'Никита',
    'Олег',
    'Павел',
    'Роман',
    'Сергей',
    'Тимур',
    'Федор',
    'Юрий',
  ];
  static const List<String> _femaleNames = [
    'Алина',
    'Анна',
    'Валерия',
    'Дарья',
    'Екатерина',
    'Жанна',
    'Инна',
    'Карина',
    'Лидия',
    'Мария',
    'Наталья',
    'Ольга',
    'Полина',
    'Светлана',
    'Татьяна',
    'Ульяна',
    'Юлия',
    'Яна',
  ];
  static const List<String> _lastNames = [
    'Азаров',
    'Березин',
    'Воронов',
    'Громов',
    'Данилов',
    'Ершов',
    'Жуков',
    'Зимин',
    'Иванов',
    'Котов',
    'Лавров',
    'Медведев',
    'Николаев',
    'Орлов',
    'Панфилов',
    'Рыбаков',
    'Соколов',
    'Туров',
    'Устинов',
    'Фролов',
    'Харитонов',
    'Цветков',
    'Чернов',
    'Шестаков',
    'Юдин',
    'Яковлев',
  ];
  static const List<String> _races = [
    'Человек',
    'Эльф',
    'Дварф',
    'Орк',
    'Тифлинг',
    'Драконорожденный',
    'Гном',
    'Полуорк',
    'Полуэльф',
    'Халфлинг',
  ];
  static const List<String> _classes = [
    'Воин',
    'Маг',
    'Плут',
    'Жрец',
    'Следопыт',
    'Бард',
    'Паладин',
    'Чернокнижник',
    'Друид',
    'Монах',
    'Волшебник',
  ];

  final Random _random = Random();
  late Character _current;

  @override
  void initState() {
    super.initState();
    RandomizerFavorites.instance.ensureLoaded();
    _current = _generateCharacter();
  }

  Character _generateCharacter() {
    final gender = _genders[_random.nextInt(_genders.length)];
    final firstNames = gender == 'Мужчина' ? _maleNames : _femaleNames;
    final firstName = firstNames[_random.nextInt(firstNames.length)];
    final lastName = _lastNames[_random.nextInt(_lastNames.length)];
    final age = _random.nextInt(48) + 18;
    final race = _races[_random.nextInt(_races.length)];
    final gameClass = _classes[_random.nextInt(_classes.length)];
    return Character(
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      age: age,
      race: race,
      gameClass: gameClass,
    );
  }

  void _shuffle() {
    setState(() {
      _current = _generateCharacter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF05070D), Color(0xFF141C2E)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: const Icon(
                          CupertinoIcons.left_chevron,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Генератор персонажа',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ValueListenableBuilder<Set<String>>(
                      valueListenable: RandomizerFavorites.instance.favorites,
                      builder: (context, favorites, _) {
                        final liked = favorites.contains(_randomizerId);
                        return CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          onPressed: () => RandomizerFavorites.instance.toggle(_randomizerId),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: liked
                                    ? const Color(0xFFFF8A38)
                                    : Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Icon(
                              liked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                              color: liked ? const Color(0xFFFF8A38) : Colors.white,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_current.firstName} ${_current.lastName}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22FF8A38),
                              blurRadius: 26,
                              offset: Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _InfoRow(
                              label: 'Пол',
                              value: _current.gender,
                            ),
                            const SizedBox(height: 16),
                            _InfoRow(
                              label: 'Возраст',
                              value: '${_current.age}',
                            ),
                            const SizedBox(height: 16),
                            _InfoRow(
                              label: 'Раса',
                              value: _current.race,
                            ),
                            const SizedBox(height: 16),
                            _InfoRow(
                              label: 'Класс',
                              value: _current.gameClass,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),
                      Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x33FF8A38),
                              blurRadius: 24,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: CupertinoButton.filled(
                          onPressed: _shuffle,
                          child: const Text('Новый персонаж'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
