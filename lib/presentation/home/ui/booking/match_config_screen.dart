// lib/presentation/booking/ui/match_config_screen.dart
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/presentation/home/data/models/court_model.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/invite_player_sheet.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/payment_method_screen.dart';

class MatchConfigScreen extends StatefulWidget {
  final Court court;
  final String dateLabel;
  final String timeLabel;
  final String blockLabel;

  const MatchConfigScreen({
    super.key,
    required this.court,
    required this.dateLabel,
    required this.timeLabel,
    required this.blockLabel,
  });

  @override
  State<MatchConfigScreen> createState() => _MatchConfigScreenState();
}

class _MatchConfigScreenState extends State<MatchConfigScreen> {
  MatchType _matchType = MatchType.private;
  BookingFormat _format = BookingFormat.single;
  PaymentSplitOption _paymentOption = PaymentSplitOption.payAllReceiveLater;
  List<InvitablePlayerModel> _invitedPlayers = [
    dummyPlayers[1], // Pedro Costa, preselected to mirror the mock
    dummyPlayers[2], // John
  ];

  List<PaymentSplitOption> get _availablePaymentOptions {
    if (_matchType == MatchType.private) {
      return PaymentSplitOption.values;
    }
    // Open matches: "pay all, no splitting" doesn't apply since anyone can join.
    return const [
      PaymentSplitOption.payAllReceiveLater,
      PaymentSplitOption.payOnlyMyPart,
    ];
  }

  Future<void> _openInvitePlayers() async {
    final result = await InvitePlayersSheet.show(
      context,
      initiallyInvited: _invitedPlayers,
    );
    if (result != null) {
      setState(() => _invitedPlayers = result);
    }
  }

  void _onBookTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentMethodScreen(
          court: widget.court,
          dateLabel: widget.dateLabel,
          timeLabel: widget.timeLabel,
          blockLabel: widget.blockLabel,
          amount: widget.court.sports?.first.hourlyRate?.toDouble() ?? 10.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_availablePaymentOptions.contains(_paymentOption)) {
      _paymentOption = _availablePaymentOptions.first;
    }

    return Scaffold(
      backgroundColor: kCardColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kBorderColor),
            ),
            child: Icon(Icons.arrow_back, size: 24, color: kDarkTextColor),
          ),
        ),
        title: Text(
          'Booking Summary',
          style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COURT DETAILS',
                    style: AppStyles.w500f12inter.copyWith(color: kTextColor),
                  ),
                  8.heightBox,
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: kBorderF0),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AppCachedImage(
                            imageUrl: widget.court.imageUrl,
                            width: 95,
                            height: 95,
                          ),
                        ),
                        12.widthBox,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.court.courtName ?? '',
                                style: AppStyles.w600f16inter.copyWith(
                                  color: kDarkTextColor,
                                ),
                              ),
                              Text(
                                '${widget.court.location} • 2.5 miles',
                                style: AppStyles.w400f14inter.copyWith(
                                  color: kTextColor,
                                ),
                              ),
                              Text(
                                '${widget.dateLabel} | ${widget.timeLabel} | ${widget.blockLabel}',
                                style: AppStyles.w500f12inter.copyWith(
                                  color: kLightGreenColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.heightBox,

                  Text(
                    'MATCH TYPE',
                    style: AppStyles.w500f12inter.copyWith(color: kTextColor),
                  ),
                  8.heightBox,
                  Row(
                    children: MatchType.values.map((type) {
                      final isSelected = _matchType == type;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _matchType = type),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? kPrimaryColor : kWhiteColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  type == MatchType.open ? 40 : 0,
                                ),
                                bottomLeft: Radius.circular(
                                  type == MatchType.open ? 40 : 0,
                                ),
                                topRight: Radius.circular(
                                  type == MatchType.open ? 0 : 40,
                                ),
                                bottomRight: Radius.circular(
                                  type == MatchType.open ? 0 : 40,
                                ),
                              ),
                              border: isSelected
                                  ? null
                                  : Border.all(color: kBorderColor),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      type == MatchType.open
                                          ? Icons.public
                                          : Icons.lock,
                                      size: 18,
                                      color: kDarkTextColor,
                                    ),
                                    4.widthBox,
                                    Text(
                                      type.label,
                                      style: AppStyles.w400f14inter.copyWith(
                                        color: kDarkTextColor,
                                        fontWeight: isSelected
                                            ? FontWeight.w500
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  type.description,
                                  style: AppStyles.w400f10inter.copyWith(
                                    color: kDarkTextColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  20.heightBox,
                  Text(
                    'FORMAT',
                    style: AppStyles.w500f12inter.copyWith(color: kTextColor),
                  ),
                  8.heightBox,
                  Row(
                    children: BookingFormat.values.map((format) {
                      final isSelected = _format == format;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _format = format),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? kPrimaryColor : kWhiteColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  format == BookingFormat.single ? 20 : 0,
                                ),
                                bottomLeft: Radius.circular(
                                  format == BookingFormat.single ? 20 : 0,
                                ),
                                topRight: Radius.circular(
                                  format == BookingFormat.single ? 0 : 20,
                                ),
                                bottomRight: Radius.circular(
                                  format == BookingFormat.single ? 0 : 20,
                                ),
                              ),
                              border: isSelected
                                  ? null
                                  : Border.all(color: kBorderColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  format == BookingFormat.double_
                                      ? Icons.people_outline
                                      : Icons.person_outline,
                                  size: 18,
                                  color: kDarkTextColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  format.label,
                                  style: AppStyles.w400f14inter.copyWith(
                                    color: kDarkTextColor,
                                    fontWeight: isSelected
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  20.heightBox,

                  Text(
                    'INVITE PLAYERS',
                    style: AppStyles.w500f12inter.copyWith(color: kTextColor),
                  ),
                  8.heightBox,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: _openInvitePlayers,
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: kBorderColor),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.search,
                                  color: kTextColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Search players...',
                                  style: AppStyles.w400f14inter.copyWith(
                                    color: kTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_invitedPlayers.isNotEmpty) ...[
                          10.heightBox,
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _invitedPlayers.map((player) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        player.avatarUrl,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      player.name,
                                      style: AppStyles.w500f12inter.copyWith(
                                        color: kDarkTextColor,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: () => setState(
                                        () => _invitedPlayers.remove(player),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: kDarkTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  20.heightBox,

                  Text(
                    'PAYMENT',
                    style: AppStyles.w500f12inter.copyWith(color: kTextColor),
                  ),
                  8.heightBox,
                  ..._availablePaymentOptions.map((option) {
                    final isSelected = _paymentOption == option;
                    return GestureDetector(
                      onTap: () => setState(() => _paymentOption = option),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? kPrimaryColor.withValues(alpha: 0.15)
                              : kWhiteColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kWhiteColor, width: 4),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: kPrimaryColor,
                                  width: isSelected ? 6 : 3,
                                ),
                              ),
                            ),
                            12.widthBox,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.title,
                                    style: AppStyles.w500f14inter.copyWith(
                                      color: kBlack12Color,
                                    ),
                                  ),
                                  2.heightBox,
                                  Text(
                                    option.description,
                                    style: AppStyles.w400f12inter.copyWith(
                                      color: kBlack12Color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Sticky bottom button
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomActionButton(
              buttonText:
                  'Book - ${formatPrice(widget.court.sports?.first.hourlyRate?.toDouble() ?? 10.0)}',
              onTap: _onBookTap,
            ),
          ),
        ],
      ),
    );
  }
}
