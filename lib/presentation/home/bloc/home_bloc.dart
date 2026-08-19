// import 'package:equatable/equatable.dart';
// import 'package:quadraclub_app/presentation/authentication/data/auth_provider.dart';
// import 'package:quadraclub_app/presentation/home/data/athlete_model.dart';
// import 'package:quadraclub_app/presentation/home/data/note_model.dart';
// import 'package:quadraclub_app/presentation/home/data/rating_model.dart';
//
// import '../../../app_exports.dart';
// import '../../../di/locator.dart';
//
// part 'home_event.dart';
//
// part 'home_state.dart';
//
// class HomeBloc extends Bloc<HomeEvent, HomeState> {
//   final AuthProvider _authenticationProvider = locator.get<AuthProvider>();
//
//   HomeBloc() : super(HomeState()) {
//     on<GetScannedAthletes>(_handleGetScannedAthletes);
//     on<ScanNFCTag>(_handleScanNFC);
//     on<ScanQRCode>(_handleScanQR);
//     on<GetUserById>(_handleGetCurrentAthlete);
//     on<AddRating>(_handleGiveRating);
//     on<AddNote>(_handleAddNote);
//     on<UpdateNote>(_handleUpdateNote);
//     on<DeleteNote>(_handleDeleteNote);
//   }
//
//   Future<void> _handleGetScannedAthletes(
//     GetScannedAthletes event,
//     Emitter<HomeState> emit,
//   ) async {
//     emit(state.copyWith(status: HomeStateStatus.loading));
//     try {
//       final athletes = await _authenticationProvider.getScannedAthletes();
//       emit(
//         state.copyWith(
//           status: HomeStateStatus.success,
//           scannedAthletes: athletes,
//         ),
//       );
//     } catch (e) {
//       emit(state.copyWith(status: HomeStateStatus.error, error: e.toString()));
//     }
//   }
//
//   Future<void> _handleScanNFC(ScanNFCTag event, Emitter<HomeState> emit) async {
//     emit(state.copyWith(status: HomeStateStatus.scanning));
//     try {
//       await _authenticationProvider.scanNFC(nfcId: event.nfcId);
//       final athletes = await _authenticationProvider.getScannedAthletes();
//       emit(
//         state.copyWith(
//           status: HomeStateStatus.scanned,
//           scannedAthletes: athletes,
//         ),
//       );
//     } catch (e) {
//       emit(state.copyWith(status: HomeStateStatus.error, error: e.toString()));
//     }
//   }
//
//   Future<void> _handleScanQR(ScanQRCode event, Emitter<HomeState> emit) async {
//     emit(state.copyWith(status: HomeStateStatus.scanning));
//     try {
//       await _authenticationProvider.scanQRCode(userId: event.userId);
//       final athletes = await _authenticationProvider.getScannedAthletes();
//       emit(
//         state.copyWith(
//           status: HomeStateStatus.received,
//           scannedAthletes: athletes,
//         ),
//       );
//     } catch (e) {
//       emit(state.copyWith(status: HomeStateStatus.error, error: e.toString()));
//     }
//   }
//
//   Future<void> _handleGetCurrentAthlete(
//     GetUserById event,
//     Emitter<HomeState> emit,
//   ) async {
//     emit(state.copyWith(status: HomeStateStatus.fetching));
//
//     try {
//       // Run all API calls in parallel but isolate their failures
//       final results = await Future.wait([
//         _safeCall(
//           () => _authenticationProvider.getCurrentAthlete(event.userId),
//         ),
//         _safeCall(() => _authenticationProvider.getAthleteNotes(event.userId)),
//         _safeCall(
//           () => _authenticationProvider.getAthleteRatings(event.userId),
//         ),
//       ]);
//
//       final athlete = results[0] as AthleteModel?;
//       final notes = results[1] as List<NoteModel>?;
//       final ratings = results[2] as List<RatingModel>?;
//
//       emit(
//         state.copyWith(
//           status: HomeStateStatus.fetched,
//           currentAthlete: athlete ?? state.currentAthlete,
//           athleteNotes: notes ?? state.athleteNotes,
//           athleteRatings: ratings ?? state.athleteRatings,
//         ),
//       );
//     } catch (e) {
//       emit(state.copyWith(status: HomeStateStatus.error, error: e.toString()));
//     }
//   }
//
//   Future<T?> _safeCall<T>(Future<T> Function() call) async {
//     try {
//       return await call();
//     } catch (e) {
//       debugPrint("API call failed: $e");
//       return null;
//     }
//   }
//
//   Future<void> _handleGiveRating(
//     AddRating event,
//     Emitter<HomeState> emit,
//   ) async {
//     emit(state.copyWith(status: HomeStateStatus.fetching));
//     try {
//       await _authenticationProvider.giveRating(
//         userId: event.userId,
//         rating: event.rating,
//       );
//       add(GetUserById(userId: event.userId));
//     } catch (e) {
//       emit(state.copyWith(status: HomeStateStatus.error, error: e.toString()));
//     }
//   }
//
//   Future<void> _handleAddNote(AddNote event, Emitter<HomeState> emit) async {
//     emit(state.copyWith(status: HomeStateStatus.fetching));
//     try {
//       await _authenticationProvider.addNote(
//         userId: event.userId,
//         note: event.note,
//         type: event.type,
//       );
//       final notes = await _safeCall(
//         () => _authenticationProvider.getAthleteNotes(event.userId),
//       );
//       emit(
//         state.copyWith(
//           status: HomeStateStatus.fetched,
//           athleteNotes: notes ?? state.athleteNotes,
//         ),
//       );
//     } catch (e) {
//       emit(state.copyWith(status: HomeStateStatus.error, error: e.toString()));
//     }
//   }
//
//   Future<void> _handleUpdateNote(
//     UpdateNote event,
//     Emitter<HomeState> emit,
//   ) async {
//     emit(state.copyWith(status: HomeStateStatus.fetching));
//     try {
//       await _authenticationProvider.updateNote(
//         noteId: event.noteId,
//         note: event.note,
//         type: event.type,
//       );
//       final notes = await _safeCall(
//         () => _authenticationProvider.getAthleteNotes(event.userId),
//       );
//       emit(
//         state.copyWith(
//           status: HomeStateStatus.fetched,
//           athleteNotes: notes ?? state.athleteNotes,
//         ),
//       );
//     } catch (e) {
//       emit(state.copyWith(status: HomeStateStatus.error, error: e.toString()));
//     }
//   }
//
//   Future<void> _handleDeleteNote(
//     DeleteNote event,
//     Emitter<HomeState> emit,
//   ) async {
//     emit(state.copyWith(status: HomeStateStatus.fetching));
//     try {
//       await _authenticationProvider.deleteNote(noteId: event.noteId);
//       final notes = await _safeCall(
//         () => _authenticationProvider.getAthleteNotes(event.userId),
//       );
//       emit(
//         state.copyWith(
//           status: HomeStateStatus.fetched,
//           athleteNotes: notes ?? state.athleteNotes,
//         ),
//       );
//     } catch (e) {
//       emit(state.copyWith(status: HomeStateStatus.error, error: e.toString()));
//     }
//   }
// }
