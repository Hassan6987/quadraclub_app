// lib/presentation/booking/ui/match_config_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/invite_player_model.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/invite_player_sheet.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/payment_method_screen.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';
import 'package:shimmer/shimmer.dart';

class MatchConfigScreen extends StatefulWidget {
  final Club club;
  final Court court;
  final String dateLabel;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final String timeLabel;
  final double amount;
  final double distance;

  const MatchConfigScreen({
    super.key,
    required this.club,
    required this.court,
    required this.dateLabel,
    required this.timeLabel,
    required this.amount,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.distance,
  });

  @override
  State<MatchConfigScreen> createState() => _MatchConfigScreenState();
}

class _MatchConfigScreenState extends State<MatchConfigScreen> {
  MatchType _matchType = MatchType.private;
  BookingFormat _format = BookingFormat.single;
  PaymentSplitOption _paymentOption =
      PaymentSplitOption.payAllReceiveLater;

  List<InvitePlayerModel> _invitedPlayers = [];

  List<PaymentSplitOption> get _availablePaymentOptions {
    if (_matchType == MatchType.private) {
      return PaymentSplitOption.values;
    }

    return const [
      PaymentSplitOption.payAllReceiveLater,
      PaymentSplitOption.payOnlyMyPart,
    ];
  }

  String get _locationLabel {
    final city = widget.club.city ?? '';
    final state = widget.club.state ?? '';

    if (city.isEmpty) return state;
    if (state.isEmpty) return city;

    return '$city, $state';
  }

  double get _displayAmount {
    if (_paymentOption == PaymentSplitOption.payOnlyMyPart) {
      final divisor = _format == BookingFormat.single ? 2 : 4;
      return widget.amount / divisor;
    }

    return widget.amount;
  }

  Future<void> _openInvitePlayers(List<InvitePlayerModel> allPlayers,) async {
    final result = await InvitePlayersSheet.show(
      context,
      initiallyInvited: _invitedPlayers,
      allPlayers: allPlayers,
    );

    if (result != null) {
      setState(() => _invitedPlayers = result);
    }
  }

  String _localizedMatchTypeLabel(BuildContext context,
      MatchType type,) {
    final l10n = AppLocalizations.of(context)!;

    switch (type) {
      case MatchType.open:
        return l10n.open;
      case MatchType.private:
        return l10n.private;
    }
  }

  String _localizedMatchTypeDescription(BuildContext context,
      MatchType type,) {
    final l10n = AppLocalizations.of(context)!;

    switch (type) {
      case MatchType.open:
        return l10n.openMatchDescription;
      case MatchType.private:
        return l10n.privateMatchDescription;
    }
  }

  String _localizedFormatLabel(BuildContext context,
      BookingFormat format,) {
    final l10n = AppLocalizations.of(context)!;

    switch (format) {
      case BookingFormat.single:
        return l10n.single;
      case BookingFormat.double_:
        return l10n.doubleFormat;
    }
  }

  String _localizedPaymentTitle(BuildContext context,
      PaymentSplitOption option,) {
    final l10n = AppLocalizations.of(context)!;

    switch (option) {
      case PaymentSplitOption.payAllReceiveLater:
        return l10n.payAllReceiveLater;

      case PaymentSplitOption.payOnlyMyPart:
        return l10n.payOnlyMyPart;
      case PaymentSplitOption.payAllNoSplit:
        return l10n.payAllNoSplit;
    }
  }

  String _localizedPaymentDescription(BuildContext context,
      PaymentSplitOption option,) {
    final l10n = AppLocalizations.of(context)!;

    switch (option) {
      case PaymentSplitOption.payAllReceiveLater:
        return l10n.payAllReceiveLaterDescription;

      case PaymentSplitOption.payOnlyMyPart:
        return l10n.payOnlyMyPartDescription;
      case PaymentSplitOption.payAllNoSplit:
        return l10n.payALlNoSplitDescription;
    }
  }

