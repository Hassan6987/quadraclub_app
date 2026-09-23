part of 'chats_bloc.dart';

abstract class ChatsEvent {
  const ChatsEvent();
}

class LoadChats extends ChatsEvent {
  const LoadChats();
}

class MarkChatReadLocally extends ChatsEvent {
  final String chatId;
  final String userId;

  const MarkChatReadLocally({required this.chatId, required this.userId});
}

class NewSocketMessage extends ChatsEvent {
  final Map<String, dynamic> message;

  const NewSocketMessage(this.message);
}
