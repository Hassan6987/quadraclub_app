part of 'classes_bloc.dart';

class ClassesEvent extends Equatable {
  const ClassesEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllClasses extends ClassesEvent {}

class FetchPortfolioBalance extends ClassesEvent {}

class EnrollInClass extends ClassesEvent {
  final String classId;
  final bool isPortfolio;
  final String? cardName;
  final String? cardNumber;
  final String? cvc;
  final String? expiry;

  const EnrollInClass({
    required this.classId,
    required this.isPortfolio,
    required this.cardName,
    required this.cardNumber,
    required this.cvc,
    required this.expiry,
  });
}
