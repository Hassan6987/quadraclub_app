import '../../../app_exports.dart';

enum StatFilter { weekly, monthly, overall }

class UserProfile {
  final String name;
  final String? avatarUrl;
  final List<SportTag> sports;
  final PlayerStats stats;
  final GameInfo gameInfo;
  final List<FeedbackTag> feedback;

  const UserProfile({
    required this.name,
    this.avatarUrl,
    required this.sports,
    required this.stats,
    required this.gameInfo,
    required this.feedback,
  });
}

class SportTag {
  final String sport;
  final String category;

  const SportTag({required this.sport, required this.category});
}

class PlayerStats {
  final int matches;
  final int victories;
  final int defeats;
  final double hours;

  const PlayerStats({
    required this.matches,
    required this.victories,
    required this.defeats,
    required this.hours,
  });
}

class GameInfo {
  final String dominantHand;
  final String preferredSide;

  const GameInfo({required this.dominantHand, required this.preferredSide});
}

class FeedbackTag {
  final String icon;
  final String label;
  final int count;

  const FeedbackTag({
    required this.icon,
    required this.label,
    required this.count,
  });
}

final dummyProfile = UserProfile(
  name: 'Alex Johnson',
  avatarUrl: null,
  sports: const [
    SportTag(sport: 'Pedal', category: 'Cat 3'),
    SportTag(sport: 'Tennis', category: 'Cat 2'),
    SportTag(sport: 'Beach Tennis', category: 'Cat 1'),
    SportTag(sport: 'Pickleball', category: 'Cat 3'),
  ],
  stats: const PlayerStats(matches: 3, victories: 2, defeats: 1, hours: 4.5),
  gameInfo: const GameInfo(
    dominantHand: 'Right',
    preferredSide: 'Right (Forehand)',
  ),
  feedback: [
    FeedbackTag(
      icon: Assets.svg.shieldIcon.path,
      label: 'Good Defense',
      count: 8,
    ),
    FeedbackTag(
      icon: Assets.svg.chessIcon.path,
      label: 'Good Attack',
      count: 4,
    ),
    FeedbackTag(icon: Assets.svg.circleTick.path, label: 'One-off', count: 2),
    FeedbackTag(icon: Assets.svg.aimIcon.path, label: 'Strategic', count: 1),
    FeedbackTag(icon: Assets.svg.emoji.path, label: 'Good Humor', count: 1),
  ],
);
