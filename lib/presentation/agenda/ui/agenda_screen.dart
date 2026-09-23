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
          listenWhen: (prev, curr) =>
              curr.showMissingFeedbackPrompt && !prev.showMissingFeedbackPrompt,
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
                      if (state.status == AgendaStateStatus.loading ||
                          state.status == AgendaStateStatus.initial) {
                        return const Center(child: CustomLoadingView());
                      }
                      if (state.status == AgendaStateStatus.failure) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(state.error ?? l10n.somethingWentWrong),
                              TextButton(
                                onPressed: () => context.read<AgendaBloc>().add(
                                  GetAllAgenda(),
                                ),
                                child: Text(l10n.retry),
                              ),
                            ],
                          ),
                        );
                      }

                      return TabBarView(
                        controller: _tabController,
                        children: [
                          _agendaList(state.confirmedAgenda, []),
                          _agendaList(state.pendingAgenda, state.invitations),
                          _agendaList(state.pastAgenda, []),
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

  Widget _agendaList(
    List<AgendaItem> items,
    List<AgendaInvitation> invitations,
  ) {
    final filtered = items.where((item) {
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
    }).toList();

    final totalCount = filtered.length + invitations.length;

    if (totalCount == 0) {
      return Center(child: Text(AppLocalizations.of(context)!.nothingHereYet));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        if (index < filtered.length) {
          final item = filtered[index];
          if (item.agendaType == AgendaType.class_) {
            return AgendaClassCard(
              item: item,
              actionLabel: _actionLabel,
            ).paddingOnly(bottom: 12);
          } else if (item.agendaType == AgendaType.court) {
            return AgendaCourtCard(item: item).paddingOnly(bottom: 12);
          }
          return AgendaMatchCard(
            item: item,
            onTap: () {
              if (item.tab == "confirmed") {
                context.read<AgendaBloc>().add(GetMatchDetails(id: item.id));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MatchDetailsScreen()),
                );
              }
            },
          ).paddingOnly(bottom: 12);
        }

        final invitation = invitations[index - filtered.length];
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
                  builder: (context) => AgendaPaymentScreen(match: invitation),
                ),
              );
            }
          },
          onReject: () => context.read<AgendaBloc>().add(
            RespondToInvitation(id: invitation.id, action: "reject"),
          ),
        ).paddingOnly(bottom: 12);
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
