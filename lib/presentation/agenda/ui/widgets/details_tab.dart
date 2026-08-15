import '/app_exports.dart';

class DetailsTab extends StatelessWidget {
  final AgendaMatch match;

  const DetailsTab({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _venueCard().withPaddingSymmetric(20, 16),
        16.heightBox,
        _tagsRow().withPaddingSymmetric(20, 0),
        16.heightBox,
        CommonDivider(),
        16.heightBox,
        _playersSection(),
        16.heightBox,
        _groupChatSection(),
        Spacer(),
        CommonDivider(),
        CustomActionButton(
          buttonText: "Leave this match",
          onTap: () {},
          backgroundColor: kLightPinkColor,
        ).withPaddingSymmetric(24, 16),
      ],
    );
  }

  Widget _venueCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCachedImage(
          imageUrl: courtImageUrl,
          height: 64,
          width: 64,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(20),
        ),
        8.widthBox,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              match.venue,
              style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
            ),
            4.heightBox,
            Text(
              match.location,
              style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
            ),
            4.heightBox,
            Text(
              'SUN, OCT 22 | 8:00 | BLOCK 1',
              style: AppStyles.w500f12inter.copyWith(color: kLightGreenColor),
            ),
          ],
        ),
        12.heightBox,
      ],
    );
  }

  Widget _tagsRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        CommonBadge(label: '16:00-17:30'),
        const CommonBadge(label: 'Category D'),
        const CommonBadge(label: 'Ranking'),
        CourtConfirmationBadge(),
      ],
    );
  }

  Widget _playersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Players',
              style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
            ),
            SportBadge(sport: match.sport),
          ],
        ),
        16.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _playerItem(playerOneImageUrl, 'Alex', 'Beginner'),
            _playerItem(playerTwoImageUrl, 'John', 'Beginner'),
            Container(height: 24, width: 1, color: kGreyTextColor),
            _playerItem(playerOneImageUrl, 'Robert', 'Beginner'),
            _playerItem(playerTwoImageUrl, 'Jax', 'Beginner'),
          ],
        ),
      ],
    ).withPaddingSymmetric(20, 0);
  }

  Widget _playerItem(String image, String name, String skill) {
    return Column(
      children: [
        AppCachedImage(
          imageUrl: image,
          height: 48,
          width: 48,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(48),
        ),
        6.heightBox,
        Text(
          name,
          style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
        ),
        Text(
          skill,
          style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
        ),
      ],
    );
  }

  Widget _groupChatSection() {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          CommonAvatarStackRow(
            imageUrls: [playerOneImageUrl, playerTwoImageUrl],
            maxVisible: 2,
            avatarSize: 32,
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Group Chat',
                  style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
                ),
                Text(
                  'Chat with players',
                  style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
                ),
              ],
            ),
          ),
          CustomActionButton(
            buttonText: 'Chat',
            onTap: () {},
            width: 84,
            height: 40,
          ),
        ],
      ),
    ).withPaddingSymmetric(20, 0);
  }
}
