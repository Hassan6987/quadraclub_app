import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:quadraclub_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:quadraclub_app/presentation/agenda/data/model/missing_feedback_model.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/club_feedback_dialog.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

import '/app_exports.dart';

class MatchFeedbackScreen extends StatefulWidget {
  final MissingFeedbackMatch match;

  const MatchFeedbackScreen({super.key, required this.match});

  @override
  State<MatchFeedbackScreen> createState() => _MatchFeedbackScreenState();
}

class _MatchFeedbackScreenState extends State<MatchFeedbackScreen> {
  late List<_SetScoreDraft> _sets;
  late Map<String, _PlayerFeedbackDraft> _playerFeedback;

  static const _scoreOptions = [0, 1, 2, 3, 4, 5, 6, 7];

  @override
  void initState() {
    super.initState();
    final existing = widget.match.scores;
    _sets = existing.isNotEmpty
        ? existing
              .map(
                (s) => _SetScoreDraft(team1: s.team1Score, team2: s.team2Score),
              )
              .toList()
        : [_SetScoreDraft(), _SetScoreDraft()];

    _playerFeedback = {
      for (final player in widget.match.allPlayers)
        if (player.id.isNotEmpty)
          player.id: _PlayerFeedbackDraft(player: player),
    };
  }

  List<MatchFeedbackTagOption> _tagOptions(AppLocalizations l10n) => [
    MatchFeedbackTagOption(
      label: l10n.tagGoodDefense,
      icon: Assets.svg.shieldIcon.path,
    ),
    MatchFeedbackTagOption(
      label: l10n.tagGoodAttack,
      icon: Assets.svg.chessIcon.path,
    ),
    MatchFeedbackTagOption(
      label: l10n.tagOneOff,
      icon: Assets.svg.circleTick.path,
    ),
    MatchFeedbackTagOption(
      label: l10n.tagStrategic,
      icon: Assets.svg.aimIcon.path,
    ),
    MatchFeedbackTagOption(label: l10n.tagArriveEarly, icon: null),
    MatchFeedbackTagOption(
      label: l10n.tagGoodEnergy,
      icon: Assets.svg.emoji.path,
    ),
  ];

