part of 'agenda_bloc.dart';

class AgendaEvent extends Equatable {
  const AgendaEvent();

  @override
  List<Object?> get props => [];
}

class GetAllAgenda extends AgendaEvent {}

class GetMatchDetails extends AgendaEvent {
  final String id;

  const GetMatchDetails({required this.id});
}

class InvitePlayers extends AgendaEvent {
  final List<String> playerIds;
  final String matchId;

  const InvitePlayers({required this.playerIds, required this.matchId});
}

class CancelPlayerInvite extends AgendaEvent {
  final String playerId;
  final String matchId;

  const CancelPlayerInvite({required this.playerId, required this.matchId});
}

class LeaveMatchEvent extends AgendaEvent {
  final String matchId;

  const LeaveMatchEvent({required this.matchId});
}
