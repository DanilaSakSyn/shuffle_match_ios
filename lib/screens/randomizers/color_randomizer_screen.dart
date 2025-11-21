import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/randomizer_favorites.dart';

class ColorRandomizerScreen extends StatefulWidget {
  const ColorRandomizerScreen({super.key});

  @override
  State<ColorRandomizerScreen> createState() => _ColorRandomizerScreenState();
}

class _ColorRandomizerScreenState extends State<ColorRandomizerScreen> {
  static const _randomizerId = 'color_randomizer';

  static const List<_ColorOption> _options = [
    _ColorOption(
      name: 'Scarlet',
      color: Color(0xFFFF3B30),
      hex: '#FF3B30',
      rgb: 'RGB(255, 59, 48)',
    ),
    _ColorOption(
      name: 'Orange',
      color: Color(0xFFFF9500),
      hex: '#FF9500',
      rgb: 'RGB(255, 149, 0)',
    ),
    _ColorOption(
      name: 'Gold',
      color: Color(0xFFFFCC00),
      hex: '#FFCC00',
      rgb: 'RGB(255, 204, 0)',
    ),
    _ColorOption(
      name: 'Lime',
      color: Color(0xFF34C759),
      hex: '#34C759',
      rgb: 'RGB(52, 199, 89)',
    ),
    _ColorOption(
      name: 'Emerald',
      color: Color(0xFF30D158),
      hex: '#30D158',
      rgb: 'RGB(48, 209, 88)',
    ),
    _ColorOption(
      name: 'Turquoise',
      color: Color(0xFF5AC8FA),
      hex: '#5AC8FA',
      rgb: 'RGB(90, 200, 250)',
    ),
    _ColorOption(
      name: 'Sky blue',
      color: Color(0xFF0A84FF),
      hex: '#0A84FF',
      rgb: 'RGB(10, 132, 255)',
    ),
    _ColorOption(
      name: 'Blue',
      color: Color(0xFF5856D6),
      hex: '#5856D6',
      rgb: 'RGB(88, 86, 214)',
    ),
    _ColorOption(
      name: 'Violet',
      color: Color(0xFFAF52DE),
      hex: '#AF52DE',
      rgb: 'RGB(175, 82, 222)',
    ),
    _ColorOption(
      name: 'Pink',
      color: Color(0xFFFF2D55),
      hex: '#FF2D55',
      rgb: 'RGB(255, 45, 85)',
    ),
    _ColorOption(
      name: 'Burgundy',
      color: Color(0xFFB00020),
      hex: '#B00020',
      rgb: 'RGB(176, 0, 32)',
    ),
    _ColorOption(
      name: 'Graphite',
      color: Color(0xFF1C1C1E),
      hex: '#1C1C1E',
      rgb: 'RGB(28, 28, 30)',
    ),
    _ColorOption(
      name: 'Lavender',
      color: Color(0xFFD1A9FF),
      hex: '#D1A9FF',
      rgb: 'RGB(209, 169, 255)',
    ),
    _ColorOption(
      name: 'Mint',
      color: Color(0xFF00C7BE),
      hex: '#00C7BE',
      rgb: 'RGB(0, 199, 190)',
    ),
  ];

  final Random _random = Random();
  late _ColorOption _current;

  @override
  void initState() {
    super.initState();
    RandomizerFavorites.instance.ensureLoaded();
    _current = _options[_random.nextInt(_options.length)];
  }

  void _shuffle() {
    setState(() {
      _current = _options[_random.nextInt(_options.length)];
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
                        'Random Color',
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
                        _current.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 28),
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 48),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33FF8A38),
                                blurRadius: 30,
                                offset: Offset(0, 24),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(color: _current.color),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ValueRow(label: 'HEX', value: _current.hex),
                            const SizedBox(height: 16),
                            _ValueRow(label: 'RGB', value: _current.rgb),
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
                          child: const Text('New color'),
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

class _ColorOption {
  const _ColorOption({
    required this.name,
    required this.color,
    required this.hex,
    required this.rgb,
  });

  final String name;
  final Color color;
  final String hex;
  final String rgb;
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.label, required this.value});

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
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
