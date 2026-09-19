import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/agenda_chat_screen.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/match_card.dart';

class AgendaClassCard extends StatelessWidget {
  final AgendaItem item;
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
            SportBadge(sport: SportTypeExtension.fromString(item.sport)),
            4.widthBox,
            CommonBadge(
              label: localizedMatchCategory(context, item.category),
            ),
            if (item.classType != null) ...[
              4.widthBox,
              CommonBadge(
                label: _localizedClassType(context, item.classType!),
              ),
            ],
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
          item.dateString,
          style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
        ),
        Divider(color: kDividerColor).withPaddingSymmetric(0, 8),
        Row(
          children: [
            AppCachedImage(
              imageUrl: item.coachPhoto ?? '',
              height: 36,
              width: 36,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(24),
            ),
            10.widthBox,
            Text(
              '${AppLocalizations.of(context)!.coach} ',
              style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
            ),
            Text(
              item.coachName ?? '',
              style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
            ),
          ],
        ),
        if (actionLabel != null)
          CustomActionButton(
            buttonText: actionLabel == 'Cancel request'
                ? AppLocalizations.of(context)!.cancelRequest
                : AppLocalizations.of(context)!.chat,
            backgroundColor: actionLabel == "Cancel request"
                ? kLightPinkColor
                : kPrimaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      AgendaChatScreen(chatId: item.chatId ?? '',
                          label: item.title,
                          userCount: item.players?.length ?? 1),
                ),
              );
            },
          ).paddingOnly(top: 16),
      ],
    ),
  );

  String _localizedClassType(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type.toLowerCase()) {
      case 'group':
        return l10n.group;
      case 'individual':
        return l10n.individual;
      default:
        return type;
    }
  }
}
