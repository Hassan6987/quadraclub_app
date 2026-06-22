import 'package:quadraclub_app/app_exports.dart';

class CustomActionButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onTap;
  final double? width;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color buttonTextColor;
  final TextStyle? buttonTextStyle;
  final Color? borderColor;
  final EdgeInsets margin;
  final double? height;
  final double borderRadius;
  final IconData? icon;
  final Color? iconColor;

  const CustomActionButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.width,
    this.isEnabled = true,
    this.backgroundColor = kPrimaryColor,
    this.buttonTextColor = kWhiteColor,
    this.buttonTextStyle,
    this.borderColor,
    this.margin = EdgeInsets.zero,
    this.height = 52,
    this.borderRadius = 100,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOutlined = borderColor != null;

    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: width,
        margin: margin,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: isOutlined
              ? backgroundColor?.withValues(alpha: 0.1)
              : (isEnabled
                    ? backgroundColor
                    : backgroundColor?.withValues(alpha: 0.5)),
          border: isOutlined ? Border.all(color: borderColor!, width: 1) : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(icon, color: iconColor ?? kSecondaryColor),
                ),
              Text(
                buttonText,
                style:
                    buttonTextStyle ??
                    AppStyles.w500f15inter.copyWith(
                      fontSize: 16,
                      color: isOutlined ? borderColor : buttonTextColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
