import 'package:equatable/equatable.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/data/match_repo.dart';

import '../../../app_exports.dart';

part 'matches_event.dart';
part 'matches_state.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  final MatchRepo _repo = locator.get<MatchRepo>();

  MatchesBloc() : super(MatchesState()) {
    on<GetAllBookings>(_handleGetAllBookings);
    on<FetchPortfolio>(_handleLoadBalance);
    on<JoinMatchBooking>(_handleJoinMatch);
    on<FetchPlayerDetails>(_handleGetUserDetails);
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

  Future<void> _handleLoadBalance(
    FetchPortfolio event,
    Emitter<MatchesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MatchesStateStatus.fetching));
      final balance = await _repo.getPortfolioBalance();
      emit(
        state.copyWith(status: MatchesStateStatus.success, balance: balance),
      );
    } catch (e) {
      emit(
        state.copyWith(status: MatchesStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleJoinMatch(
    JoinMatchBooking event,
    Emitter<MatchesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MatchesStateStatus.booking));
      await _repo.joinMatchBooking(
        id: event.bookingId,
        isPortfolio: event.isPortfolio,
        amount: event.amount,
        name: event.cardName,
        number: event.cardNumber,
        cvc: event.cvc,
        expiry: event.expiry,
        message: event.message,
      );
      final bookings = await _repo.getAllBookings();
      emit(
        state.copyWith(status: MatchesStateStatus.booked, bookings: bookings),
      );
    } catch (e) {
      emit(
        state.copyWith(status: MatchesStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleGetUserDetails(
    FetchPlayerDetails event,
    Emitter<MatchesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MatchesStateStatus.fetching));
      final user = await _repo.getUserDetails(event.id);
      emit(state.copyWith(status: MatchesStateStatus.success, user: user));
    } catch (e) {
      emit(
        state.copyWith(status: MatchesStateStatus.failure, error: e.toString()),
      );
    }
  }
}
