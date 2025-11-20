import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/randomizer_favorites.dart';

class DiceRandomizerScreen extends StatefulWidget {
  const DiceRandomizerScreen({super.key});

  @override
  State<DiceRandomizerScreen> createState() => _DiceRandomizerScreenState();
}

class _DiceRandomizerScreenState extends State<DiceRandomizerScreen> {
  static const _randomizerId = 'dice_d6';

  final Random _random = Random();
  int _value = 1;

  @override
  void initState() {
    super.initState();
    RandomizerFavorites.instance.ensureLoaded();
  }

  void _roll() {
    setState(() {
      _value = _random.nextInt(6) + 1;
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
            colors: [Color(0xFF060910), Color(0xFF131A2A)],
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
                      minSize: 0,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: const Icon(
                          CupertinoIcons.left_chevron,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Бросок кубика',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                          minSize: 0,
                          onPressed: () => RandomizerFavorites.instance.toggle(_randomizerId),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: liked
                                    ? const Color(0xFFFF8A38)
                                    : Colors.white.withOpacity(0.08),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Выпало $_value',
                        style: const TextStyle(
                          fontSize: 22,
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
                              color: Colors.white.withOpacity(0.08),
                            ),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0x22FFFFFF), Color(0x33000000)],
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
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.02),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: _DiceFace(value: _value),
                              ),
                            ),
                          ),
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
                          onPressed: _roll,
                          child: const Text('Бросить кубик'),
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

class _DiceFace extends StatelessWidget {
  const _DiceFace({required this.value});

  final int value;

  static const Map<int, List<int>> _pipLayouts = {
    1: [4],
    2: [0, 8],
    3: [0, 4, 8],
    4: [0, 2, 6, 8],
    5: [0, 2, 4, 6, 8],
    6: [0, 2, 3, 5, 6, 8],
  };

  @override
  Widget build(BuildContext context) {
    final layout = _pipLayouts[value] ?? _pipLayouts[1]!;
    return Column(
      children: List.generate(3, (row) {
        return Expanded(
          child: Row(
            children: List.generate(3, (col) {
              final index = row * 3 + col;
              final visible = layout.contains(index);
              return Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: visible ? 1 : 0,
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF9C4A),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x55FF8A38),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
