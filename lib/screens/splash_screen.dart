import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../constants/app_info.dart';
import '../models/app_settings.dart';
import '../models/randomizer_favorites.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Запускаем анимацию
    _controller.forward();

    // Загружаем настройки и данные приложения
    await Future.wait([
      AppSettings.instance.ensureLoaded(),
      RandomizerFavorites.instance.ensureLoaded(),
    ]);

    // Минимальное время показа splash screen (для лучшего UX)
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    // Переход на главный экран
    Navigator.of(
      context,
    ).pushReplacement(CupertinoPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF3B0A21),
      child: Container(
        color: const Color(0xFF3B0A21),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Иконка приложения или логотип
                        Container(
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF8A38).withOpacity(0.4),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Image.asset('assets/icons/icon.webp'),
                        ),
                        const SizedBox(height: 200),

                        // Индикатор загрузки
                        const CupertinoActivityIndicator(
                          radius: 25,
                          color: Color(0xFFFF8A38),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
