part of 'matches_bloc.dart';

class MatchesEvent extends Equatable {
  const MatchesEvent();

  @override
  List<Object?> get props => [];
}

class GetAllBookings extends MatchesEvent {}

class FetchPortfolio extends MatchesEvent {}

class JoinMatchBooking extends MatchesEvent {
  final String bookingId;
  final bool isPortfolio;
  final double amount;
  final String? cardName;
  final String? cardNumber;
  final String? cvc;
  final String? expiry;
  final String? message;

  const JoinMatchBooking({
    required this.bookingId,
    required this.isPortfolio,
    required this.amount,
    required this.cardName,
    required this.cardNumber,
    required this.cvc,
    required this.expiry,
    this.message,
  });
}

class FetchPlayerDetails extends MatchesEvent {
  final String id;

  const FetchPlayerDetails({required this.id});
}
