import 'package:quadraclub_app/app_exports.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final double size;
  final TextStyle? labelStyle;

  const CustomRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.size = 20,
    this.labelStyle,
  });

  bool get _isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? kPrimaryColor;
    final inactive = inactiveColor ?? kDividerColor;

    return GestureDetector(
      onTap: () => onChanged(value),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: _isSelected ? active : inactive, width: 1),
        ),
        child: AnimatedScale(
          scale: _isSelected ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, color: active),
            ),
          ),
        ),
      ),
    );
  }
}
