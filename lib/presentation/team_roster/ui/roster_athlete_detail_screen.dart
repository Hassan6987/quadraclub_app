import 'package:quadraclub_app/presentation/home/bloc/home_bloc.dart';
import 'package:quadraclub_app/presentation/team_roster/bloc/team_roster_bloc.dart';
import 'package:quadraclub_app/presentation/team_roster/widgets/athlete_detail_tab.dart';
import 'package:quadraclub_app/presentation/teams/ui/metrics_overview_screen.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

import '/app_exports.dart';
import '../../../utils/components/blue_app_bar.dart';

class RosterProfileScreen extends StatefulWidget {
  final int athleteId;

  const RosterProfileScreen({super.key, required this.athleteId});

  @override
  State<RosterProfileScreen> createState() => _RosterProfileScreenState();
}

class _RosterProfileScreenState extends State<RosterProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    context.read<HomeBloc>().add(GetUserById(userId: widget.athleteId));
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BlueAppBar(
        showBackArrow: true,
        height: 100,
        title: 'Athletes Profile',
      ),
      body: BlocListener<TeamRosterBloc, TeamRosterState>(
        listener: (context, state) {
          if (state.status == RosterStateStatus.deleted) {
            context.pop();
            context.showToast("Athlete removed from roster");
          } else if (state.status == RosterStateStatus.error) {
            context.showToast(
              state.errorMessage ?? "Failed to remove athlete from roster",
              isError: true,
            );
          }
        },
        child: Column(
          children: [
            CustomTabBar(controller: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  AthleteDetailTab(athleteId: widget.athleteId),
                  buildAthleteTimeline(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAthleteTimeline(BuildContext context) {
    return BlocBuilder<TeamRosterBloc, TeamRosterState>(
      builder: (context, state) {
        if (state.status == RosterStateStatus.fetching) {
          return Center(child: CustomLoadingView());
        } else if (state.status == RosterStateStatus.fetched) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: MetricsOverviewWidget(
              timelineMetrics: state.timelineMetrics,
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}

class CustomTabBar extends StatelessWidget {
  final TabController controller;

  const CustomTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final tabs = ['Detail', 'Metrics Overview'];

    return Container(
      color: Colors.white,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = controller.index == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.animateTo(index),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      tabs[index],
                      style: AppStyles.subtitleMedium.copyWith(
                        color: isSelected ? kPrimaryColor : Colors.grey[400],
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  // Full-width underline: primary if selected, grey if not
                  Container(
                    height: 3,
                    color: isSelected ? kPrimaryColor : Colors.grey[300],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
