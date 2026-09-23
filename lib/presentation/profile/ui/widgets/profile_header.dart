import 'package:quadraclub_app/presentation/profile/ui/edit_sports_level_screen.dart';

import '../../../../app_exports.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  final bool canEditSports;

  const ProfileHeader({
    super.key,
    required this.user,
    this.canEditSports = false,
  });

  void _openEditSports(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditSportsLevelScreen(user: user)),
    );
  }

  String _sportChipLabel(BuildContext context, SportsInfo info) {
    final sport = info.sport ?? '';
    final key = levelKeyFrom(info.category);
    final level = key == null
        ? (info.category ?? '')
        : localizedLevelName(context, key);
    if (level.isEmpty) return sport;
    return '$sport · $level';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: getProportionateScreenWidth(12),
      children: [
        AppCachedImage(
          imageUrl: user.profilePhoto,
          borderRadius: BorderRadius.circular(200),
          width: 80,
          height: 80,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      user.fullName ?? '',
                      style: AppStyles.w600f18inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                  ),
                  if (canEditSports)
                    GestureDetector(
                      onTap: () => _openEditSports(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kBorderColor),
                          color: kWhiteColor,
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: kDarkTextColor,
                        ),
                      ),
                    ),
                ],
              ),
              4.heightBox,
              if (user.sportsInfo.isNotEmpty)
                Wrap(
                  spacing: 2,
                  runSpacing: 4,
                  children: user.sportsInfo.map((s) {
                    final chip = Container(
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(200),
                        border: Border.all(color: kBorderColor),
                      ),
                      child: Text(
                        _sportChipLabel(context, s),
                        style: AppStyles.w500f12inter.copyWith(
                          color: kBlueColor,
                          fontSize: 10,
                        ),
                      ).withPaddingSymmetric(8, 4),
                    );

                    if (!canEditSports) return chip;

                    return GestureDetector(
                      onTap: () => _openEditSports(context),
                      child: chip,
                    );
                  }).toList(),
                )
              else if (canEditSports)
                GestureDetector(
                  onTap: () => _openEditSports(context),
                  child: Text(
                    AppLocalizations.of(context)!.selectYourCategory,
                    style: AppStyles.w500f12inter.copyWith(color: kBlueColor),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
