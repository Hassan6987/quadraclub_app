part of 'matches_bloc.dart';

enum MatchesStateStatus { initial, loading, success, failure }

class MatchesState extends Equatable {
  final MatchesStateStatus status;
  final String? error;
  final List<Booking> bookings;

  const MatchesState({
    this.status = MatchesStateStatus.initial,
    this.error,
    this.bookings = const [],
  });

  @override
  List<Object?> get props => [status, error, bookings];

  MatchesState copyWith({
    MatchesStateStatus? status,
    String? error,
    List<Booking>? bookings,
  }) {
    return MatchesState(
      status: status ?? this.status,
      error: error ?? this.error,
      bookings: bookings ?? this.bookings,
    );
  }
}
