part of 'chats_bloc.dart';

abstract class ChatsState {
  const ChatsState();
}

class ChatsInitial extends ChatsState {
  const ChatsInitial();
}

class ChatsLoading extends ChatsState {
  const ChatsLoading();
}

class ChatsLoaded extends ChatsState {
  final List<Chat> chats;

  const ChatsLoaded({required this.chats});

  ChatsLoaded copyWith({List<Chat>? chats}) {
    return ChatsLoaded(chats: chats ?? this.chats);
  }
}

class ChatsError extends ChatsState {
  final String message;

  const ChatsError({required this.message});
}
