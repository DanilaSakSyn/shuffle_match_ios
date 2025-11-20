import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/randomizer_favorites.dart';

class FortuneBarScreen extends StatefulWidget {
  const FortuneBarScreen({super.key});

  @override
  State<FortuneBarScreen> createState() => _FortuneBarScreenState();
}

class _FortuneBarScreenState extends State<FortuneBarScreen> {
  static const _storageKey = 'fortune_bar_values';
  static const _randomizerId = 'fortune_bar';

  final StreamController<int> _selected = StreamController<int>.broadcast();
  final TextEditingController _controller = TextEditingController();
  List<String> _values = ['Вариант 1', 'Вариант 2', 'Вариант 3'];
  bool _spinning = false;

  bool get _hasMinimumValues => _values.length >= 2;

  @override
  void initState() {
    super.initState();
    RandomizerFavorites.instance.ensureLoaded();
    _restoreValues();
  }

  Future<void> _restoreValues() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_storageKey);
    if (saved != null && saved.isNotEmpty) {
      setState(() {
        _values = saved;
      });
    }
  }

  Future<void> _persistValues() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, _values);
  }

  void _addValue() {
    final value = _controller.text.trim();
    if (value.isEmpty || _values.contains(value)) return;
    setState(() {
      _values = [..._values, value];
    });
    _controller.clear();
    _persistValues();
  }

  void _removeValue(int index) {
    setState(() {
      _values = List.of(_values)..removeAt(index);
    });
    _persistValues();
  }

  Future<void> _spin() async {
    if (!_hasMinimumValues || _spinning) return;
    setState(() {
      _spinning = true;
    });
    _selected.add(Fortune.randomInt(0, _values.length));
    await Future.delayed(const Duration(seconds: 3));
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
                    const Expanded(
                      child: Text(
                        'Полоса удачи',
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
                          minSize: 0,
                          onPressed: () => RandomizerFavorites.instance.toggle(
                            _randomizerId,
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
                SizedBox(
                  child: !_hasMinimumValues
                      ? Center(
                          child: Text(
                            _values.isEmpty
                                ? 'Добавьте минимум одно значение'
                                : 'Добавьте ещё одно значение',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsetsGeometry.symmetric(vertical: 30),
                          child: Container(
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
                                  color: Color(0x58FF8B38),
                                  blurRadius: 36,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            height: 140,
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: FortuneBar(
                                  height: 140,
                                  animateFirst: false,
                                  styleStrategy: UniformStyleStrategy(
                                    borderWidth: 5,
                                  ),
                                  selected: _selected.stream,
                                  duration: const Duration(seconds: 3),
                                  indicators: const [
                                    FortuneIndicator(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsetsGeometry.directional(
                                          start: 40,
                                          end: 40,
                                          top: 0,
                                          bottom: 80,
                                        ),
                                        child: TriangleIndicator(
                                          height: 10,
                                          width: 10,
                                          color: Color(0xFFFF8A38),
                                          elevation: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                  items: [
                                    for (var i = 0; i < _values.length; i++)
                                      FortuneItem(
                                        style: FortuneItemStyle(
                                          borderColor: Colors.white,
                                        ),
                                        child: Text(
                                          _values[i],
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
                        ),
                ),
                const SizedBox(height: 22),
                CupertinoButton.filled(
                  onPressed: _hasMinimumValues ? _spin : null,
                  child: Text(_spinning ? 'Выбираю...' : 'Выбрать'),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: _controller,
                        placeholder: 'Новое значение',
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
                        onSubmitted: (_) => _addValue(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      color: Colors.white.withOpacity(0.08),
                      onPressed: _addValue,
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
                        _values.length,
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
                                _values[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => _removeValue(index),
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
