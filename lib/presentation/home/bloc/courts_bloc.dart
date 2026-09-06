import 'package:equatable/equatable.dart';
import 'package:quadraclub_app/presentation/home/data/courts_repository.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/individual_booking_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/match_booking_model.dart';

import '../../../app_exports.dart';
import '../../../di/locator.dart';

part 'courts_event.dart';
part 'courts_state.dart';

class CourtsBloc extends Bloc<CourtsEvent, CourtsState> {
  final CourtsRepository _courtsRepo = locator.get<CourtsRepository>();

  CourtsBloc() : super(CourtsState()) {
    on<LoadCourts>(_handleLoadCourts);
    on<BookIndividual>(_handleBookIndividual);
    on<BookMatch>(_handleBookMatch);
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

  Future<void> _handleBookIndividual(
    BookIndividual event,
    Emitter<CourtsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CourtStateStatus.booking));
      await _courtsRepo.bookIndividual(event.bookingData);
      final courts = await _courtsRepo.getAllCourts();
      emit(state.copyWith(status: CourtStateStatus.booked, courts: courts));
    } catch (e) {
      emit(
        state.copyWith(status: CourtStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleBookMatch(
    BookMatch event,
    Emitter<CourtsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CourtStateStatus.booking));
      await _courtsRepo.bookMatch(event.bookingData);
      final courts = await _courtsRepo.getAllCourts();
      emit(state.copyWith(status: CourtStateStatus.booked, courts: courts));
    } catch (e) {
      emit(
        state.copyWith(status: CourtStateStatus.failure, error: e.toString()),
      );
    }
  }
}
