import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String leftButtonText;
  final String rightButtonText;
  final VoidCallback onButtonTap;
  final bool showCloseIcon;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.leftButtonText,
    required this.rightButtonText,
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
          content,
          20.heightBox,
          Divider(color: kTextColor, height: 1, thickness: 0.2),

          Row(
            children: [
              Expanded(
                child: CustomActionButton(
                  buttonText: leftButtonText,
                  borderColor: kSecondaryColor,
                  onTap: () {
                    context.pop();
                  },
                  height: 45,
                  backgroundColor: kSecondaryColor,
                ).withPaddingAll(12),
              ),
              Expanded(
                child: CustomActionButton(
                  buttonText: rightButtonText,
                  onTap: onButtonTap,
                  height: 45,
                  backgroundColor: kSecondaryColor,
                ).withPaddingAll(12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
