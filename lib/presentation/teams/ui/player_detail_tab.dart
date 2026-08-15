// ─── Detail Tab ──────────────────────────────────────────────────────────────

import 'package:quadraclub_app/presentation/home/data/scanned_team_model.dart';
import 'package:quadraclub_app/presentation/team_roster/bloc/team_roster_bloc.dart';
import 'package:quadraclub_app/presentation/teams/data/scanned_athlete_events.dart';
import 'package:quadraclub_app/presentation/teams/data/scanned_athlete_timeline.dart';

import '../../../app_exports.dart';

class DetailTab extends StatelessWidget {
  const DetailTab({
    super.key,
    this.athlete,
    this.isAthleteInRoster = true,
    required this.completedEvents,
    required this.timelineMetrics,
    this.teamName,
  });

  final ScannedTeamAthlete? athlete;
  final String? teamName;
  final bool isAthleteInRoster;
  final List<CompletedEvent> completedEvents;
  final List<AthleteTimeline> timelineMetrics;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isAthleteInRoster) ...[
            PlayerHeaderCard(athlete: athlete!, teamName: teamName!),
            16.heightBox,
          ],

          // ── Latest Metrics ────────────────────────────────────────
          if (timelineMetrics.isNotEmpty) ...[
            Text(
              'Latest Metrics Detail',
              style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
            ),
            12.heightBox,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: timelineMetrics.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemBuilder: (context, index) {
                final metric = timelineMetrics[index];
                final latestValue = metric.timelineData.isNotEmpty
                    ? metric.timelineData.last.value
                    : null;
                return MetricCard(
                  icon: _metricIcon(metric.name),
                  value: latestValue != null ? _formatValue(latestValue) : '—',
                  label: metric.displayName,
                  unit: metric.unit,
                );
              },
            ),
            16.heightBox,
          ],

          // ── Events ────────────────────────────────────────────────
          if (completedEvents.isNotEmpty) ...[
            Text(
              'Verified Event Participation',
              style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
            ),
            12.heightBox,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: completedEvents.length,
              separatorBuilder: (_, __) => 8.heightBox,
              itemBuilder: (context, index) {
                return EventTile(event: completedEvents[index]);
              },
            ),
          ],
          12.heightBox,
          if (isAthleteInRoster && !athlete!.inRoster)
            CustomActionButton(
              buttonText: "Add to Roster",
              onTap: () {
                context.read<TeamRosterBloc>().add(
                  AddPlayerToRoster(playerId: athlete!.id),
                );
              },
              backgroundColor: kSecondaryColor,
            ),
          12.heightBox,
        ],
      ),
    );
  }
}

// ─── Player Header Card ───────────────────────────────────────────────────────

class PlayerHeaderCard extends StatelessWidget {
  const PlayerHeaderCard({
    super.key,
    required this.athlete,
    required this.teamName,
  });

  final ScannedTeamAthlete athlete;
  final String teamName;

  @override
  Widget build(BuildContext context) {
    final imageUrl = athlete.image;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFDDE1EC),
                backgroundImage:
                    (imageUrl != null && imageUrl.startsWith('http'))
                    ? NetworkImage(imageUrl)
                    : null,
                child: (imageUrl == null || !imageUrl.startsWith('http'))
                    ? const Icon(Icons.person, size: 24, color: kSecondaryColor)
                    : null,
              ),
              6.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      athlete.fullName,
                      style: AppStyles.subtitleMedium.copyWith(
                        color: kBlackColor,
                      ),
                    ),
                    4.heightBox,
                    Text(
                      athlete.email,
                      style: AppStyles.bodyRegular.copyWith(color: kBlackColor),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Graduation Year',
                    style: AppStyles.subtitleMedium.copyWith(
                      color: kBlackColor,
                    ),
                  ),
                  4.heightBox,
                  Text(
                    athlete.graduationYear?.toString() ?? '—',
                    style: AppStyles.bodyRegular.copyWith(color: kPrimaryColor),
                  ),
                ],
              ),
            ],
          ),
          8.heightBox,
          Wrap(
            spacing: 8,
            children: [
              Tag(label: teamName),
              if (athlete.position != null) ...[Tag(label: athlete.position!)],
            ],
          ),
        ],
      ),
    );
  }
}

class Tag extends StatelessWidget {
  const Tag({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: kPrimaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppStyles.bodyRegular.copyWith(color: kPrimaryColor),
      ),
    );
  }
}

// ─── Metric Card ──────────────────────────────────────────────────────────────

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.unit,
  });

  final IconData icon;
  final String value;
  final String label;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E4E7), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: Colors.white),
          ),
          const Spacer(),
          Text(
            value,
            style: AppStyles.titleMedium.copyWith(color: kPrimaryColor),
          ),
          4.heightBox,
          Text(
            '$label($unit)',
            style: AppStyles.bodyRegular.copyWith(
              color: kPrimaryColor.withValues(alpha: 0.7),
              fontSize: 10,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Event Tile ───────────────────────────────────────────────────────────────

class EventTile extends StatelessWidget {
  const EventTile({super.key, required this.event});

  final CompletedEvent event;

  String get _score {
    if (event.metrics.isEmpty) return '';
    final avg =
        event.metrics.map((m) => m.value).reduce((a, b) => a + b) /
        event.metrics.length;
    return avg.toStringAsFixed(1);
  }

  String get _formattedDate {
    try {
      final parts = event.eventDate.split('-');
      if (parts.length == 3) {
        return '${parts[1]}/${parts[2]}/${parts[0]}';
      }
      return event.eventDate;
    } catch (_) {
      return event.eventDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
                ),
                4.heightBox,
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: kTextColor,
                    ),
                    4.widthBox,
                    Text(
                      _formattedDate,
                      style: AppStyles.bodyRegular.copyWith(
                        color: kTextColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                4.heightBox,
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: kTextColor,
                    ),
                    4.widthBox,
                    Text(
                      event.location,
                      style: AppStyles.bodyRegular.copyWith(
                        color: kTextColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_score.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: kPrimaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Score: $_score',
                style: AppStyles.bodyRegular.copyWith(color: kPrimaryColor),
              ),
            ),
        ],
      ),
    );
  }
}

String _formatValue(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toStringAsFixed(2);
}

IconData _metricIcon(String metricName) {
  switch (metricName.toLowerCase()) {
    case 'pitch_velocity':
      return Icons.speed_outlined;
    case 'pop_time':
      return Icons.timer_outlined;
    case 'exit_velocity':
      return Icons.sports_baseball_outlined;
    case 'overhand_throw':
      return Icons.wifi;
    case 'home_to_first_speed':
      return Icons.directions_run_outlined;
    case 'transfer_time':
      return Icons.access_time_outlined;
    default:
      return Icons.analytics_outlined;
  }
}
