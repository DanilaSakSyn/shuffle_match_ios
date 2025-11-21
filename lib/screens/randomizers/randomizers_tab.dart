import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'randomizer_definitions.dart';

class RandomizersTab extends StatelessWidget {
  const RandomizersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final items = randomizerDefinitions;

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF3B0A21),
      child: Container(
        color: const Color(0xFF3B0A21),
        child: SafeArea(
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18,
              crossAxisSpacing: 18,
              childAspectRatio: 0.95,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () => Navigator.of(
                  context,
                ).push(CupertinoPageRoute(builder: item.builder)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xE6FF8A38), Color(0xF0FF5E1A)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x44FFB36B),
                        blurRadius: 22,
                        spreadRadius: 1,
                        offset: Offset(0, 16),
                      ),
                      BoxShadow(
                        color: Color(0x33FF5E1A),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.06),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33FFFFFF),
                                blurRadius: 14,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            item.icon,
                            size: 26,
                            color: const Color(0xFFFFF3E9),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            item.description,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: Colors.white.withOpacity(0.72),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

