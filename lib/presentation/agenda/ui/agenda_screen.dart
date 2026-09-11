import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AgendaStatus.values.length,
      vsync: this,
    );
    _tabController.addListener(() {
      // rebuild so the action-label / anything tab-dependent updates
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState.user == null) {
          return const GuestLoginPrompt(
            title: 'My Reservations',
            subtitle: 'Sign in to view your reservations, games and lessons',
          );
        }

        return Scaffold(
          backgroundColor: kCardColor,
          appBar: CustomAppBar(
            title: "My Reservations,\nGames and Lessons",
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
                            Text(state.error ?? 'Something went wrong'),
                            TextButton(
                              onPressed: () => context.read<AgendaBloc>().add(
                                GetAllAgenda(),
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _agendaList(state.confirmedAgenda),
                        _agendaList(state.pendingAgenda),
                        _agendaList(state.pastAgenda),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _agendaList(List<AgendaItem> items) {
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

    if (filtered.isEmpty) {
      return const Center(child: Text('Nothing here yet'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        if (item.agendaType == AgendaType.class_) {
          return AgendaClassCard(
            item: item,
            actionLabel: _actionLabel,
          ).paddingOnly(bottom: 12);
        }
        return AgendaMatchCard(
          item: item,
          actionLabel: _actionLabel,
          onTap: () {
            context.read<AgendaBloc>().add(GetMatchDetails(id: item.id));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MatchDetailsScreen()),
            );
          },
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

  String _statusLabel(AgendaStatus status) => switch (status) {
    AgendaStatus.confirmed => 'Confirmed',
    AgendaStatus.pending => 'Pending',
    AgendaStatus.past => 'Past',
  };
}
