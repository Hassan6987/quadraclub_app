// part of 'home_bloc.dart';
//
// enum HomeStateStatus {
//   initial,
//   loading,
//   success,
//   error,
//   scanning,
//   scanned,
//   received,
//   fetching,
//   fetched,
// }
//
// class HomeState extends Equatable {
//   final HomeStateStatus status;
//   final String? error;
//   final List<AthleteModel> scannedAthletes;
//   final List<NoteModel> athleteNotes;
//   final List<RatingModel> athleteRatings;
//   final AthleteModel? currentAthlete;
//
//   const HomeState({
//     this.status = HomeStateStatus.initial,
//     this.error,
//     this.scannedAthletes = const [],
//     this.athleteNotes = const [],
//     this.athleteRatings = const [],
//     this.currentAthlete,
//   });
//
//   HomeState copyWith({
//     HomeStateStatus? status,
//     String? error,
//     List<AthleteModel>? scannedAthletes,
//     List<NoteModel>? athleteNotes,
//     List<RatingModel>? athleteRatings,
//     AthleteModel? currentAthlete,
//   }) {
//     return HomeState(
//       status: status ?? this.status,
//       error: error ?? this.error,
//       scannedAthletes: scannedAthletes ?? this.scannedAthletes,
//       athleteNotes: athleteNotes ?? this.athleteNotes,
//       athleteRatings: athleteRatings ?? this.athleteRatings,
//       currentAthlete: currentAthlete ?? this.currentAthlete,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     status,
//     error,
//     scannedAthletes,
//     athleteNotes,
//     athleteRatings,
//     currentAthlete,
//   ];
// }
