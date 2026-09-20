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
  final double balance;

  const CourtsState({
    this.status = CourtStateStatus.initial,
    this.error,
    this.courts = const [],
    this.players = const [],
    this.balance = 0.0,
  });

  @override
  List<Object?> get props => [status, error, courts, players, balance];

  CourtsState copyWith({
    CourtStateStatus? status,
    String? error,
    List<Club>? courts,
    List<InvitePlayerModel>? players,
    double? balance,
  }) {
    return CourtsState(
      status: status ?? this.status,
      error: error ?? this.error,
      courts: courts ?? this.courts,
      players: players ?? this.players,
      balance: balance ?? this.balance,
    );
  }
}
