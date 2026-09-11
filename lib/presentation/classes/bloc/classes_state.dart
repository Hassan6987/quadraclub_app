part of 'classes_bloc.dart';

enum ClassStats { initial, loading, success, failure, fetching }

class ClassesState extends Equatable {
  final ClassStats status;
  final String? error;
  final List<Class> classes;
  final int balance;

  const ClassesState({
    this.status = ClassStats.initial,
    this.error,
    this.classes = const [],
    this.balance = 0,
  });

  @override
  List<Object?> get props => [status, error, classes, balance];

  ClassesState copyWith({
    ClassStats? status,
    String? error,
    List<Class>? classes,
    int? balance,
  }) {
    return ClassesState(
      status: status ?? this.status,
      error: error ?? this.error,
      classes: classes ?? this.classes,
      balance: balance ?? this.balance,
    );
  }
}
