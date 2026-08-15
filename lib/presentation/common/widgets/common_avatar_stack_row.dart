import '/app_exports.dart';

class CommonAvatarStackRow extends StatelessWidget {
  /// List of avatar image URLs to display.
  final List<String> imageUrls;

  /// How many avatars to show in the stack before collapsing into "+N".
  final int maxVisible;

  /// Total count this stack represents (e.g. filledSlots).
  /// Defaults to imageUrls.length if not provided.
  final int? totalCount;

  /// Whether to show the "+N" bubble when there are more than [maxVisible].
  final bool showExtraCount;

  /// Diameter of each avatar.
  final double avatarSize;

  /// How much each avatar overlaps the previous one.
  final double overlap;

  const CommonAvatarStackRow({
    super.key,
    required this.imageUrls,
    this.maxVisible = 3,
    this.totalCount,
    this.showExtraCount = true,
    this.avatarSize = 32,
    this.overlap = 20,
  });

  @override
  Widget build(BuildContext context) {
    final displayImages = imageUrls.take(maxVisible).toList();
    final effectiveTotal = totalCount ?? imageUrls.length;
    final extra = effectiveTotal - displayImages.length;
    final showExtra = showExtraCount && extra > 0;

    final width = (displayImages.length * overlap) + (showExtra ? 28 : 0);

    return SizedBox(
      height: avatarSize,
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < displayImages.length; i++)
            Positioned(
              left: i * overlap,
              child: AppCachedImage(
                borderRadius: BorderRadius.circular(200),
                height: avatarSize,
                width: avatarSize,
                imageUrl: displayImages[i],
                border: Border.all(color: kWhiteColor, width: 2),
              ),
            ),
          if (showExtra)
            Positioned(
              left: displayImages.length * overlap,
              child: Container(
               height: avatarSize,
                width: avatarSize,
                decoration: BoxDecoration(
                  color: kGreyColor,
                  borderRadius: BorderRadius.circular(200)
                ),

                child: Center(
                  child: Text(
                    '+$extra',
                    style: AppStyles.w500f12inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}