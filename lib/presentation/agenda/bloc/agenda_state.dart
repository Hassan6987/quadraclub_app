part of 'agenda_bloc.dart';

enum AgendaStateStatus {
  initial,
  loading,
  success,
  failure,
  error,
  fetching,
  fetched,
  updating,
  updated,
}

class AgendaState extends Equatable {
  final AgendaStateStatus status;
  final String? error;
  final List<AgendaItem> confirmedAgenda;
  final List<AgendaItem> pendingAgenda;
  final List<AgendaItem> pastAgenda;
  final List<AgendaInvitation> invitations;
  final AgendaMatchDetails? matchDetails;
  final List<InvitePlayerModel> players;
  final double balance;

  const AgendaState({
    this.status = AgendaStateStatus.initial,
    this.error,
    this.confirmedAgenda = const [],
    this.pendingAgenda = const [],
    this.pastAgenda = const [],
    this.invitations = const [],
    this.matchDetails,
    this.players = const [],
    this.balance = 0.0,
  });

  @override
  List<Object?> get props => [
    status,
    error,
    confirmedAgenda,
    pendingAgenda,
    pastAgenda,
    invitations,
    matchDetails,
    players,
    balance,
  ];

  AgendaState copyWith({
    AgendaStateStatus? status,
    String? error,
    List<AgendaItem>? confirmedAgenda,
    List<AgendaItem>? pendingAgenda,
    List<AgendaItem>? pastAgenda,
    List<AgendaInvitation>? invitations,
    AgendaMatchDetails? matchDetails,
    List<InvitePlayerModel>? players,
    double? balance,
  }) {
    return AgendaState(
      status: status ?? this.status,
      error: error ?? this.error,
      confirmedAgenda: confirmedAgenda ?? this.confirmedAgenda,
      pendingAgenda: pendingAgenda ?? this.pendingAgenda,
      pastAgenda: pastAgenda ?? this.pastAgenda,
      invitations: invitations ?? this.invitations,
      matchDetails: matchDetails ?? this.matchDetails,
      players: players ?? this.players,
      balance: balance ?? this.balance,
    );
  }
}
