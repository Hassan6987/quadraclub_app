import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/presentation/matches/bloc/matches_bloc.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/ui/booking_summary_screen.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/match_card.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';

import '/app_exports.dart';

class MatchJoinBottomSheet extends StatefulWidget {
  final Booking match;
  final double distanceKm;

  const MatchJoinBottomSheet({
    super.key,
    required this.match,
    required this.distanceKm,
  });

  static Future<void> show(
    BuildContext context,
    Booking match,
    double distanceKm,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      backgroundColor: Colors.transparent,
      builder: (_) =>
          MatchJoinBottomSheet(match: match, distanceKm: distanceKm),
    );
  }

  @override
  State<MatchJoinBottomSheet> createState() => _MatchJoinBottomSheetState();
}

class _MatchJoinBottomSheetState extends State<MatchJoinBottomSheet> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.joinMatch,
                style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 24, color: kDarkTextColor),
              ),
            ],
          ).paddingOnly(top: 5, bottom: 16, left: 20, right: 20),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Match Details Card
                  _buildMatchDetailsCard(widget.match),
                  16.heightBox,

                  // Description
                  Text(
                    l10n.sportMatchForPlayers(
                      widget.match.sport.localizedLabel(context),
                    ),
                    style: AppStyles.w400f14inter.copyWith(
                      color: kGreyTextColor,
                    ),
                  ).withPaddingSymmetric(10, 8),
                  buildPlayersRow(
                    context,
                    widget.match,
                    null,
                  ).withPaddingSymmetric(16, 8),
                  16.heightBox,
                  CustomTextField(
                    controller: _messageController,
                    hintText: l10n.sendMessageToAdmin,
                    maxLines: 3,
                    fillColor: kWhiteF9,
                    hintStyle: AppStyles.w400f14inter.copyWith(
                      color: kTextColor,
                    ),
                    borderRadius: 12,
                  ).withPaddingSymmetric(16, 8),
                  24.heightBox,
                  Divider(thickness: 5, color: kBorderF0),
                ],
              ),
            ),
          ),

          // Send Request Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: CustomActionButton(
              buttonText: l10n.sendRequest,
              onTap: () {
                context.read<MatchesBloc>().add(FetchPortfolio());
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingSummaryScreen(
                      match: widget.match,
                      distanceKm: widget.distanceKm,
                      message: _messageController.text.trim(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ).withPaddingSymmetric(0, 16),
    );
  }

  Widget _buildMatchDetailsCard(Booking match) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: kCardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AppCachedImage(
                  imageUrl: match.club?.photo ?? '',
                  width: 64,
                  height: 64,
                ),
              ),
              8.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SportBadge(sport: match.sport),
                        buildSeatsBadge(context, match),
                      ],
                    ),
                    Text(
                      match.club?.name ?? '',
                      style: AppStyles.w500f14inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                    Text(
                      "${match.club?.city} • ${formatDistanceKm(widget.distanceKm, AppLocalizations.of(context)!)} • ${getFormatDateMonth(match.bookingDate, locale: AppLocalizations.of(context)!.localeName)}",
                      style: AppStyles.w400f14inter.copyWith(
                        color: kGreyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          8.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonBadge(label: '${match.startTime}-${match.endTime}'),
              4.widthBox,
              CommonBadge(
                label: localizedMatchCategory(context, match.category),
              ),
              4.widthBox,
              CommonBadge(label: AppLocalizations.of(context)!.ranking),
              4.widthBox,
              buildCourtStatusBadge(context, match),
            ],
          ),
          12.heightBox,
        ],
      ),
    );
  }
}
