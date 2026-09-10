import 'package:equatable/equatable.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/agenda/data/agenda_repo.dart';

part 'agenda_event.dart';
part 'agenda_state.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  final AgendaRepo _repo = locator.get<AgendaRepo>();

  AgendaBloc() : super(AgendaState()) {
    on<GetAllAgenda>(_handleLoadAgenda);
  }

  Future<void> _handleLoadAgenda(
    GetAllAgenda event,
    Emitter<AgendaState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AgendaStateStatus.loading));
      final confirmed = await _repo.getConfirmedAgenda();
      final pending = await _repo.getPendingAgenda();
      final past = await _repo.getPastAgenda();
      emit(
        state.copyWith(
          status: AgendaStateStatus.success,
          confirmedAgenda: confirmed,
          pendingAgenda: pending,
          pastAgenda: past,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AgendaStateStatus.failure, error: e.toString()),
      );
    }
  }
}
