import '../../../../app_exports.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  final UserModel? user;

  const ProfileHeader({super.key, required this.profile, this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: getProportionateScreenWidth(12),
      children: [
        AppCachedImage(
          imageUrl: user?.profilePhoto ?? profile.avatarUrl,
          borderRadius: BorderRadius.circular(200),
          width: 80,
          height: 80,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.fullName ?? profile.name,
                style: AppStyles.w600f18inter.copyWith(color: kDarkTextColor),
              ),
              4.heightBox,
              // Sport tags
              if (user?.sportsInfo != null)
                Wrap(
                  spacing: 2,
                  runSpacing: 4,
                  children: user!.sportsInfo
                      .map((s) => _SportChip(tag: s))
                      .toList(),
                ),
              if (user?.sportsInfo == null)
                Wrap(
                  spacing: 2,
                  runSpacing: 4,
                  children: profile.sports
                      .map((s) => _SportChip(tag: s))
                      .toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SportChip extends StatelessWidget {
  final SportsInfo tag;

  const _SportChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(200),
        border: Border.all(color: kBorderColor),
      ),
      child: Text(
        '${tag.sport} · ${tag.category}',
        style: AppStyles.w500f12inter.copyWith(color: kBlueColor, fontSize: 10),
      ).withPaddingSymmetric(8, 4),
    );
  }
}
