part of 'classes_bloc.dart';


enum ClassStats { initial, loading, success, failure }

class ClassesState extends Equatable {
  final ClassStats status;
  final String? error;
  final List<Class> classes;

  const ClassesState(
      {this.status = ClassStats.initial, this.error, this.classes = const []});

  @override
  List<Object?> get props => [status, error, classes];

  ClassesState copyWith({
    ClassStats? status,
    String? error,
    List<Class>? classes,
  }) {
    return ClassesState(
      status: status ?? this.status,
      error: error ?? this.error,
      classes: classes ?? this.classes,
    );
  }
}
