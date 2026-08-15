import 'package:quadraclub_app/presentation/authentication/data/model/signup_data.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

import '/app_exports.dart';

class ConfirmationScreen extends StatelessWidget {
  final SignupData data;

  const ConfirmationScreen({super.key, required this.data});

  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
          ),
          Text(
            value,
            style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstName = data.fullName.trim().isNotEmpty
        ? data.fullName.trim().split(' ').first
        : 'there';

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dim.PADDING_SIZE_LARGE),
          child: SingleChildScrollView(
            child: Column(
              children: [
                60.heightBox,
                Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFC5E028),
                      width: 10,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 32,
                    color: Color(0xFFC5E028),
                  ),
                ),
                20.heightBox,
                Text(
                  "Everything's ready, $firstName!",
                  textAlign: TextAlign.center,
                  style: AppStyles.headingSemibold.copyWith(color: kBlackColor),
                ),
                5.heightBox,
                Text(
                  "Time to find courts, players, and matches near you.",
                  textAlign: TextAlign.center,
                  style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
                ),
                24.heightBox,
                if (data.selectedSports.isNotEmpty)
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.4,
                    children: data.selectedSports.map((sport) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: kBorderColor),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              sport,
                              style: AppStyles.subHeadingSemibold.copyWith(
                                color: kBlackColor,
                              ),
                            ),
                            4.heightBox,
                            Text(
                              data.sportCategories[sport] ?? '-',
                              style: AppStyles.subtitleRegular.copyWith(
                                color: kTextColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                24.heightBox,
                Divider(color: kBorderColor, thickness: 1),
                8.heightBox,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kBorderColor.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Profile Summary",
                        style: AppStyles.subtitleMedium.copyWith(
                          color: kBlackColor.withValues(alpha: 0.7),
                        ),
                      ),
                      12.heightBox,
                      _summaryRow("Location", data.location ?? '-'),
                      _summaryRow("Gender", data.gender ?? '-'),
                      _summaryRow("Dominant Hand", data.dominantHand ?? '-'),
                      _summaryRow(
                        "Date of Birth",
                        data.dateOfBirth != null
                            ? "${data.dateOfBirth!.day} ${_monthNames[data.dateOfBirth!.month - 1]} ${data.dateOfBirth!.year}"
                            : '-',
                      ),
                      _summaryRow(
                        "Preferred side",
                        data.preferredSide != null ? data.preferredSide! : '-',
                      ),
                    ],
                  ),
                ),
                24.heightBox,
                CustomActionButton(
                  buttonText: "Find sports courts near me",
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CustomBottomNavBar(index: 2),
                      ),
                      (route) => false,
                    );
                  },
                  isEnabled: true,
                  backgroundColor: const Color(0xFFC5E028),
                  buttonTextColor: kBlackColor,
                  width: double.infinity,
                ),
                24.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
