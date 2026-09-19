import '/app_exports.dart';

class RequestSentDialog extends StatelessWidget {
  const RequestSentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Center(
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kPrimaryColor, width: 10),
                ),
                child: const Icon(Icons.check, color: kBlackColor, size: 40),
              ),
            ),
            20.heightBox,

            // Title
            Text(
              l10n.requestSent,
              style: AppStyles.w600f18inter.copyWith(
                color: kDarkTextColor,
                fontSize: 20,
              ),
            ),
            8.heightBox,

            // Message
            Text(
              l10n.requestSentToOwner,
              textAlign: TextAlign.center,
              style: AppStyles.w500f14inter.copyWith(color: kTextColor),
            ),
            8.heightBox,
            Text(
              l10n.moneyBackIfNotAccepted,
              textAlign: TextAlign.center,
              style: AppStyles.w500f14inter.copyWith(color: kTextColor),
            ),
            8.heightBox,
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: l10n.viewMatchesAnytimeIn,
                    style: AppStyles.w500f14inter.copyWith(color: kTextColor),
                  ),
                  TextSpan(
                    text: ' ${l10n.agenda}.',
                    style: AppStyles.w500f14inter.copyWith(
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
            24.heightBox,

            // OK button
            CustomActionButton(
              buttonText: l10n.close,
              backgroundColor: kWhiteColor,
              borderColor: kBorderColor,
              height: 48,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
