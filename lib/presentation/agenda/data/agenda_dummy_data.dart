import 'package:quadraclub_app/presentation/agenda/data/model/agenda_model.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';

const courtImageUrl =
    'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?auto=format&fit=crop&w=1200&q=85';
const playerOneImageUrl =
    'https://images.unsplash.com/photo-1560012057-4373c9e2e4e5?auto=format&fit=crop&w=160&q=80';
const playerTwoImageUrl =
    'https://images.unsplash.com/photo-1542144582-1ba00456b5e3?auto=format&fit=crop&w=160&q=80';

const agendaMatches = [
  AgendaMatch(
    sport: SportType.pedal,
    venue: 'Riverside Sports Hub',
    location: 'Santa Monica · 2.5 miles · 24 Mar',
    time: '16:00-17:30',
    status: AgendaStatus.confirmed,
  ),AgendaMatch(
    sport: SportType.pedal,
    venue: 'Riverside Sports Hub',
    location: 'Santa Monica · 2.5 miles · 24 Mar',
    time: '16:00-17:30',
    status: AgendaStatus.pending,
  ),
];

const agendaClasses = [
  AgendaClass(
    sport: SportType.pickleball,
    title: 'Tennis Classroom - Serve',
    location: 'Praia Club Ipanema · 5.6 km',
    time: '08:00-09:30',
    price: 99,
    status: AgendaStatus.pending,
  ),
];
