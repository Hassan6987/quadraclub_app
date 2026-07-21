import 'package:quadraclub_app/presentation/classes/ui/widgets/common_badge.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/request_sent_dialog.dart';
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
            children: [
              Text(
                'Join Match',
                style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 22, color: kDarkTextColor),
              ),
            ],
          ).paddingOnly(top: 5, bottom: 16, left: 20, right: 20),
          
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Match Details Card
                  _buildMatchDetailsCard(),
                  16.heightBox,
                  
                  // Description
                  Text(
                    widget.match.description,
                    style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
                  ),
                  16.heightBox,
                  
                  // Players Section
                  Text(
                    'Players',
                    style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
                  ),
                  12.heightBox,
                  _buildPlayersSection(),
                  16.heightBox,
                  
                  // Message Input
                  Text(
                    'Send message to admin',
                    style: AppStyles.w500f12inter.copyWith(color: kGreyTextColor),
                  ),
                  8.heightBox,
                  CustomTextField(
                    controller: _messageController,
                    hintText: 'Type your message...',
                    maxLines: 3,
                    borderRadius: 12,
                  ),
                  24.heightBox,
                ],
              ).withPaddingSymmetric(20, 0),
            ),
          ),
          
          // Send Request Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: CustomActionButton(
              buttonText: "Send Request",
              onTap: () {
                Navigator.pop(context);
                _showRequestSentDialog();
              },
              backgroundColor: kGreenColor,
            ),
          ),
        ],
      ).withPaddingSymmetric(0, 16),
    );
  }

  Widget _buildMatchDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kGreyColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: widget.match.imageAsset != null
                ? ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      widget.match.imageAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.sports_tennis, size: 48, color: kGreyTextColor);
                      },
                    ),
                  )
                : Icon(Icons.sports_tennis, size: 48, color: kGreyTextColor),
          ),
          12.heightBox,
          
          // Sport badge and seats
          Row(
            children: [
              SportBadge(sport: widget.match.sport),
              4.widthBox,
              CommonBadge(label: widget.match.category),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kRedColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kRedColor),
                ),
                child: Text(
                  '${widget.match.slotsLeft} Seats',
                  style: AppStyles.w500f10inter.copyWith(color: kRedColor),
                ),
              ),
            ],
          ).withPaddingSymmetric(12, 0),
          8.heightBox,
          
          // Location
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              widget.match.location,
              style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
            ),
          ),
          4.heightBox,
          
          // City, distance, date
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${widget.match.city} • ${widget.match.distanceKm} miles • ${widget.match.date.day} ${_getMonthName(widget.match.date.month)}',
              style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
            ),
          ),
          8.heightBox,
          
          // Time
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.svg.clockTimer.path,
                  height: 16,
                  width: 16,
                  colorFilter: ColorFilter.mode(kGreyTextColor, BlendMode.srcIn),
                ),
                4.widthBox,
                Text(
                  '${widget.match.timeStart}-${widget.match.timeEnd}',
                  style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
                ),
              ],
            ),
          ),
          8.heightBox,
          
          // Tags
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                CommonBadge(label: widget.match.category),
                4.widthBox,
                CommonBadge(label: 'Ranking'),
                4.widthBox,
                _buildCourtStatusBadge(),
              ],
            ),
          ),
          12.heightBox,
        ],
      ),
    );
  }

  Widget _buildCourtStatusBadge() {
    final isConfirmed = widget.match.courtStatus == CourtStatus.confirmed;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isConfirmed 
            ? kGreenColor.withValues(alpha: 0.1)
            : kGreyColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConfirmed ? kGreenColor : kGreyTextColor,
        ),
      ),
      child: Text(
        isConfirmed ? 'Court Confirmed' : 'Pending Confirmed',
        style: AppStyles.w500f10inter.copyWith(
          color: isConfirmed ? kGreenColor : kGreyTextColor,
        ),
      ),
    );
  }

  Widget _buildPlayersSection() {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ...widget.match.players.map((player) => _buildPlayerRow(player)),
        ],
      ).withPaddingSymmetric(12, 12),
    );
  }

  Widget _buildPlayerRow(PlayerModel player) {
    if (player.isAvailable) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: kGreyColor,
                shape: BoxShape.circle,
                border: Border.all(color: kBorderColor),
              ),
              child: Icon(
                Icons.add,
                size: 20,
                color: kDarkTextColor,
              ),
            ),
            12.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.position ?? 'Available',
                    style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
                  ),
                  Text(
                    'Available',
                    style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kGreyColor,
              shape: BoxShape.circle,
            ),
            child: player.avatarAsset != null
                ? ClipOval(
                    child: Image.asset(
                      player.avatarAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.person, size: 20, color: kGreyTextColor);
                      },
                    ),
                  )
                : Icon(Icons.person, size: 20, color: kGreyTextColor),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
                ),
                Text(
                  player.skillLevel,
                  style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  void _showRequestSentDialog() {
    showDialog(
      context: context,
      builder: (context) => RequestSentDialog(),
    );
  }
}
