import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/chats/data/chat_repository.dart';
import 'package:quadraclub_app/presentation/chats/data/chat_socket_service.dart';
import 'package:quadraclub_app/presentation/chats/data/models/chat_model.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatRepository repository = locator.get<ChatRepository>();
  final ChatSocketService socketService = locator.get<ChatSocketService>();

  late final StreamSubscription _messageSubscription;

  ChatsBloc() : super(const ChatsInitial()) {
    on<LoadChats>(_onLoadChats);
    on<NewSocketMessage>(_onNewSocketMessage);

    _messageSubscription = socketService.messageStream.listen((message) {
      add(NewSocketMessage(message));
    });
  }

  Future<void> _onLoadChats(LoadChats event, Emitter<ChatsState> emit) async {
    emit(const ChatsLoading());

    try {
      final chats = await repository.getChats();

      emit(ChatsLoaded(chats: chats));
    } catch (e) {
      emit(ChatsError(message: e.toString()));
    }
  }

  void _onNewSocketMessage(NewSocketMessage event, Emitter<ChatsState> emit) {
    if (state is! ChatsLoaded) return;

    final currentState = state as ChatsLoaded;

    final incoming = ChatMessage.fromJson(event.message);

    final chatId = incoming.chatId;

    if (chatId.isEmpty) return;

    final chats = currentState.chats.map((chat) {
      if (chat.id != chatId) return chat;

      return Chat(
        id: chat.id,
        chatName: chat.chatName,
        isGroupChat: chat.isGroupChat,
        users: chat.users,
        chatType: chat.chatType,
        createdAt: chat.createdAt,
        updatedAt: incoming.createdAt,
        latestMessage: incoming,
      );
    }).toList();

    emit(currentState.copyWith(chats: chats));
  }

  @override
  Future<void> close() {
    _messageSubscription.cancel();
    return super.close();
  }
}
