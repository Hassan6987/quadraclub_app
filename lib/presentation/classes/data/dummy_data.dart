

import 'package:quadraclub_app/presentation/classes/data/class_model.dart';
 const monthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
 const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
final _coachThiago = CoachModel(
  name: 'Thiago Souza',
  avatarAsset: 'assets/images/coach_thiago.png',
  category: 6,
);

final _coachMaria = CoachModel(
  name: 'Maria Fernanda',
  avatarAsset: 'assets/images/coach_maria.png',
  category: 5,
);

final _coachLucas = CoachModel(
  name: 'Lucas Pereira',
  avatarAsset: 'assets/images/coach_lucas.png',
  category: 7,
);

final _p1 = ParticipantModel(avatarAsset: 'assets/images/p1.png');
final _p2 = ParticipantModel(avatarAsset: 'assets/images/p2.png');
final _p3 = ParticipantModel(avatarAsset: 'assets/images/p3.png');

final List<ClassModel> dummyClasses = [
  // ── Today ──────────────────────────────────────────────────────────────────
  ClassModel(
    id: 'cls_001',
    title: 'Tennis Classroom - Serve',
    sport: SportType.tennis,
    categoryRange: 'B - D',
    format: ClassFormat.group,
    date: DateTime(2025, 4, 7),
    timeStart: '08:00',
    timeEnd: '09:30',
    location: 'Praia Club Ipanema',
    distanceKm: 5.6,
    coach: _coachThiago,
    price: 60,
    totalSlots: 6,
    filledSlots: 6,
    registrationDeadline: DateTime(2025, 4, 15, 6, 0),
    description:
    'Lesson focused on drop shots, smashes, and defense. For players in categories 5 to 7.',
    participants: [_p1, _p2, _p3],
  ),
  ClassModel(
    id: 'cls_002',
    title: 'Tennis Classroom - Serve',
    sport: SportType.tennis,
    categoryRange: 'B - D',
    format: ClassFormat.group,
    date: DateTime(2025, 4, 7),
    timeStart: '08:00',
    timeEnd: '09:30',
    location: 'Praia Club Ipanema',
    distanceKm: 5.6,
    coach: _coachThiago,
    price: 60,
    totalSlots: 6,
    filledSlots: 2,
    registrationDeadline: DateTime(2025, 4, 15, 6, 0),
    description:
    'Lesson focused on drop shots, smashes, and defense. For players in categories 5 to 7.',
    participants: [_p1, _p2],
  ),

  // ── Tomorrow ───────────────────────────────────────────────────────────────
  ClassModel(
    id: 'cls_003',
    title: 'Tennis Classroom - Serve',
    sport: SportType.pickleball,
    categoryRange: 'E',
    format: ClassFormat.individual,
    date: DateTime(2025, 4, 8),
    timeStart: '08:00',
    timeEnd: '09:30',
    location: 'Praia Club Ipanema',
    distanceKm: 5.6,
    coach: _coachThiago,
    price: 99,
    totalSlots: 1,
    filledSlots: 0,
    registrationDeadline: DateTime(2025, 4, 20, 8, 0),
    description:
    'Individual pickleball session tailored to your current level and specific weaknesses.',
    participants: [],
  ),

  // ── Apr 9 ──────────────────────────────────────────────────────────────────
  ClassModel(
    id: 'cls_004',
    title: 'Beach Tennis - Basics',
    sport: SportType.beachTennis,
    categoryRange: 'A - C',
    format: ClassFormat.group,
    date: DateTime(2025, 4, 9),
    timeStart: '10:00',
    timeEnd: '11:30',
    location: 'Barra Beach Club',
    distanceKm: 12.3,
    coach: _coachMaria,
    price: 75,
    totalSlots: 8,
    filledSlots: 5,
    registrationDeadline: DateTime(2025, 4, 18, 9, 0),
    description:
    'Introduction to beach tennis fundamentals. Perfect for players new to the sport.',
    participants: [_p1, _p2, _p3],
  ),
  ClassModel(
    id: 'cls_005',
    title: 'Pedal Cardio Blast',
    sport: SportType.pedal,
    categoryRange: 'All',
    format: ClassFormat.group,
    date: DateTime(2025, 4, 9),
    timeStart: '17:00',
    timeEnd: '18:00',
    location: 'Copacabana Sports Hub',
    distanceKm: 8.1,
    coach: _coachLucas,
    price: 45,
    totalSlots: 10,
    filledSlots: 3,
    registrationDeadline: DateTime(2025, 4, 19, 12, 0),
    description:
    'High-energy pedal session for all fitness levels. Great warm-up for tournament week.',
    participants: [_p1],
  ),

  // ── Apr 10 ─────────────────────────────────────────────────────────────────
  ClassModel(
    id: 'cls_006',
    title: 'Tennis - Advanced Rallying',
    sport: SportType.tennis,
    categoryRange: 'C - E',
    format: ClassFormat.group,
    date: DateTime(2025, 4, 10),
    timeStart: '07:00',
    timeEnd: '08:30',
    location: 'Praia Club Ipanema',
    distanceKm: 5.6,
    coach: _coachThiago,
    price: 60,
    totalSlots: 6,
    filledSlots: 4,
    registrationDeadline: DateTime(2025, 4, 21, 6, 0),
    description:
    'Advanced rally drills focusing on consistency and court positioning under pressure.',
    participants: [_p1, _p2, _p3],
  ),
];