part of 'courts_bloc.dart';

enum CourtStateStatus { initial, loading, success, failure }

class CourtsState extends Equatable {
  final CourtStateStatus status;
  final String? error;
  final List<Court> courts;

  const CourtsState({
    this.status = CourtStateStatus.initial,
    this.error,
    this.courts = const [],
  });

  @override
  List<Object?> get props => [status, error, courts];

  CourtsState copyWith({
    CourtStateStatus? status,
    String? error,
    List<Court>? courts,
  }) {
    return CourtsState(
      status: status ?? this.status,
      error: error ?? this.error,
      courts: courts ?? this.courts,
    );
  }
}
