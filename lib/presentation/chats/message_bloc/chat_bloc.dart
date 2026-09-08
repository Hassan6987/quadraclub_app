import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/chats/data/chat_repository.dart';
import 'package:quadraclub_app/presentation/chats/data/chat_socket_service.dart';
import 'package:quadraclub_app/presentation/chats/data/models/chat_model.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository = locator.get<ChatRepository>();

  final ChatSocketService socketService = locator.get<ChatSocketService>();

  late final StreamSubscription _messageSubscription;

  ChatBloc() : super(const ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<JoinChat>(_onJoinChat);
    on<SendMessage>(_onSendMessage);
    on<IncomingSocketMessage>(_onIncomingSocketMessage);
    on<MarkChatSeen>(_onMarkChatSeen);

    _messageSubscription = socketService.messageStream.listen((message) {
      add(IncomingSocketMessage(message));
    });
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());

    try {
      final messages = await repository.getMessages(event.chatId);

      emit(ChatLoaded(chatId: event.chatId, messages: messages));

      // Mark existing messages as seen.
      add(MarkChatSeen(event.chatId));
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  void _onJoinChat(JoinChat event, Emitter<ChatState> emit) {
    socketService.joinChat(event.chatId);
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatLoaded) return;

    final currentState = state as ChatLoaded;

    final content = event.content.trim();

    if (content.isEmpty) return;

    emit(currentState.copyWith(isSending: true));

    try {
      final sentMessage = await repository.sendMessage(
        content: content,
        chatId: event.chatId,
        attachments: event.attachments,
      );

      if (sentMessage != null) {
        // Broadcast new message over socket so other participants get real-time delivery
        if (sentMessage.rawJson.isNotEmpty) {
          socketService.emitNewMessage(sentMessage.rawJson);
        }

        final alreadyExists = currentState.messages.any(
          (message) => message.id == sentMessage.id,
        );

        if (!alreadyExists) {
          emit(
            currentState.copyWith(
              messages: [...currentState.messages, sentMessage],
              isSending: false,
            ),
          );
        } else {
          emit(currentState.copyWith(isSending: false));
        }
      } else {
        emit(currentState.copyWith(isSending: false));
      }
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  void _onIncomingSocketMessage(
    IncomingSocketMessage event,
    Emitter<ChatState> emit,
  ) {
    try {
      if (state is! ChatLoaded) return;

      final currentState = state as ChatLoaded;

      final message = ChatMessage.fromJson(event.message);

      if (message.chatId != currentState.chatId) {
        return;
      }

      // Prevent duplicates.
      final alreadyExists = currentState.messages.any(
            (item) => item.id == message.id,
      );

      if (alreadyExists) return;

      emit(
          currentState.copyWith(messages: [...currentState.messages, message]));

      // Automatically mark incoming messages as seen
      // because this chat is currently open.
      add(MarkChatSeen(currentState.chatId));
    } catch (_) {
      // Ignored
    }
  }

  Future<void> _onMarkChatSeen(
    MarkChatSeen event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await repository.markMessagesSeen(event.chatId);
    } catch (_) {
      // Don't break the chat UI if seen API fails.
    }
  }

  @override
  Future<void> close() {
    _messageSubscription.cancel();
    return super.close();
  }
}
