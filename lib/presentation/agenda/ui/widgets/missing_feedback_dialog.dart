import '/app_exports.dart';

class MissingFeedbackDialog extends StatelessWidget {
  final int missingCount;
  final VoidCallback onGiveFeedback;

  const MissingFeedbackDialog({
    super.key,
    required this.missingCount,
    required this.onGiveFeedback,
  });

  static Future<void> show(
    BuildContext context, {
    required int missingCount,
    required VoidCallback onGiveFeedback,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MissingFeedbackDialog(
        missingCount: missingCount,
        onGiveFeedback: onGiveFeedback,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  l10n.missingInformation,
                  style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    size: 22,
                    color: kDarkTextColor,
                  ),
                ),
              ],
            ).paddingOnly(top: 5, bottom: 16, left: 20, right: 20),
            const CommonDivider(),
            24.heightBox,
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: kLightColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_active_rounded,
                color: kSecondaryColor,
                size: 28,
              ),
            ),
            16.heightBox,
            Text(
              l10n.youHaveMatchesToComplete(missingCount),
              textAlign: TextAlign.center,
              style: AppStyles.w600f18inter.copyWith(
                color: kDarkTextColor,
                fontSize: 20,
              ),
            ).withPaddingSymmetric(24, 0),
            8.heightBox,
            Text(
              l10n.feedbackHelpsMatching,
              textAlign: TextAlign.center,
              style: AppStyles.w400f14inter.copyWith(color: kTextColor),
            ).withPaddingSymmetric(28, 0),
            24.heightBox,
            const CommonDivider(),
            16.heightBox,
            CustomActionButton(
              buttonText: l10n.giveFeedback,
              backgroundColor: kPrimaryColor,
              height: 48,
              onTap: () {
                Navigator.pop(context);
                onGiveFeedback();
              },
            ).withPaddingSymmetric(20, 0),
          ],
        ),
      ),
    );
  }
}
