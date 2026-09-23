import '../../../../app_exports.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

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
              Text(
                user.fullName ?? '',
                style: AppStyles.w600f18inter.copyWith(color: kDarkTextColor),
              ),
              4.heightBox,
              if (user.sportsInfo.isNotEmpty)
                Wrap(
                  spacing: 2,
                  runSpacing: 4,
                  children: user.sportsInfo
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
        '${tag.sport ?? ''} · ${tag.category ?? ''}',
        style: AppStyles.w500f12inter.copyWith(color: kBlueColor, fontSize: 10),
      ).withPaddingSymmetric(8, 4),
    );
  }
}
