import 'package:shimmer/shimmer.dart';
import 'package:quadraclub_app/presentation/home/data/scanned_team_model.dart';
import 'package:quadraclub_app/presentation/team_roster/bloc/team_roster_bloc.dart';
import 'package:quadraclub_app/presentation/teams/bloc/teams_bloc.dart';
import 'package:quadraclub_app/presentation/teams/ui/metrics_overview_screen.dart';
import 'package:quadraclub_app/presentation/teams/ui/player_detail_tab.dart';
import 'package:quadraclub_app/utils/components/blue_app_bar.dart';

import '../../../../app_exports.dart';

class TeamPlayerDetailScreen extends StatefulWidget {
  const TeamPlayerDetailScreen({
    super.key,
    required this.athlete,
    required this.teamName,
  });

  final ScannedTeamAthlete athlete;
  final String teamName;

  @override
  State<TeamPlayerDetailScreen> createState() => _TeamPlayerDetailScreenState();
}

class _TeamPlayerDetailScreenState extends State<TeamPlayerDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: "Team Player Detail",
        showBackArrow: true,
        height: 100,
      ),
      body: BlocListener<TeamRosterBloc, TeamRosterState>(
        listener: (context, rosterState) {
          if (rosterState.status == RosterStateStatus.success) {
            // Update the athlete's inRoster status when successfully added to roster
            widget.athlete.inRoster = true;
            // Also update TeamsBloc so the scanned team roster reflects the change
            context.read<TeamsBloc>().add(
              AddPlayerInRoster(athleteId: widget.athlete.id),
            );
            setState(() {});
          }
        },
        child: BlocBuilder<TeamsBloc, TeamsState>(
          builder: (context, state) {
            if (state.status == TeamStateStatus.fetching) {
              return const DetailTabShimmer();
            }
            return Column(
              children: [
                // ── Tab Bar ────────────────────────────────────────────
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFEEEEEE)),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: kPrimaryColor,
                    unselectedLabelColor: const Color(0xFFAAAAAA),
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    indicatorColor: kPrimaryColor,
                    indicatorWeight: 2.5,
                    tabs: const [
                      Tab(text: 'Detail'),
                      Tab(text: 'Metrics Overview'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      DetailTab(
                        athlete: widget.athlete,
                        teamName: widget.teamName,
                        completedEvents: state.completedEvents,
                        timelineMetrics: state.timelineMetrics,
                      ),
                      MetricsOverviewWidget(
                        timelineMetrics: state.timelineMetrics,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DetailTabShimmer extends StatelessWidget {
  const DetailTabShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ── Header Card ─────────────────────────────
            _box(height: 100, radius: 12),
            16.heightBox,

            /// ── Metrics Title ───────────────────────────
            _line(width: 180),
            12.heightBox,

            /// ── Metrics Grid ────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemBuilder: (_, __) => _box(height: 120, radius: 16),
            ),
            16.heightBox,

            /// ── Events Title ────────────────────────────
            _line(width: 220),
            12.heightBox,

            /// ── Events List ─────────────────────────────
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) => 8.heightBox,
              itemBuilder: (_, __) => _box(height: 70, radius: 10),
            ),

            16.heightBox,

            /// ── Button ──────────────────────────────────
            _box(height: 50, radius: 8),
          ],
        ),
      ),
    );
  }

  /// Reusable shimmer box
  Widget _box({double height = 16, double radius = 8}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  /// Reusable shimmer line (for titles/text)
  Widget _line({double width = double.infinity}) {
    return Container(height: 12, width: width, color: Colors.white);
  }
}
