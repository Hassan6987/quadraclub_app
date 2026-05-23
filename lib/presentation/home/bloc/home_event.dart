part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class ScanNFCTag extends HomeEvent {
  final String nfcId;

  const ScanNFCTag({required this.nfcId});
}

class ScanQRCode extends HomeEvent {
  final String userId;

  const ScanQRCode({required this.userId});
}

class GetScannedAthletes extends HomeEvent {}

class GetUserById extends HomeEvent {
  final int userId;

  const GetUserById({required this.userId});
}

class GetUserNotes extends HomeEvent {
  final int userId;

  const GetUserNotes({required this.userId});
}

class AddNote extends HomeEvent {
  final int userId;
  final String note;
  final String type;

  const AddNote({required this.userId, required this.note, required this.type});
}

class UpdateNote extends HomeEvent {
  final int userId;
  final String note;
  final String type;
  final int noteId;

  const UpdateNote({
    required this.userId,
    required this.note,
    required this.type,
    required this.noteId,
  });
}

class DeleteNote extends HomeEvent {
  final int userId;
  final int noteId;

  const DeleteNote({required this.userId, required this.noteId});
}

class AddRating extends HomeEvent {
  final int userId;
  final int rating;

  const AddRating({required this.userId, required this.rating});
}
