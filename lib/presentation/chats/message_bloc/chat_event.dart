part of 'chat_bloc.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class LoadMessages extends ChatEvent {
  final String chatId;

  const LoadMessages(this.chatId);
}

class JoinChat extends ChatEvent {
  final String chatId;

  const JoinChat(this.chatId);
}

class SendMessage extends ChatEvent {
  final String chatId;
  final String content;
  final List<dynamic> attachments;

  const SendMessage({
    required this.chatId,
    required this.content,
    this.attachments = const [],
  });
}

class IncomingSocketMessage extends ChatEvent {
  final Map<String, dynamic> message;

  const IncomingSocketMessage(this.message);
}

class MarkChatSeen extends ChatEvent {
  final String chatId;

  const MarkChatSeen(this.chatId);
}
