part of 'agenda_bloc.dart';

enum AgendaStateStatus { initial, loading, success, failure }

class AgendaState extends Equatable {
  final AgendaStateStatus status;
  final String? error;
  final List<AgendaItem> confirmedAgenda;
  final List<AgendaItem> pendingAgenda;
  final List<AgendaItem> pastAgenda;

  const AgendaState({
    this.status = AgendaStateStatus.initial,
    this.error,
    this.confirmedAgenda = const [],
    this.pendingAgenda = const [],
    this.pastAgenda = const [],
  });

  @override
  List<Object?> get props => [
    status,
    error,
    confirmedAgenda,
    pendingAgenda,
    pastAgenda,
  ];

  AgendaState copyWith({
    AgendaStateStatus? status,
    String? error,
    List<AgendaItem>? confirmedAgenda,
    List<AgendaItem>? pendingAgenda,
    List<AgendaItem>? pastAgenda,
  }) {
    return AgendaState(
      status: status ?? this.status,
      error: error ?? this.error,
      confirmedAgenda: confirmedAgenda ?? this.confirmedAgenda,
      pendingAgenda: pendingAgenda ?? this.pendingAgenda,
      pastAgenda: pastAgenda ?? this.pendingAgenda,
    );
  }
}
