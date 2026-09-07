part of 'chat_bloc.dart';

abstract class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  final String chatId;
  final List<ChatMessage> messages;
  final bool isSending;

  const ChatLoaded({
    required this.chatId,
    required this.messages,
    this.isSending = false,
  });

  ChatLoaded copyWith({
    String? chatId,
    List<ChatMessage>? messages,
    bool? isSending,
  }) {
    return ChatLoaded(
      chatId: chatId ?? this.chatId,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});
}
