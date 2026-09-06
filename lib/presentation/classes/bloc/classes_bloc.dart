import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'classes_event.dart';
part 'classes_state.dart';

class ClassesBloc extends Bloc<ClassesEvent, ClassesState> {
  ClassesBloc() : super(ClassesInitial()) {
    on<ClassesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
