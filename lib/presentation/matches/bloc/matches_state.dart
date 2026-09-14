part of 'matches_bloc.dart';

enum MatchesStateStatus {
  initial,
  loading,
  success,
  failure,
  fetching,
  booking,
  booked
}

class MatchesState extends Equatable {
  final MatchesStateStatus status;
  final String? error;
  final List<Booking> bookings;
  final int balance;

  const MatchesState({
    this.status = MatchesStateStatus.initial,
    this.error,
    this.bookings = const [],
    this.balance = 0
  });

  @override
  List<Object?> get props => [status, error, bookings, balance];

  MatchesState copyWith({
    MatchesStateStatus? status,
    String? error,
    List<Booking>? bookings,
    int? balance
  }) {
    return MatchesState(
      status: status ?? this.status,
      error: error ?? this.error,
      bookings: bookings ?? this.bookings,
        balance: balance ?? this.balance
    );
  }
}
