part of 'classes_bloc.dart';

class ClassesEvent extends Equatable {
  const ClassesEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllClasses extends ClassesEvent {}

class FetchClassDetails extends ClassesEvent {
  final String id;

  const FetchClassDetails({required this.id});
}