  void _onBookTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentMethodScreen(
          club: widget.club,
          court: widget.court,
          bookingDate: widget.bookingDate,
          startTime: widget.startTime,
          endTime: widget.endTime,
          dateLabel: widget.dateLabel,
          timeLabel: widget.timeLabel,
          amount: _displayAmount,
          isMatch: true,
          invitedPlayers: _invitedPlayers.map((p) => p.id).toList(),
          // Keep canonical model/API values.
          matchType: _matchType.label,
          matchFormat: _format.label,
          paymentType: _paymentOption.type,
          distance: widget.distance,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kBorderColor),
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: kDarkTextColor,
            ),
          ),
        ),
        title: Text(
          l10n.bookingSummary,
          style: AppStyles.w600f16inter.copyWith(
            color: kDarkTextColor,
          ),
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
                    l10n.courtDetails.toUpperCase(),
                    style: AppStyles.w500f12inter.copyWith(
                      color: kTextColor,
                    ),
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
                          child: CachedNetworkImage(
                            imageUrl: widget.club.photo ?? '',
                            height: 96,
                            width: 96,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    height: 96,
                                    width: 96,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                Assets.png.clubLogo.path,
                                height: 96,
                                width: 96,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        12.widthBox,
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.club.name ?? '',
                                style: AppStyles.w600f16inter.copyWith(
                                  color: kDarkTextColor,
                                ),
                              ),
                              Text(
                                '$_locationLabel • '
                                    '${formatDistanceKm(widget.distance,
                                    AppLocalizations.of(context)!)}',
                                style: AppStyles.w400f14inter.copyWith(
                                  color: kTextColor,
                                ),
                              ),
                              Text(
                                '${widget.dateLabel} | ${widget.timeLabel}',
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
                    l10n.matchType.toUpperCase(),
                    style: AppStyles.w500f12inter.copyWith(
                      color: kTextColor,
                    ),
                  ),
                  8.heightBox,

                  Row(
                    children: MatchType.values.map((type) {
                      final isSelected = _matchType == type;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _matchType = type;

                              if (!_availablePaymentOptions
                                  .contains(_paymentOption)) {
                                _paymentOption =
                                    _availablePaymentOptions.first;
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? kPrimaryColor
                                  : kWhiteColor,
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
                                  : Border.all(
                                color: kBorderColor,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
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
                                      _localizedMatchTypeLabel(
                                        context,
                                        type,
                                      ),
                                      style:
                                      AppStyles.w400f14inter.copyWith(
                                        color: kDarkTextColor,
                                        fontWeight: isSelected
                                            ? FontWeight.w500
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  _localizedMatchTypeDescription(
                                    context,
                                    type,
                                  ),
                                  style:
                                  AppStyles.w400f10inter.copyWith(
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
                    l10n.format.toUpperCase(),
                    style: AppStyles.w500f12inter.copyWith(
                      color: kTextColor,
                    ),
                  ),
                  8.heightBox,

                  Row(
                    children: BookingFormat.values.map((format) {
                      final isSelected = _format == format;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _format = format),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? kPrimaryColor
                                  : kWhiteColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  format == BookingFormat.single
                                      ? 20
                                      : 0,
                                ),
                                bottomLeft: Radius.circular(
                                  format == BookingFormat.single
                                      ? 20
                                      : 0,
                                ),
                                topRight: Radius.circular(
                                  format == BookingFormat.single
                                      ? 0
                                      : 20,
                                ),
                                bottomRight: Radius.circular(
                                  format == BookingFormat.single
                                      ? 0
                                      : 20,
                                ),
                              ),
                              border: isSelected
                                  ? null
                                  : Border.all(
                                color: kBorderColor,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
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
                                  _localizedFormatLabel(
                                    context,
                                    format,
                                  ),
                                  style:
                                  AppStyles.w400f14inter.copyWith(
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
                    l10n.invitePlayers.toUpperCase(),
                    style: AppStyles.w500f12inter.copyWith(
                      color: kTextColor,
                    ),
                  ),
                  8.heightBox,

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<CourtsBloc, CourtsState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () =>
                                  _openInvitePlayers(state.players),
                              child: Container(
                                height: 44,
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(100),
                                  border: Border.all(
                                    color: kBorderColor,
                                  ),
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
                                      l10n.searchPlayers,
                                      style:
                                      AppStyles.w400f14inter.copyWith(
                                        color: kTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        if (_invitedPlayers.isNotEmpty) ...[
                          10.heightBox,
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _invitedPlayers.map((player) {
                              return Container(
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius:
                                  BorderRadius.circular(100),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundImage:
                                      NetworkImage(
                                        player.profilePhoto,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      player.name,
                                      style:
                                      AppStyles.w500f12inter.copyWith(
                                        color: kDarkTextColor,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: () => setState(
                                            () =>
                                            _invitedPlayers
                                                .remove(player),
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
                    l10n.payment.toUpperCase(),
                    style: AppStyles.w500f12inter.copyWith(
                      color: kTextColor,
                    ),
                  ),
                  8.heightBox,

                  ..._availablePaymentOptions.map((option) {
                    final isSelected = _paymentOption == option;

                    return GestureDetector(
                      onTap: () =>
                          setState(() => _paymentOption = option),
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
                          border: Border.all(
                            color: kWhiteColor,
                            width: 4,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius:
                                BorderRadius.circular(100),
                                border: Border.all(
                                  color: kPrimaryColor,
                                  width: isSelected ? 6 : 3,
                                ),
                              ),
                            ),
                            12.widthBox,
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _localizedPaymentTitle(
                                      context,
                                      option,
                                    ),
                                    style:
                                    AppStyles.w500f14inter.copyWith(
                                      color: kBlack12Color,
                                    ),
                                  ),
                                  2.heightBox,
                                  Text(
                                    _localizedPaymentDescription(
                                      context,
                                      option,
                                    ),
                                    style:
                                    AppStyles.w400f12inter.copyWith(
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
              '${l10n.book} - ${formatPrice(_displayAmount)}',
              onTap: _onBookTap,
            ),
          ),
        ],
      ),
    );
  }
}