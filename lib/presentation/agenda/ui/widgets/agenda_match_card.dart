import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/players_row.dart';

class AgendaMatchCard extends StatelessWidget {
  final AgendaMatch match;
  final String? actionLabel;
  final VoidCallback? onTap;

  const AgendaMatchCard({super.key, required this.match, this.actionLabel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: kBorderF0),

        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SportBadge(sport: match.sport),
                        const Spacer(),
                        _seatsBadge(),
                      ],
                    ),
                    4.heightBox,
                    Text(
                      match.venue,
                      style: AppStyles.w600f16inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                    Text(
                      match.location,
                      style: AppStyles.w400f14inter.copyWith(
                        color: kGreyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).withPaddingAll(10),
          4.heightBox,
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              CommonBadge(label: match.time),
              const CommonBadge(label: 'Category D'),
              const CommonBadge(label: 'Ranking'),
              _courtConfirmedBadge(),
            ],
          ),
          16.heightBox,
          PlayersRow(),
          if (actionLabel != null) ...[

            CustomActionButton(
                backgroundColor:actionLabel=="Cancel request"? kLightPinkColor: kPrimaryColor,
                buttonText: actionLabel!, onTap: () {}).withPaddingSymmetric(16, 12),


          ],
        ],
      ),
    ));
  }

  Widget _seatsBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: BoxDecoration(
      color: kRedColor,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      '2 Seats',
      style: AppStyles.w400f12inter.copyWith(color: kWhiteColor),
    ),
  );

  Widget _courtConfirmedBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: kGreen06.withValues(alpha: 0.10),
      border: Border.all(color: kGreen06),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      'Court Confirmed',
      style: AppStyles.w500f10inter.copyWith(color: kGreen06),
    ),
  );



}
