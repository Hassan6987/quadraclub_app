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

  String _getGenderLabel(AppLocalizations l10n, String gender) {
    switch (gender) {
      case 'Masculine':
        return l10n.masculine;
      case 'Feminine':
        return l10n.feminine;
      case 'Prefer not to say':
        return l10n.preferNotToSay;
      default:
        return gender;
    }
  }

  String _getHandLabel(AppLocalizations l10n, String hand) {
    switch (hand) {
      case 'Left':
        return l10n.left;
      case 'Right':
        return l10n.right;
      default:
        return hand;
    }
  }

  String _getSideLabel(AppLocalizations l10n, String side) {
    switch (side) {
      case 'Left':
        return l10n.left;
      case 'Right':
        return l10n.right;
      case 'Both':
        return l10n.both;
      default:
        return side;
    }
  }

  String _getCategoryLabel(BuildContext context, String category) {
    final key = levelKeyFrom(category);

    return key == null ? category : localizedLevelName(context, key);
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              textAlign: TextAlign.left,
              style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
            ),
          ),
          12.widthBox,
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                  l10n.everythingReady(firstName),
                  textAlign: TextAlign.center,
                  style: AppStyles.headingSemibold.copyWith(color: kBlackColor),
                ),

                5.heightBox,

                Text(
                  l10n.timeToFindCourtsPlayersMatches,
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
                      final category = data.sportCategories[sport];

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
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.subHeadingSemibold.copyWith(
                                color: kBlackColor,
                              ),
                            ),
                            4.heightBox,
                            Text(
                              category != null
                                  ? _getCategoryLabel(context, category)
                                  : '-',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                        l10n.profileSummary,
                        style: AppStyles.subtitleMedium.copyWith(
                          color: kBlackColor.withValues(alpha: 0.7),
                        ),
                      ),

                      12.heightBox,

                      _summaryRow(l10n.location, data.location ?? '-'),

                      _summaryRow(
                        l10n.gender,
                        data.gender != null
                            ? _getGenderLabel(l10n, data.gender!)
                            : '-',
                      ),

                      _summaryRow(
                        l10n.dominantHand,
                        data.dominantHand != null
                            ? _getHandLabel(l10n, data.dominantHand!)
                            : '-',
                      ),

                      _summaryRow(
                        l10n.dateOfBirth,
                        data.dateOfBirth != null
                            ? "${data.dateOfBirth!.day} "
                                  "${_monthNames[data.dateOfBirth!.month - 1]} "
                                  "${data.dateOfBirth!.year}"
                            : '-',
                      ),

                      _summaryRow(
                        l10n.preferredSide,
                        data.preferredSide != null
                            ? _getSideLabel(l10n, data.preferredSide!)
                            : '-',
                      ),
                    ],
                  ),
                ),

                24.heightBox,

                CustomActionButton(
                  buttonText: l10n.findSportsCourtsNearMe,
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
