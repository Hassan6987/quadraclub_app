import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:quadraclub_app/presentation/agenda/data/model/agenda_invitation_model.dart';
import 'package:quadraclub_app/presentation/agenda/ui/match_feedback_screen.dart';
import 'package:quadraclub_app/presentation/agenda/ui/payment_screen.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/agenda_court_card.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/agenda_invitation_card.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/missing_feedback_dialog.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

class AgendaScreen extends StatefulWidget {
  /// 0 = Confirmed, 1 = Pending, 2 = Past.
  final int initialTabIndex;

  const AgendaScreen({super.key, this.initialTabIndex = 0});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _filter = 'All';
  bool _checkedMissingFeedback = false;
  bool _showingMissingDialog = false;

  @override
  void initState() {
    super.initState();
    final initialIndex = widget.initialTabIndex.clamp(
      0,
      AgendaStatus.values.length - 1,
    );
    _tabController = TabController(
      length: AgendaStatus.values.length,
      vsync: this,
      initialIndex: initialIndex,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  AgendaStatus get _currentStatus => AgendaStatus.values[_tabController.index];

  String? get _actionLabel => switch (_currentStatus) {
    AgendaStatus.confirmed => 'Chat',
    AgendaStatus.pending => 'Cancel request',
    AgendaStatus.past => null,
  };

  void _maybeCheckMissingFeedback(bool isLoggedIn) {
    if (!isLoggedIn || _checkedMissingFeedback) return;
    _checkedMissingFeedback = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AgendaBloc>().add(CheckMissingFeedback());
    });
  }

