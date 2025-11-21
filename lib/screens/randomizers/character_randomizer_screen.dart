import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/character.dart';
import '../../models/randomizer_favorites.dart';

class CharacterRandomizerScreen extends StatefulWidget {
  const CharacterRandomizerScreen({super.key});

  @override
  State<CharacterRandomizerScreen> createState() =>
      _CharacterRandomizerScreenState();
}

class _CharacterRandomizerScreenState extends State<CharacterRandomizerScreen> {
  static const _randomizerId = 'character_randomizer';
  static const List<String> _genders = ['Male', 'Female'];
  static const List<String> _maleNames = [
    'Alexander',
    'Benjamin',
    'Caleb',
    'Daniel',
    'Ethan',
    'Felix',
    'Henry',
    'Isaac',
    'Jacob',
    'Liam',
    'Mason',
    'Nathan',
    'Oliver',
    'Parker',
    'Ryan',
    'Samuel',
    'Thomas',
    'William',
  ];
  static const List<String> _femaleNames = [
    'Amelia',
    'Ava',
    'Charlotte',
    'Diana',
    'Ella',
    'Grace',
    'Hannah',
    'Isabella',
    'Lily',
    'Maya',
    'Natalie',
    'Olivia',
    'Penelope',
    'Sophia',
    'Stella',
    'Victoria',
    'Zoe',
    'Scarlett',
  ];
  static const List<String> _lastNames = [
    'Anderson',
    'Bennett',
    'Campbell',
    'Dawson',
    'Ellis',
    'Foster',
    'Griffin',
    'Harper',
    'Irwin',
    'Jackson',
    'Kennedy',
    'Lawson',
    'Mitchell',
    'Nelson',
    'Owens',
    'Parker',
    'Quinn',
    'Reed',
    'Sawyer',
    'Turner',
    'Walker',
    'Young',
    'Baker',
    'Carter',
    'Dixon',
  ];
  static const List<String> _races = [
    'Human',
    'Elf',
    'Dwarf',
    'Orc',
    'Tiefling',
    'Dragonborn',
    'Gnome',
    'Half-Orc',
    'Half-Elf',
    'Halfling',
  ];
  static const List<String> _classes = [
    'Warrior',
    'Mage',
    'Rogue',
    'Cleric',
    'Ranger',
    'Bard',
    'Paladin',
    'Warlock',
    'Druid',
    'Monk',
    'Wizard',
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
    final firstNames = gender == 'Male' ? _maleNames : _femaleNames;
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
      backgroundColor: const Color(0xFF3B0A21),
      child: Container(
        color: const Color(0xFF3B0A21),
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
                        'Character Generator',
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
                          onPressed: () => RandomizerFavorites.instance.toggle(
                            _randomizerId,
                          ),
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
                              liked
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: liked
                                  ? const Color(0xFFFF8A38)
                                  : Colors.white,
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
                            _InfoRow(label: 'Gender', value: _current.gender),
                            const SizedBox(height: 16),
                            _InfoRow(label: 'Age', value: '${_current.age}'),
                            const SizedBox(height: 16),
                            _InfoRow(label: 'Race', value: _current.race),
                            const SizedBox(height: 16),
                            _InfoRow(label: 'Class', value: _current.gameClass),
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
                          child: const Text('New character'),
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
