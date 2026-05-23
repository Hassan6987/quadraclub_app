import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

class CustomBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required Widget content,
    required String confirmText,
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: AppStyles.titleSemibold.copyWith(
                            color: kBlackColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 24),
                          onPressed: () => Navigator.pop(bottomSheetContext),
                        ),
                      ],
                    ),
                  ),
                  // Divider
                  const Divider(thickness: 1, height: 1, color: kTertiaryColor),
                  const SizedBox(height: 8),
                  Flexible(
                    child: SingleChildScrollView(
                      child: content.withPaddingSymmetric(20, 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1, height: 1, color: kTertiaryColor),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomActionButton(
                            onTap: () => Navigator.pop(bottomSheetContext),
                            buttonText: "Cancel",
                            borderColor: kTertiaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomActionButton(
                            onTap: onConfirm,
                            buttonText: confirmText,
                            backgroundColor: kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
