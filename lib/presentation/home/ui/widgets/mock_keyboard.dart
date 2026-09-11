import 'package:quadraclub_app/app_exports.dart';

class MockKeyboard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSend;

  const MockKeyboard({super.key, required this.controller, this.onSend});

  @override
  Widget build(BuildContext context) {
    final keyboardBgColor = const Color(0xFFD1D3D9);
    final keyBgColor = const Color(0xFFFFFFFF);
    final specialKeyBgColor = const Color(0xFFAFB3BD);
    final textColor = const Color(0xFF000000);

    Widget buildKey(
      String label, {
      double flex = 1,
      Color? bg,
      VoidCallback? onTap,
    }) {
      return Expanded(
        flex: (flex * 10).toInt(),
        child: GestureDetector(
          onTap:
              onTap ??
              () {
                controller.text += label;
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
            height: 42,
            decoration: BoxDecoration(
              color: bg ?? keyBgColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  offset: const Offset(0, 1),
                  blurRadius: 0.5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  fontFamily: 'SF Pro Text',
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget buildSpecialKey(
      Widget child, {
      double flex = 1,
      Color? bg,
      required VoidCallback onTap,
    }) {
      return Expanded(
        flex: (flex * 10).toInt(),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
            height: 42,
            decoration: BoxDecoration(
              color: bg ?? specialKeyBgColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  offset: const Offset(0, 1),
                  blurRadius: 0.5,
                ),
              ],
            ),
            child: Center(child: child),
          ),
        ),
      );
    }

    return Container(
      color: keyboardBgColor,
      padding: EdgeInsets.only(
        top: 8,
        left: 3,
        right: 3,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: QWERTYUIOP
          Row(
            children: [
              for (var key in [
                'Q',
                'W',
                'E',
                'R',
                'T',
                'Y',
                'U',
                'I',
                'O',
                'P',
              ])
                buildKey(key),
            ],
          ),
          // Row 2: ASDFGHJKL
          Row(
            children: [
              const Spacer(flex: 5),
              for (var key in ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'])
                buildKey(key),
              const Spacer(flex: 5),
            ],
          ),
          // Row 3: Shift, ZXCVBNM, Backspace
          Row(
            children: [
              buildSpecialKey(
                const Icon(Icons.arrow_upward, color: Colors.black, size: 18),
                flex: 1.2,
                bg: keyBgColor, // white shift key in iOS
                onTap: () {},
              ),
              for (var key in ['Z', 'X', 'C', 'V', 'B', 'N', 'M'])
                buildKey(key),
              buildSpecialKey(
                const Icon(
                  Icons.backspace_outlined,
                  color: Colors.black,
                  size: 18,
                ),
                flex: 1.2,
                onTap: () {
                  if (controller.text.isNotEmpty) {
                    controller.text = controller.text.substring(
                      0,
                      controller.text.length - 1,
                    );
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );
                  }
                },
              ),
            ],
          ),
          // Row 4: 123, space, Send
          Row(
            children: [
              buildKey('123', flex: 1.5, bg: specialKeyBgColor, onTap: () {}),
              buildSpecialKey(
                const Text(
                  'space',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                flex: 5.0,
                bg: keyBgColor,
                onTap: () {
                  controller.text += ' ';
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length),
                  );
                },
              ),
              buildKey('Send', flex: 1.5, bg: specialKeyBgColor, onTap: onSend),
            ],
          ),
          // Home Indicator Area spacing
          const SizedBox(height: 6),
          Center(
            child: Container(
              width: 140,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
