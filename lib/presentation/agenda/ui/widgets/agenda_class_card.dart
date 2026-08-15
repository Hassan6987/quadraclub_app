import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/classes/ui/widgets/common_badge.dart';

class AgendaClassCard extends StatelessWidget {
  final AgendaClass item;
  final String? actionLabel;

  const AgendaClassCard({super.key, required this.item, this.actionLabel});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: kWhiteColor,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: kBorderF0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SportBadge(sport: item.sport),
            4.widthBox,
            const CommonBadge(label: 'Category E'),
            4.widthBox,
            const CommonBadge(label: 'Individual'),
            const Spacer(),
            Text(
              '\$${item.price}',
              style: AppStyles.w600f14inter.copyWith(color: kBlueF1),
            ),
          ],
        ),
        8.heightBox,
        Text(
          item.title,
          style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
        ),
        3.heightBox,
        Text(
          '${item.time} · ${item.location}',
          style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
        ),
        Divider(color: kDividerColor).withPaddingSymmetric(0, 8),
        Row(
          children: [
            AppCachedImage(
              imageUrl: playerOneImageUrl,
              height: 36,
              width: 36,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(24),
            ),
            10.widthBox,
            Text(
              'Coach ',
              style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
            ),
            Text(
              'Thiago Souza',
              style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
            ),
          ],
        ),
        if (actionLabel != null) ...[
          16.heightBox,
          CustomActionButton(buttonText: actionLabel!,
              backgroundColor:actionLabel=="Cancel request"? kLightPinkColor: kPrimaryColor,
              onTap: () {}),
        ],
      ],
    ),
  );
}
