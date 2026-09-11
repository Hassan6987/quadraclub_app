import '/app_exports.dart';

class StackedAvatars extends StatelessWidget {
  final List<String?> imgUrls;
  final double avatarSize;
  final int maxVisible;

  const StackedAvatars({
    super.key,
    required this.imgUrls,
    this.avatarSize = 32,
    this.maxVisible = 3,
  });

  @override
  Widget build(BuildContext context) {
    final bool showExtraCount = imgUrls.length > maxVisible;

    // If more than 3 -> show first 2 + "+N"
    // If exactly (or fewer than) 3 -> show all of them, no count bubble
    final List<String?> displayList = showExtraCount
        ? imgUrls.take(2).toList()
        : imgUrls.take(maxVisible).toList();

    final int extraCount = showExtraCount
        ? imgUrls.length - displayList.length
        : 0;

    final int totalSlots = displayList.length + (extraCount > 0 ? 1 : 0);
    final double totalWidth =
        avatarSize + (totalSlots - 1) * (avatarSize * 0.55);

    return SizedBox(
      width: totalWidth,
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ...displayList.asMap().entries.map((e) {
            return Positioned(
              left: e.key * (avatarSize * 0.55),
              child: AppCachedImage(
                borderRadius: BorderRadius.circular(200),
                height: avatarSize,
                width: avatarSize,
                imageUrl: e.value,
              ),
            );
          }),
          if (extraCount > 0)
            Positioned(
              left: displayList.length * (avatarSize * 0.55),
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: kGreyColor,
                child: Text(
                  '+$extraCount',
                  style: AppStyles.w500f12inter.copyWith(color: kDarkTextColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
