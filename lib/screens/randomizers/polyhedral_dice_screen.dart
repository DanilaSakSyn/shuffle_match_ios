import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/app_settings.dart';
import '../../models/randomizer_favorites.dart';

class PolyhedralDiceScreen extends StatefulWidget {
  const PolyhedralDiceScreen({
    super.key,
    required this.title,
    required this.sides,
    required this.randomizerId,
  });

  final String title;
  final int sides;
  final String randomizerId;

  @override
  State<PolyhedralDiceScreen> createState() => _PolyhedralDiceScreenState();
}

class _PolyhedralDiceScreenState extends State<PolyhedralDiceScreen> {
  final Random _random = Random();
  int _value = 1;

  @override
  void initState() {
    super.initState();
    RandomizerFavorites.instance.ensureLoaded();
    AppSettings.instance.ensureLoaded();
  }

  void _roll() {
    if (AppSettings.instance.soundsEnabled.value) {
      SystemSound.play(SystemSoundType.click);
    }
    setState(() {
      _value = _random.nextInt(widget.sides) + 1;
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
                        widget.title,
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
                        final liked = favorites.contains(widget.randomizerId);
                        return CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 0,
                          onPressed: () => RandomizerFavorites.instance.toggle(
                            widget.randomizerId,
                          ),
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
                        'You rolled $_value',
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
                              child: Center(
                                child: Text(
                                  '$_value',
                                  style: const TextStyle(
                                    fontSize: 52,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
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
                          child: const Text('Roll dice'),
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

class DiceD4Screen extends StatelessWidget {
  const DiceD4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PolyhedralDiceScreen(
      title: 'D4 Dice',
      sides: 4,
      randomizerId: 'dice_d4',
    );
  }
}

class DiceD8Screen extends StatelessWidget {
  const DiceD8Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PolyhedralDiceScreen(
      title: 'D8 Dice',
      sides: 8,
      randomizerId: 'dice_d8',
    );
  }
}

class DiceD10Screen extends StatelessWidget {
  const DiceD10Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PolyhedralDiceScreen(
      title: 'D10 Dice',
      sides: 10,
      randomizerId: 'dice_d10',
    );
  }
}

class DiceD12Screen extends StatelessWidget {
  const DiceD12Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PolyhedralDiceScreen(
      title: 'D12 Dice',
      sides: 12,
      randomizerId: 'dice_d12',
    );
  }
}

class DiceD100Screen extends StatelessWidget {
  const DiceD100Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PolyhedralDiceScreen(
      title: 'D100 Dice',
      sides: 100,
      randomizerId: 'dice_d100',
    );
  }
}
