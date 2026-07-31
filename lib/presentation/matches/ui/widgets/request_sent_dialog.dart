import '/app_exports.dart';

class RequestSentDialog extends StatelessWidget {
  const RequestSentDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Request Sent',
              style: AppStyles.w600f18inter.copyWith(
                color: kDarkTextColor,
                fontSize: 20,
              ),
            ),
            8.heightBox,

            // Message
            Text(
              'Your request was sent to the match owner. We\'ll notify you once it\'s approved.',
              textAlign: TextAlign.center,
              style: AppStyles.w500f14inter.copyWith(color: kTextColor),
            ),
            8.heightBox,
            Text(
              'If you’re not accepted, you will receive your money back automatically',
              textAlign: TextAlign.center,
              style: AppStyles.w500f14inter.copyWith(color: kTextColor),
            ),
            8.heightBox,
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        'View your pending, accepted, and past matches anytime in',
                    style: AppStyles.w500f14inter.copyWith(color: kTextColor),
                  ),
                  TextSpan(
                    text: ' Agenda.',
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
              buttonText: "Close",
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
