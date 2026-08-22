import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quadraclub_app/presentation/home/data/courts_repository.dart';
import 'package:quadraclub_app/presentation/home/data/models/court_model.dart';

import '../../../di/locator.dart';

part 'courts_event.dart';
part 'courts_state.dart';

class CourtsBloc extends Bloc<CourtsEvent, CourtsState> {
  final CourtsRepository _courtsRepo = locator.get<CourtsRepository>();

  CourtsBloc() : super(CourtsState()) {
    on<LoadCourts>(_handleLoadCourts);
  }

  Future<void> _handleLoadCourts(
    LoadCourts event,
    Emitter<CourtsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CourtStateStatus.loading));
      final courts = await _courtsRepo.getAllCourts();
      emit(state.copyWith(status: CourtStateStatus.success, courts: courts));
    } catch (e) {
      emit(
        state.copyWith(status: CourtStateStatus.failure, error: e.toString()),
      );
    }
  }
}
