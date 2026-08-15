import '/app_exports.dart';

class FeedbackCard extends StatelessWidget {
  final List<FeedbackTag> tags;

  const FeedbackCard({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feed Back',
            style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
          ),
          16.heightBox,
          Wrap(
            spacing: getProportionateScreenWidth(6),
            runSpacing: getProportionateScreenHeight(6),
            children: tags.map((t) => _FeedbackChip(tag: t)).toList(),
          ),
        ],
      ),
    );
  }
}

class _FeedbackChip extends StatelessWidget {
  final FeedbackTag tag;

  const _FeedbackChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(8),
        vertical: getProportionateScreenHeight(7),
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(tag.icon),
          2.widthBox,
          Text(
            '${tag.label} ${tag.count}',
            style: AppStyles.w400f12inter.copyWith(color: kDarkTextColor),
          ),
        ],
      ),
    );
  }
}
