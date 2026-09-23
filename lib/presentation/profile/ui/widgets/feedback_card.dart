import 'package:quadraclub_app/presentation/authentication/data/model/user_model.dart';

import '/app_exports.dart';

/// Maps API feedback tag labels to the icons used in the profile chips.
String feedbackTagIcon(String tag) {
  switch (tag.trim().toLowerCase()) {
    case 'good defense':
    case 'boa defesa':
      return Assets.svg.shieldIcon.path;
    case 'good attack':
    case 'bom ataque':
      return Assets.svg.chessIcon.path;
    case 'one-off':
    case 'one off':
    case 'pontual':
      return Assets.svg.circleTick.path;
    case 'strategic':
    case 'estratégico':
    case 'estrategico':
      return Assets.svg.aimIcon.path;
    case 'good humor':
    case 'good energy':
    case 'boa energia':
      return Assets.svg.emoji.path;
    default:
      return Assets.svg.circleTick.path;
  }
}

class FeedbackCard extends StatelessWidget {
  final List<FeedbackStats> tags;

  const FeedbackCard({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.feedBack,
            style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
          ),
          16.heightBox,
          if (tags.isEmpty)
            Text(
              '—',
              style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
            )
          else
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
  final FeedbackStats tag;

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
          SvgPicture.asset(feedbackTagIcon(tag.tag), height: 14, width: 14),
          2.widthBox,
          Text(
            '${tag.tag} ${tag.count}',
            style: AppStyles.w400f12inter.copyWith(color: kDarkTextColor),
          ),
        ],
      ),
    );
  }
}