  void _openMissingFeedbackPrompt(AgendaState state) {
    if (_showingMissingDialog || !state.showMissingFeedbackPrompt) return;
    if (state.missingFeedbackMatches.isEmpty) return;

    _showingMissingDialog = true;
    context.read<AgendaBloc>().add(ClearMissingFeedbackPrompt());

    MissingFeedbackDialog.show(
      context,
      missingCount: state.missingFeedbackCount,
      onGiveFeedback: () {
        final match = state.missingFeedbackMatches.first;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MatchFeedbackScreen(match: match)),
        ).then((_) {
          if (!mounted) return;
          // Re-check in case more matches still need feedback.
          context.read<AgendaBloc>().add(CheckMissingFeedback());
        });
      },
    ).whenComplete(() => _showingMissingDialog = false);
  }

  bool _matchesFilter(AgendaItem item) {
    switch (_filter) {
      case 'Courts':
        return item.agendaType == AgendaType.court;
      case 'Games':
        return item.agendaType == AgendaType.game;
      case 'Classes':
        return item.agendaType == AgendaType.class_;
      default:
        return true;
    }
  }

  Widget _agendaList(
      List<AgendaItem> items,
      List<AgendaInvitation> invitations,
      List<AgendaItem> joinRequests, {
        required bool ascending,
      }) {
    final entries = <_AgendaEntry>[
      for (final i in items.where(_matchesFilter))
        _AgendaEntry.item(i, isJoinRequest: false),
      for (final r in joinRequests.where(_matchesFilter))
        _AgendaEntry.item(r, isJoinRequest: true),
      for (final inv in invitations) _AgendaEntry.invitation(inv),
    ]..sort((a, b) {
      // bookingDate is a date, so break same-day ties by start time.
      var cmp = a.date.compareTo(b.date);
      if (cmp == 0) cmp = a.time.compareTo(b.time);
      return ascending ? cmp : -cmp;
    });

    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: _refreshAgenda,
      child: entries.isEmpty
          ? ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.45,
            child: Center(
              child: Text(AppLocalizations.of(context)!.nothingHereYet),
            ),
          ),
        ],
      )
          : ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];

          if (entry.item != null) {
            return _buildAgendaItemCard(
              entry.item!,
              isJoinRequest: entry.isJoinRequest,
            );
          }

          final invitation = entry.invitation!;
          return AgendaInvitationCard(
            item: invitation,
            onAccept: () {
              if (!invitation.requiresPayment) {
                context.read<AgendaBloc>().add(
                  RespondToInvitation(id: invitation.id, action: "accept"),
                );
              } else {
                context.read<AgendaBloc>().add(FetchPortfolio());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AgendaPaymentScreen(match: invitation),
                  ),
                );
              }
            },
            onReject: () => context.read<AgendaBloc>().add(
              RespondToInvitation(id: invitation.id, action: "reject"),
            ),
          ).paddingOnly(bottom: 12);
        },
      ),
    );
  }

  Future<void> _refreshAgenda() async {
    context.read<AgendaBloc>().add(GetAllAgenda());
    await context.read<AgendaBloc>().stream.firstWhere(
      (s) =>
          s.status == AgendaStateStatus.success ||
          s.status == AgendaStateStatus.failure,
    );
  }

  Widget _buildAgendaItemCard(AgendaItem item, {required bool isJoinRequest}) {
    if (item.agendaType == AgendaType.class_) {
      return AgendaClassCard(
        item: item,
        actionLabel: _actionLabel,
      ).paddingOnly(bottom: 12);
    }
    else if (item.agendaType == AgendaType.court) {
      return AgendaCourtCard(item: item).paddingOnly(bottom: 12);
    }
    return AgendaMatchCard(
      item: item,
      isJoinRequest: isJoinRequest,
      onTap: () {
        if (item.tab == "confirmed" || (item.tab == "pending" && !isJoinRequest)) {
          context.read<AgendaBloc>().add(GetMatchDetails(id: item.id));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MatchDetailsScreen(isOwner: item.isOwner,matchId: item.id,)),
          );
        }
      },
    ).paddingOnly(bottom: 12);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState.user == null) {
          return GuestLoginPrompt(
            title: l10n.myReservations,
            subtitle: l10n.signInToViewReservations,
          );
        }

        _maybeCheckMissingFeedback(true);

        return BlocListener<AgendaBloc, AgendaState>(
          listenWhen: (prev, curr) => curr.showMissingFeedbackPrompt && !prev.showMissingFeedbackPrompt,
          listener: (context, state) => _openMissingFeedbackPrompt(state),
          child: Scaffold(
            backgroundColor: kCardColor,
            appBar: CustomAppBar(
              title: l10n.myReservationsGamesAndLessons,
              centerTile: false,
              backgroundColor: kWhiteColor,
            ),
            body: Column(
              children: [
                _statusTabBar(),
                Container(
                  color: kWhiteColor,
                  child: AgendaFilterChips(
                    selectedFilter: _filter,
                    onSelected: (filter) => setState(() => _filter = filter),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<AgendaBloc, AgendaState>(
                    builder: (context, state) {
                      final hasData =
                          state.confirmedAgenda.isNotEmpty ||
                          state.pendingAgenda.isNotEmpty ||
                          state.pastAgenda.isNotEmpty ||
                          state.invitations.isNotEmpty ||
                          state.requestedBookings.isNotEmpty;

                      final isInitialLoad =
                          (state.status == AgendaStateStatus.loading ||
                              state.status == AgendaStateStatus.initial) &&
                          !hasData;

                      if (isInitialLoad) {
                        return const Center(child: CustomLoadingView());
                      }
                      return TabBarView(
                        controller: _tabController,
                        children: [
                          _agendaList(state.confirmedAgenda, [], [], ascending: true),
                          _agendaList(
                            state.pendingAgenda,
                            state.invitations,
                            state.requestedBookings, ascending: true,
                          ),
                          _agendaList(state.pastAgenda, [], [], ascending: false),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statusTabBar() => Container(
    color: kWhiteColor,
    child: TabBar(
      controller: _tabController,
      labelColor: kDarkTextColor,
      unselectedLabelColor: kGreyTextColor,
      labelStyle: AppStyles.w500f14inter,
      unselectedLabelStyle: AppStyles.w500f14inter,
      indicatorColor: kBlueColor,
      indicatorWeight: 2,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: kDividerColor,
      tabs: AgendaStatus.values
          .map((status) => Tab(text: _statusLabel(status)))
          .toList(),
    ),
  );

  String _statusLabel(AgendaStatus status) {
    final l10n = AppLocalizations.of(context)!;
    return switch (status) {
      AgendaStatus.confirmed => l10n.confirmed,
      AgendaStatus.pending => l10n.pending,
      AgendaStatus.past => l10n.past,
    };
  }
}




/// One row in the agenda list: a regular item, a join request, or an
/// invitation. Lets the three sources be sorted together.
class _AgendaEntry {
  final DateTime date;
  final String time;
  final AgendaItem? item;
  final bool isJoinRequest;
  final AgendaInvitation? invitation;

  _AgendaEntry.item(AgendaItem i, {required this.isJoinRequest})
      : item = i,
        invitation = null,
        date = i.bookingDate,
        time = i.startTime;

  _AgendaEntry.invitation(AgendaInvitation inv)
      : invitation = inv,
        item = null,
        isJoinRequest = false,
        date = inv.bookingDate ?? DateTime.now(),
        time = inv.startTime;
}