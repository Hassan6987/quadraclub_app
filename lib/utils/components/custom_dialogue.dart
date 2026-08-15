import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String buttonText;
  final VoidCallback onButtonTap;
  final bool showCloseIcon;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.onButtonTap,
    this.showCloseIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with title + close
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.titleSemibold.copyWith(color: kBlackColor),
                ),
              ),
              if (showCloseIcon)
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 22),
                ),
            ],
          ).withPaddingAll(20),
          20.heightBox,
          content,
          20.heightBox,
          Divider(color: kTextColor, height: 1, thickness: 0.2),

          CustomActionButton(
            buttonText: buttonText,
            onTap: onButtonTap,
            height: 45,
            backgroundColor: kSecondaryColor,
          ).withPaddingAll(12),
        ],
      ),
    );
  }
}
