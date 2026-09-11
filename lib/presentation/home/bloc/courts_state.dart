part of 'courts_bloc.dart';

enum CourtStateStatus {
  initial,
  loading,
  success,
  failure,
  booking,
  booked,
  fetching,
}

class CourtsState extends Equatable {
  final CourtStateStatus status;
  final String? error;
  final List<Club> courts;
  final List<InvitePlayerModel> players;

  const CourtsState({
    this.status = CourtStateStatus.initial,
    this.error,
    this.courts = const [],
    this.players = const [],
  });

  @override
  List<Object?> get props => [status, error, courts, players];

  CourtsState copyWith({
    CourtStateStatus? status,
    String? error,
    List<Club>? courts,
    List<InvitePlayerModel>? players,
  }) {
    return CourtsState(
      status: status ?? this.status,
      error: error ?? this.error,
      courts: courts ?? this.courts,
      players: players ?? this.players,
    );
  }
}
