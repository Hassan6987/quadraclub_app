part of 'courts_bloc.dart';

class CourtsEvent extends Equatable {
  const CourtsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCourts extends CourtsEvent {}

class BookIndividual extends CourtsEvent {
  final IndividualBookingModel bookingData;

  const BookIndividual({required this.bookingData});
}

class BookMatch extends CourtsEvent {
  final MatchBookingModel bookingData;

  const BookMatch({required this.bookingData});
}

class FetchAllUsers extends CourtsEvent {}
