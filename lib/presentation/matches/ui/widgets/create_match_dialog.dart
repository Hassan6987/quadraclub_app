import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';

import '/app_exports.dart';

class CreateMatchDialog extends StatelessWidget {
  const CreateMatchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Row(
              children: [
                Text(
                  l10n.createMatch,
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
            ).paddingOnly(top: 5, bottom: 21, left: 20, right: 20),
            CommonDivider(),
            40.heightBox,

            // Title
            Text(
              l10n.wantToCreateMatch,
              style: AppStyles.w600f18inter.copyWith(
                color: kDarkTextColor,
                fontSize: 20,
              ),
            ),

            // Message
            Text(
              l10n.selectCourtToCreateMatch,
              textAlign: TextAlign.center,
              style: AppStyles.w400f14inter.copyWith(color: kTextColor),
            ).withPaddingSymmetric(20, 2),
            40.heightBox,
            CommonDivider(),
            16.heightBox,

            // OK button
            CustomActionButton(
              buttonText: l10n.selectCourt,
              backgroundColor: kPrimaryColor,
              height: 48,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.customBottomNavbar,
                  (_) => false,
                  arguments: {"index": 2, "bookingIntent": BookingType.match},
                );
              },
            ).withPaddingSymmetric(20, 0),
          ],
        ),
      ),
    );
  }
}
