import 'package:equatable/equatable.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/classes/data/classes_repo.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';

import '../../../di/locator.dart';

part 'classes_event.dart';
part 'classes_state.dart';

class ClassesBloc extends Bloc<ClassesEvent, ClassesState> {
  final ClassesRepo _classesRepo = locator.get<ClassesRepo>();

  ClassesBloc() : super(ClassesState()) {
    on<FetchAllClasses>(_handleLoadClasses);
    on<FetchPortfolioBalance>(_handleLoadBalance);
    on<EnrollInClass>(_handleEnrollClass);
  }

  Future<void> _handleLoadClasses(
    FetchAllClasses event,
    Emitter<ClassesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ClassStats.loading));
      final classes = await _classesRepo.getAllClasses();
      emit(state.copyWith(status: ClassStats.success, classes: classes));
    } catch (e) {
      emit(state.copyWith(status: ClassStats.failure, error: e.toString()));
    }
  }

  Future<void> _handleLoadBalance(
    FetchPortfolioBalance event,
    Emitter<ClassesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ClassStats.fetching));
      final balance = await _classesRepo.getPortfolioBalance();
      emit(state.copyWith(status: ClassStats.success, balance: balance));
    } catch (e) {
      emit(state.copyWith(status: ClassStats.failure, error: e.toString()));
    }
  }

  Future<void> _handleEnrollClass(
    EnrollInClass event,
    Emitter<ClassesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ClassStats.loading));
      await _classesRepo.enrollInClass(
        id: event.classId,
        isPortfolio: event.isPortfolio,
        name: event.cardName,
        number: event.cardNumber,
        cvc: event.cvc,
        expiry: event.expiry,
      );
      final classes = await _classesRepo.getAllClasses();
      emit(state.copyWith(status: ClassStats.success, classes: classes));
    } catch (e) {
      emit(state.copyWith(status: ClassStats.failure, error: e.toString()));
    }
  }
}
