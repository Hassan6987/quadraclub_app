import 'package:quadraclub_app/app_exports.dart';


class ClassBookedDialog extends StatelessWidget {
  const ClassBookedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kWhiteColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          40.heightBox,
          CommonSuccessCheck(),
          20.heightBox,
          Text(
            'Class Booked',
            style: AppStyles.w600f18inter.copyWith(
              color: kDarkTextColor,
              fontSize: 20,
            ),
          ),
          8.heightBox,
          Text(
            'Your class is confirmed. We look forward to seeing you!',
            textAlign: TextAlign.center,
            style: AppStyles.w400f14inter.copyWith(color: kTextColor),
          ),
          40.heightBox,
          CommonDivider(),
          16.heightBox,
          CustomActionButton(
            buttonText: 'Close',
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
}
