import '/app_exports.dart';

class RequestSentDialog extends StatelessWidget {
  const RequestSentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: kGreenColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: 48,
                color: kGreenColor,
              ),
            ),
            24.heightBox,
            
            // Title
            Text(
              'Request Sent!',
              style: AppStyles.w600f24inter.copyWith(color: kDarkTextColor),
            ),
            12.heightBox,
            
            // Message
            Text(
              'Your request to join the match has been sent successfully. You will be notified once the admin responds.',
              textAlign: TextAlign.center,
              style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
            ),
            24.heightBox,
            
            // OK button
            CustomActionButton(
              buttonText: "OK",
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
