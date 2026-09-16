import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/assets.dart';
import '../../language_provider.dart';

class LanguageToggleButton extends StatelessWidget {
  final double containerWidth;
  final double containerHeight;

  const LanguageToggleButton({
    super.key,
    this.containerWidth = 80,
    this.containerHeight = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final isArabic = languageProvider.isPortuguese;

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // EN label
              // Text(
              //   'EN',
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     color: !isArabic ? Colors.black : Colors.grey[500],
              //   ),
              // ),
              //
              // const SizedBox(width: 8),

              // Neumorphic pill container with depth
              GestureDetector(
                onTap: () => languageProvider.toggleLanguage(),
                child: Container(
                  width: containerWidth,
                  height: containerHeight,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFEEEEEE), Color(0xFFD6D6D6)],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFBEBEBE),
                        offset: Offset(4, 4),
                        blurRadius: 6,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4, -4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 300),
                        alignment: isArabic
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          width: containerHeight - 8,
                          height: containerHeight - 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              isArabic
                                  ? Assets.png.pt.path
                                  : Assets.png.uk.path,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // const SizedBox(width: 8),

              // AR label
              // Text(
              //   'AR',
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     color: isArabic ? Colors.black : Colors.grey[500],
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
