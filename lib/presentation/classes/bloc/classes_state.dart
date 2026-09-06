part of 'classes_bloc.dart';

sealed class ClassesState extends Equatable {
  const ClassesState();
}

final class ClassesInitial extends ClassesState {
  @override
  List<Object> get props => [];
}
