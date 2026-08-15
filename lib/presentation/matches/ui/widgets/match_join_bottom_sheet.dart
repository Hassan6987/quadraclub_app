import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/ui/booking_summary_screen.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/match_card.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';

import '/app_exports.dart';

class MatchJoinBottomSheet extends StatefulWidget {
  final MatchModel match;

  const MatchJoinBottomSheet({super.key, required this.match});

  static Future<void> show(BuildContext context, MatchModel match) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      backgroundColor: Colors.transparent,
      builder: (_) => MatchJoinBottomSheet(match: match),
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
                'Join Match',
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
                    widget.match.description,
                    style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
                  ).withPaddingSymmetric(10, 8),
                  buildPlayersRow(context, widget.match, null)
                      .withPaddingSymmetric(16, 8),
                  16.heightBox,
                  CustomTextField(
                    controller: _messageController,
                    hintText: 'Send message to admin',
                    maxLines: 3,
                    fillColor: kWhiteF9,
                    hintStyle: AppStyles.w400f14inter.copyWith(
                        color: kTextColor),
                    borderRadius: 12,
                  ).withPaddingSymmetric(16, 8),
                  24.heightBox,
                  Divider(thickness: 5, color: kBorderF0,),
                ],
              ),
            ),
          ),
          
          // Send Request Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: CustomActionButton(
              buttonText: "Send Request",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) => BookingSummaryScreen(match: widget.match)));
              },
            ),
          ),
        ],
      ).withPaddingSymmetric(0, 16),
    );
  }

  Widget _buildMatchDetailsCard(MatchModel match) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AppCachedImage(
                  imageUrl: match.imageAsset,
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
                        buildSeatsBadge(match),
                      ],
                    ),
                    Text(
                      match.location,
                      style: AppStyles.w500f14inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                    Text(
                      "${match.city} • ${match
                          .distanceKm} miles • ${getFormatDateMonth(
                          match.date)}",
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
              CommonBadge(label: '${match.timeStart}-${match.timeEnd}'),
              4.widthBox,
              CommonBadge(label: match.category),
              4.widthBox,
              CommonBadge(label: "Ranking"),
              4.widthBox,
              buildCourtStatusBadge(match),
            ],
          ),
          12.heightBox,
        ],
      ),
    );
  }
}
