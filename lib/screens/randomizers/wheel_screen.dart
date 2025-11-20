import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/randomizer_favorites.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({super.key});

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  static const _storageKey = 'wheel_segments';
  static const _randomizerId = 'wheel';
  static const _palette = [
    Color(0xFFFF8A38),
    Color(0xFFFF5E1A),
    Color(0xFFFFB36B),
    Color(0xFFFB7D2D),
    Color(0xFFFF9962),
  ];

  final StreamController<int> _selected = StreamController<int>.broadcast();
  final TextEditingController _controller = TextEditingController();
  List<String> _segments = ['Приз 1', 'Приз 2', 'Приз 3', 'Приз 4'];
  bool _spinning = false;

  bool get _hasMinimumSegments => _segments.length >= 2;

  @override
  void initState() {
    super.initState();
    RandomizerFavorites.instance.ensureLoaded();
    _restoreSegments();
  }

  Future<void> _restoreSegments() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_storageKey);
    if (saved != null && saved.isNotEmpty) {
      setState(() {
        _segments = saved;
      });
    }
  }

  Future<void> _persistSegments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, _segments);
  }

  void _addSegment() {
    final value = _controller.text.trim();
    if (value.isEmpty || _segments.contains(value)) return;
    setState(() {
      _segments = [..._segments, value];
    });
    _controller.clear();
    _persistSegments();
  }

  void _removeSegment(int index) {
    setState(() {
      _segments = List.of(_segments)..removeAt(index);
    });
    _persistSegments();
  }

  Future<void> _spin() async {
    if (!_hasMinimumSegments || _spinning) return;
    setState(() {
      _spinning = true;
    });
    _selected.add(Fortune.randomInt(0, _segments.length));
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    setState(() {
      _spinning = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _selected.close();
    super.dispose();
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
            colors: [Color(0xFF060910), Color(0xFF111725)],
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
                        'Колесо удачи',
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
                const SizedBox(height: 22),
                Expanded(
                  child: !_hasMinimumSegments
                      ? Center(
                          child: Text(
                            _segments.isEmpty
                                ? 'Добавьте минимум один сектор'
                                : 'Добавьте ещё один сектор',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                            ),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0x22000000), Color(0x33000000)],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33FF8A38),
                                blurRadius: 36,
                                offset: Offset(0, 28),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: FortuneWheel(
                              duration: const Duration(seconds: 3),
                              selected: _selected.stream,
                              indicators: const [
                                FortuneIndicator(
                                  alignment: Alignment.topCenter,
                                  child: TriangleIndicator(
                                    color: Color(0xFFFF8A38),
                                  ),
                                ),
                              ],
                              items: [
                                for (var i = 0; i < _segments.length; i++)
                                  FortuneItem(
                                    style: FortuneItemStyle(
                                      color: _palette[i % _palette.length],
                                      borderColor: const Color(0x99FFFFFF),
                                      borderWidth: 1.5,
                                    ),
                                    child: Text(
                                      _segments[i],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 22),
                CupertinoButton.filled(
                  onPressed: _hasMinimumSegments ? _spin : null,
                  child: Text(_spinning ? 'Крутится...' : 'Крутить'),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: _controller,
                        placeholder: 'Новый сектор',
                        style: const TextStyle(color: Colors.white),
                        cursorColor: const Color(0xFFFF8A38),
                        placeholderStyle: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1AFF8A38),
                              blurRadius: 18,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        onSubmitted: (_) => _addSegment(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      color: Colors.white.withOpacity(0.08),
                      onPressed: _addSegment,
                      child: const Text('Добавить'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: List.generate(
                        _segments.length,
                        (index) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x22FF8A38),
                                blurRadius: 16,
                                offset: Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _segments[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => _removeSegment(index),
                                child: const Icon(
                                  CupertinoIcons.clear_circled_solid,
                                  size: 18,
                                  color: Color(0xFFFF8A38),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
