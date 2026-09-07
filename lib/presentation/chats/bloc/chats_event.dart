part of 'chats_bloc.dart';

abstract class ChatsEvent {
  const ChatsEvent();
}

class LoadChats extends ChatsEvent {
  const LoadChats();
}

class NewSocketMessage extends ChatsEvent {
  final Map<String, dynamic> message;

  const NewSocketMessage(this.message);
}
