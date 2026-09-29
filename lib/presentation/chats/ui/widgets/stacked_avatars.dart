import '/app_exports.dart';

class StackedAvatars extends StatelessWidget {
  final List<String?> imgUrls;
  final double avatarSize;
  final int maxVisible;

  const StackedAvatars({
    super.key,
    required this.imgUrls,
    this.avatarSize = 35,
    this.maxVisible = 3,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSingleImage = imgUrls.length == 1;
    final bool showExtraCount = imgUrls.length > maxVisible;

    // Single image = 52x52
    // Multiple images = avatarSize (32x32 by default)
    final double effectiveAvatarSize = isSingleImage ? 52 : avatarSize;

    // If more than maxVisible -> show first 2 + "+N"
    // Otherwise show all images
    final List<String?> displayList = showExtraCount
        ? imgUrls.take(2).toList()
        : imgUrls.take(maxVisible).toList();

    final int extraCount = showExtraCount
        ? imgUrls.length - displayList.length
        : 0;

    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ...displayList.asMap().entries.map((entry) {
            return Positioned(
              left: entry.key * (effectiveAvatarSize * 0.55),
              child: AppCachedImage(
                borderRadius: BorderRadius.circular(200),
                height: effectiveAvatarSize,
                width: effectiveAvatarSize,
                imageUrl: entry.value,
              ),
            );
          }),

          if (extraCount > 0)
            Positioned(
              left: displayList.length * (effectiveAvatarSize * 0.55),
              child: CircleAvatar(
                radius: effectiveAvatarSize / 2,
                backgroundColor: kGreyColor,
                child: Text(
                  '+$extraCount',
                  style: AppStyles.w500f12inter.copyWith(
                    color: kDarkTextColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}