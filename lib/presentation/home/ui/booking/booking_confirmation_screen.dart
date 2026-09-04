// lib/presentation/booking/ui/confirmation_screen.dart
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Club club;
  final String dateLabel;
  final String timeLabel;
  final String blockLabel;

  const BookingConfirmationScreen({
    super.key,
    required this.club,
    required this.dateLabel,
    required this.timeLabel,
    required this.blockLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kBorderColor),
                    ),
                    child: const Icon(
                        Icons.close, color: kDarkTextColor, size: 20),
                  ),
                ),
              ),
              24.heightBox,
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
              Center(
                child: Text(
                  'Booking Confirmed!',
                  style: AppStyles.w600f18inter.copyWith(
                      color: kDarkTextColor, fontSize: 20),
                ),
              ),
              8.heightBox,
              Center(
                child: Text(
                  'Your court is reserved. Get ready for\nan amazing match.',
                  textAlign: TextAlign.center,
                  style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
                ),
              ),
              32.heightBox,
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: kBorderF0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AppCachedImage(
                        imageUrl: club.photo,
                        width: double.infinity,
                        height: 150,
                      ),
                    ),
                    10.heightBox,
                    Text(
                      '$dateLabel | $timeLabel | $blockLabel',
                      style: AppStyles.w500f12inter.copyWith(
                          color: kLightGreenColor),
                    ).withPaddingSymmetric(10, 0),
                    4.heightBox,
                    Text(
                      club.name ?? '',
                      style: AppStyles.w600f16inter.copyWith(
                          color: kDarkTextColor),
                    ).withPaddingSymmetric(10, 0),
                    Text(
                      '${club.city} • 2.5 miles',
                      style: AppStyles.w400f14inter.copyWith(
                          color: kGreyTextColor),
                    ).withPaddingSymmetric(10, 0),
                    10.heightBox,
                  ],
                ),
              ),
              const Spacer(),
              CustomActionButton(
                buttonText: "Done",
                buttonTextColor: kDarkTextColor,
                backgroundColor: kWhiteColor,
                borderColor: kBorderColor,
                onTap: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}