import 'package:quadraclub_app/presentation/classes/data/class_model.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';

final List<PlayerModel> dummyPlayers = [
  const PlayerModel(
    name: 'Alex',
    skillLevel: 'Beginner',
    avatarAsset: 'assets/images/p1.png',
    isAvailable: false,
  ),
  const PlayerModel(
    name: 'John',
    skillLevel: 'Beginner',
    avatarAsset: 'assets/images/p2.png',
    isAvailable: false,
  ),
  const PlayerModel(
    name: 'Marco',
    skillLevel: 'Beginner',
    avatarAsset: 'assets/images/p3.png',
    isAvailable: false,
  ),
  const PlayerModel(
    name: 'Lucas',
    skillLevel: 'Beginner',
    avatarAsset: 'assets/images/p1.png',
    isAvailable: false,
  ),
];

final List<MatchModel> dummyMatches = [
  // Today - Tennis
  MatchModel(
    id: 'match_001',
    sport: SportType.tennis,
    category: 'Category D',
    format: MatchFormat.doubles,
    date: DateTime(2025, 4, 7),
    timeStart: '16:00',
    timeEnd: '17:30',
    location: 'Riverside Sports Hub',
    city: 'Santa Monica',
    distanceKm: 2.5,
    courtStatus: CourtStatus.confirmed,
    totalSlots: 4,
    filledSlots: 2,
    description: 'Tennis match for beginner level players. Come play!',
    players: [
      dummyPlayers[0],
      dummyPlayers[1],
      const PlayerModel(name: 'Available', skillLevel: '', isAvailable: true, position: 'Left'),
      const PlayerModel(name: 'Available', skillLevel: '', isAvailable: true, position: 'Right'),
    ],
    imageAsset: 'assets/images/tennis_court_1.png',
  ),

  // Today - Pedal
  MatchModel(
    id: 'match_002',
    sport: SportType.pedal,
    category: 'Ranking',
    format: MatchFormat.doubles,
    date: DateTime(2025, 4, 7),
    timeStart: '18:00',
    timeEnd: '19:30',
    location: 'Downtown Sports Center',
    city: 'Santa Monica',
    distanceKm: 3.2,
    courtStatus: CourtStatus.confirmed,
    totalSlots: 4,
    filledSlots: 3,
    description: 'Pedal match for intermediate players. Competitive gameplay!',
    players: [
      dummyPlayers[2],
      dummyPlayers[3],
      dummyPlayers[0],
      const PlayerModel(name: 'Available', skillLevel: '', isAvailable: true, position: 'Right'),
    ],
    imageAsset: 'assets/images/pedal_court_1.png',
  ),

  // Tomorrow - Pickleball
  MatchModel(
    id: 'match_003',
    sport: SportType.pickleball,
    category: 'Category B',
    format: MatchFormat.doubles,
    date: DateTime(2025, 4, 8),
    timeStart: '10:00',
    timeEnd: '11:30',
    location: 'Beachside Courts',
    city: 'Santa Monica',
    distanceKm: 1.8,
    courtStatus: CourtStatus.pending,
    totalSlots: 4,
    filledSlots: 1,
    description: 'Pickleball doubles match. All skill levels welcome!',
    players: [
      dummyPlayers[1],
      const PlayerModel(name: 'Available', skillLevel: '', isAvailable: true, position: 'Left'),
      const PlayerModel(name: 'Available', skillLevel: '', isAvailable: true, position: 'Left'),
      const PlayerModel(name: 'Available', skillLevel: '', isAvailable: true, position: 'Right'),
    ],
    imageAsset: 'assets/images/pickleball_court_1.png',
  ),

  // Apr 9 - Tennis (Full)
  MatchModel(
    id: 'match_004',
    sport: SportType.tennis,
    category: 'Category C',
    format: MatchFormat.doubles,
    date: DateTime(2025, 4, 9),
    timeStart: '14:00',
    timeEnd: '15:30',
    location: 'Riverside Sports Hub',
    city: 'Santa Monica',
    distanceKm: 2.5,
    courtStatus: CourtStatus.confirmed,
    totalSlots: 4,
    filledSlots: 4,
    description: 'Competitive tennis match. Advanced players only.',
    players: [
      dummyPlayers[0],
      dummyPlayers[1],
      dummyPlayers[2],
      dummyPlayers[3],
    ],
    imageAsset: 'assets/images/tennis_court_2.png',
  ),

  // Apr 9 - Beach Tennis
  MatchModel(
    id: 'match_005',
    sport: SportType.beachTennis,
    category: 'Category A',
    format: MatchFormat.singles,
    date: DateTime(2025, 4, 9),
    timeStart: '09:00',
    timeEnd: '10:30',
    location: 'Ocean Beach Club',
    city: 'Santa Monica',
    distanceKm: 4.5,
    courtStatus: CourtStatus.confirmed,
    totalSlots: 2,
    filledSlots: 1,
    description: 'Beach tennis singles match. Great for beginners!',
    players: [
      dummyPlayers[2],
      const PlayerModel(name: 'Available', skillLevel: '', isAvailable: true),
    ],
    imageAsset: 'assets/images/beach_tennis_court_1.png',
  ),

  // Apr 10 - Pedal
  MatchModel(
    id: 'match_006',
    sport: SportType.pedal,
    category: 'Ranking',
    format: MatchFormat.doubles,
    date: DateTime(2025, 4, 10),
    timeStart: '17:00',
    timeEnd: '18:30',
    location: 'Central Park Courts',
    city: 'Santa Monica',
    distanceKm: 5.0,
    courtStatus: CourtStatus.pending,
    totalSlots: 4,
    filledSlots: 2,
    description: 'Evening pedal match. Relax and play!',
    players: [
      dummyPlayers[0],
      dummyPlayers[3],
      const PlayerModel(name: 'Available', skillLevel: '', isAvailable: true, position: 'Left'),
      const PlayerModel(name: 'Available', skillLevel: '', isAvailable: true, position: 'Right'),
    ],
    imageAsset: 'assets/images/pedal_court_2.png',
  ),
];
