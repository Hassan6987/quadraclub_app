import '/app_exports.dart';

class CustomIconButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onTap;

  const CustomIconButton({super.key, this.isEnabled = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: isEnabled ? onTap : null,
      style: TextButton.styleFrom(
        backgroundColor: isEnabled
            ? const Color(0XFFC83333)
            : const Color(0XFFC4C4C4),
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(16),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      label: Text(
        "Reset",
        style: AppStyles.w500f15inter.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      icon: SvgPicture.asset(Assets.pngSplashLogo),
    );
  }
}
