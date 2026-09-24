import 'package:quadraclub_app/app_exports.dart';

class ClassBookedDialog extends StatelessWidget {
  const ClassBookedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: kWhiteColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          40.heightBox,

          CommonSuccessCheck(),

          20.heightBox,

          Text(
            l10n.classBooked,
            style: AppStyles.w600f18inter.copyWith(
              color: kDarkTextColor,
              fontSize: 20,
            ),
          ),

          8.heightBox,

          Text(
            l10n.classConfirmedMessage,
            textAlign: TextAlign.center,
            style: AppStyles.w400f14inter.copyWith(color: kTextColor),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.whatHappensNext,
                textAlign: TextAlign.center,
                style: AppStyles.w600f18inter.copyWith(
                  color: kBlackColor,
                  fontSize: 14,
                ),
              ),
              10.heightBox,
              buildRow(l10n.coachReviewsYourRequest,Icons.access_time, kOrangeColor),
              5.heightBox,
              buildRow(l10n.ifAcceptedSpotConfirmedChatAccess,Icons.check_circle_outline, kGreenColor),
              5.heightBox,
              buildRow(l10n.ifDeclinedAutomaticFullRefund,Icons.wallet_travel, kRedColor),
            ],
          ).withPaddingSymmetric(20, 20),


          CommonDivider(),

          16.heightBox,

          CustomActionButton(
            buttonText: l10n.viewMyClasses,
            backgroundColor: kWhiteColor,
            borderColor: kBorderColor,
            onTap: () {
              context.pop();
            },
          ).withPaddingSymmetric(24, 0),

          16.heightBox,
        ],
      ),
    );
  }

  Row buildRow(String label, IconData icon, Color color,) {
    return Row(
      children: [
        Icon(icon, color: color),
        5.widthBox,
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppStyles.w400f14inter.copyWith(color: kTextColor),
        ),
      ],
    );
  }
}
