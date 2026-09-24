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
  submittingFeedback,
  feedbackSubmitted,
}

class AgendaState extends Equatable {
  final AgendaStateStatus status;
  final String? error;
  final List<AgendaItem> confirmedAgenda;
  final List<AgendaItem> pendingAgenda;
  final List<AgendaItem> pastAgenda;
  final List<AgendaItem> requestedBookings;
  final List<AgendaInvitation> invitations;
  final AgendaMatchDetails? matchDetails;
  final List<InvitePlayerModel> players;
  final double balance;
  final bool hasMissingFeedback;
  final int missingFeedbackCount;
  final List<MissingFeedbackMatch> missingFeedbackMatches;
  final bool showMissingFeedbackPrompt;

  const AgendaState({
    this.status = AgendaStateStatus.initial,
    this.error,
    this.confirmedAgenda = const [],
    this.pendingAgenda = const [],
    this.pastAgenda = const [],
    this.requestedBookings = const [],
    this.invitations = const [],
    this.matchDetails,
    this.players = const [],
    this.balance = 0.0,
    this.hasMissingFeedback = false,
    this.missingFeedbackCount = 0,
    this.missingFeedbackMatches = const [],
    this.showMissingFeedbackPrompt = false,
  });

  @override
  List<Object?> get props => [
    status,
    error,
    confirmedAgenda,
    pendingAgenda,
    pastAgenda,
    requestedBookings,
    invitations,
    matchDetails,
    players,
    balance,
    hasMissingFeedback,
    missingFeedbackCount,
    missingFeedbackMatches,
    showMissingFeedbackPrompt,
  ];

  AgendaState copyWith({
    AgendaStateStatus? status,
    String? error,
    List<AgendaItem>? confirmedAgenda,
    List<AgendaItem>? pendingAgenda,
    List<AgendaItem>? pastAgenda,
    List<AgendaItem>? requestedBookings,
    List<AgendaInvitation>? invitations,
    AgendaMatchDetails? matchDetails,
    List<InvitePlayerModel>? players,
    double? balance,
    bool? hasMissingFeedback,
    int? missingFeedbackCount,
    List<MissingFeedbackMatch>? missingFeedbackMatches,
    bool? showMissingFeedbackPrompt,
  }) {
    return AgendaState(
      status: status ?? this.status,
      error: error ?? this.error,
      confirmedAgenda: confirmedAgenda ?? this.confirmedAgenda,
      pendingAgenda: pendingAgenda ?? this.pendingAgenda,
      pastAgenda: pastAgenda ?? this.pastAgenda,
      requestedBookings: requestedBookings ?? this.requestedBookings,
      invitations: invitations ?? this.invitations,
      matchDetails: matchDetails ?? this.matchDetails,
      players: players ?? this.players,
      balance: balance ?? this.balance,
      hasMissingFeedback: hasMissingFeedback ?? this.hasMissingFeedback,
      missingFeedbackCount: missingFeedbackCount ?? this.missingFeedbackCount,
      missingFeedbackMatches:
          missingFeedbackMatches ?? this.missingFeedbackMatches,
      showMissingFeedbackPrompt:
          showMissingFeedbackPrompt ?? this.showMissingFeedbackPrompt,
    );
  }
}
