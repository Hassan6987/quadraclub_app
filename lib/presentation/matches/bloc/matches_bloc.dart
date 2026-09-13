import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/data/match_repo.dart';

part 'matches_event.dart';
part 'matches_state.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  final MatchRepo _repo = locator.get<MatchRepo>();

  MatchesBloc() : super(MatchesState()) {
    on<GetAllBookings>(_handleGetAllBookings);
  }

  Future<void> _handleGetAllBookings(
    GetAllBookings event,
    Emitter<MatchesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MatchesStateStatus.loading));
      final bookings = await _repo.getAllBookings();
      emit(
        state.copyWith(status: MatchesStateStatus.success, bookings: bookings),
      );
    } catch (e) {
      emit(
        state.copyWith(status: MatchesStateStatus.failure, error: e.toString()),
      );
    }
  }
}