  /// API expects English tag labels.
  String _apiTagLabel(String localized, AppLocalizations l10n) {
    if (localized == l10n.tagGoodDefense) return 'Good Defense';
    if (localized == l10n.tagGoodAttack) return 'Good Attack';
    if (localized == l10n.tagOneOff) return 'One-off';
    if (localized == l10n.tagStrategic) return 'Strategic';
    if (localized == l10n.tagArriveEarly) return 'Arrive Early';
    if (localized == l10n.tagGoodEnergy) return 'Good Energy';
    return localized;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final feedbackPlayers = widget.match.allPlayers
        .where((p) => p.id.isNotEmpty)
        .toList();

    return BlocConsumer<AgendaBloc, AgendaState>(
      listenWhen: (prev, curr) =>
          curr.status == AgendaStateStatus.feedbackSubmitted ||
          (curr.status == AgendaStateStatus.failure &&
              curr.error != null &&
              curr.error != prev.error),
      listener: (context, state) {
        if (state.status == AgendaStateStatus.feedbackSubmitted) {
          context.showToast(l10n.feedbackSubmitted);
          Navigator.pop(context);
        } else if (state.status == AgendaStateStatus.failure) {
          context.showToast(
            state.error ?? l10n.somethingWentWrong,
            isError: true,
          );
        }
      },
      builder: (context, state) {
        final submitting = state.status == AgendaStateStatus.submittingFeedback;

        return Scaffold(
          backgroundColor: kCardColor,
          appBar: CustomAppBar(
            title: l10n.matchFeedback,
            showBackIcon: true,
            showActions: false,
            showThreeDotActions: false,
            onThreeDotTap: () {},
            titleStyle: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.feedbackIntro,
                        style: AppStyles.w400f14inter.copyWith(
                          color: kTextColor,
                        ),
                      ),
                      16.heightBox,
                      _matchSummaryCard(l10n),
                      20.heightBox,
                      _teamsHeader(),
                      16.heightBox,
                      ...List.generate(_sets.length, (i) {
                        return _setRow(l10n, i);
                      }),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _sets.add(_SetScoreDraft())),
                        child: Text(
                          l10n.addAnotherSet,
                          style: AppStyles.w500f14inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                      ),
                      24.heightBox,
                      Text(
                        l10n.playersFeedback,
                        style: AppStyles.w600f16inter.copyWith(
                          color: kDarkTextColor,
                        ),
                      ),
                      12.heightBox,
                      ...feedbackPlayers.map(
                        (player) => _playerFeedbackCard(
                          l10n,
                          _playerFeedback.putIfAbsent(
                            player.id,
                            () => _PlayerFeedbackDraft(player: player),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (submitting)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CustomLoadingView(),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: CustomActionButton(
                    buttonText: l10n.completeMatch,
                    backgroundColor: kPrimaryColor,
                    onTap: () => _onCompleteMatch(l10n, feedbackPlayers),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _matchSummaryCard(AppLocalizations l10n) {
    final club = widget.match.club;
    final date = widget.match.bookingDate;
    final dateLabel = date == null
        ? ''
        : DateFormat('EEE, MMM d', l10n.localeName).format(date.toLocal());
    final court = widget.match.court?.courtName ?? '';
    final location = club?.location.isNotEmpty == true
        ? club!.location
        : [
            club?.city,
            club?.state,
          ].where((e) => (e ?? '').isNotEmpty).join(', ');

    return Container(
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
              imageUrl: club?.photo ?? '',
              height: 72,
              width: 72,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Image.asset(
                Assets.png.clubLogo.path,
                height: 72,
                width: 72,
                fit: BoxFit.cover,
              ),
            ),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  club?.name ?? '',
                  style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
                ),
                Text(
                  location,
                  style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
                ),
                Text(
                  [
                    dateLabel,
                    '${widget.match.startTime} - ${widget.match.endTime}',
                    if (court.isNotEmpty) court,
                  ].where((e) => e.isNotEmpty).join(' | '),
                  style: AppStyles.w500f12inter.copyWith(
                    color: kLightGreenColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamsHeader() {
    return Row(
      children: [
        Expanded(child: _teamAvatars(widget.match.team1)),
        Container(width: 1, height: 40, color: kBorderColor),
        Expanded(child: _teamAvatars(widget.match.team2, alignEnd: true)),
      ],
    );
  }

  Widget _teamAvatars(
    List<MissingFeedbackPlayer> players, {
    bool alignEnd = false,
  }) {
    if (players.isEmpty) {
      return const SizedBox(height: 40);
    }

    return Align(
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: SizedBox(
        height: 40,
        width: 28.0 * players.length + 12,
        child: Stack(
          children: [
            for (var i = 0; i < players.length; i++)
              Positioned(
                left: alignEnd ? null : i * 28.0,
                right: alignEnd ? i * 28.0 : null,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: kGreyColor,
                  backgroundImage: players[i].profilePhoto.isNotEmpty
                      ? NetworkImage(players[i].profilePhoto)
                      : null,
                  child: players[i].profilePhoto.isEmpty
                      ? const Icon(Icons.person, size: 18)
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _setRow(AppLocalizations l10n, int index) {
    final draft = _sets[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.setNumber(index + 1),
            style: AppStyles.w500f12inter.copyWith(color: kTextColor),
          ),
          6.heightBox,
          Row(
            children: [
              Expanded(
                child: _scoreDropdown(draft.team1, (v) {
                  setState(() => draft.team1 = v);
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'x',
                  style: AppStyles.w500f14inter.copyWith(color: kTextColor),
                ),
              ),
              Expanded(
                child: _scoreDropdown(draft.team2, (v) {
                  setState(() => draft.team2 = v);
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scoreDropdown(int? value, ValueChanged<int?> onChanged) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: kGreyColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          hint: Text(
            '-',
            style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
          ),
          items: _scoreOptions
              .map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(
                    '$s',
                    style: AppStyles.w500f14inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _playerFeedbackCard(
    AppLocalizations l10n,
    _PlayerFeedbackDraft draft,
  ) {
    final tags = _tagOptions(l10n);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: kGreyColor,
                backgroundImage: draft.player.profilePhoto.isNotEmpty
                    ? NetworkImage(draft.player.profilePhoto)
                    : null,
                child: draft.player.profilePhoto.isEmpty
                    ? const Icon(Icons.person, size: 18)
                    : null,
              ),
              10.widthBox,
              Expanded(
                child: Text(
                  draft.player.fullName,
                  style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    setState(() => draft.didNotShowUp = !draft.didNotShowUp),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: draft.didNotShowUp
                        ? kLightPinkColor
                        : kLightPinkColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: draft.didNotShowUp
                        ? Border.all(color: kRedColor.withValues(alpha: 0.4))
                        : null,
                  ),
                  child: Text(
                    l10n.didntShowUp,
                    style: AppStyles.w500f12inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (!draft.didNotShowUp) ...[
            12.heightBox,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) {
                final selected = draft.tags.contains(tag.label);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        draft.tags.remove(tag.label);
                      } else {
                        draft.tags.add(tag.label);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? kPrimaryColor : kGreyColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (tag.icon != null) ...[
                          SvgPicture.asset(tag.icon!, height: 14, width: 14),
                          6.widthBox,
                        ] else ...[
                          Icon(
                            tag.label == l10n.tagArriveEarly
                                ? Icons.schedule
                                : Icons.bolt,
                            size: 14,
                            color: kDarkTextColor,
                          ),
                          6.widthBox,
                        ],
                        Text(
                          tag.label,
                          style: AppStyles.w500f12inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  void _onCompleteMatch(
    AppLocalizations l10n,
    List<MissingFeedbackPlayer> feedbackPlayers,
  ) {
    final scores = <MatchSetScore>[];
    for (var i = 0; i < _sets.length; i++) {
      final set = _sets[i];
      if (set.team1 == null || set.team2 == null) continue;
      scores.add(
        MatchSetScore(
          set: i + 1,
          team1Score: set.team1!,
          team2Score: set.team2!,
        ),
      );
    }

    if (scores.isEmpty) {
      context.showToast(l10n.pleaseEnterScores, isError: true);
      return;
    }

    ClubFeedbackDialog.show(
      context,
      onComplete: (rating, feedback) {
        final playersFeedback = feedbackPlayers.map((player) {
          final draft = _playerFeedback[player.id]!;
          return PlayerFeedbackInput(
            userId: player.id,
            didNotShowUp: draft.didNotShowUp,
            tags: draft.didNotShowUp
                ? const []
                : draft.tags.map((t) => _apiTagLabel(t, l10n)).toList(),
          );
        }).toList();

        context.read<AgendaBloc>().add(
          SubmitMatchFeedback(
            matchId: widget.match.id,
            request: SubmitMatchFeedbackRequest(
              scores: scores,
              playersFeedback: playersFeedback,
              clubRating: rating,
              clubFeedback: feedback,
            ),
          ),
        );
      },
    );
  }
}

class _SetScoreDraft {
  int? team1;
  int? team2;

  _SetScoreDraft({this.team1, this.team2});
}

class _PlayerFeedbackDraft {
  _PlayerFeedbackDraft({required this.player});

  final MissingFeedbackPlayer player;
  bool didNotShowUp = false;
  final Set<String> tags = {};
}
