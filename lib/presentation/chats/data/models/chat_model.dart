enum ChatType { game, classroom }

class ChatParticipant {
  final String id;
  final String name;
  final String? avatarUrl;

  const ChatParticipant({
    required this.id,
    required this.name,
    this.avatarUrl,
  });
}

class ChatPreview {
  final String id;
  final String venueName;
  final ChatType type;
  final DateTime scheduledAt;
  final String lastMessage;
  final int unreadCount;
  final String timeAgo;
  final List<ChatParticipant> participants;
  final int extraParticipantsCount;

  const ChatPreview({
    required this.id,
    required this.venueName,
    required this.type,
    required this.scheduledAt,
    required this.lastMessage,
    required this.unreadCount,
    required this.timeAgo,
    required this.participants,
    required this.extraParticipantsCount,
  });
}

class GroupChatDetail {
  final String id;
  final String title;
  final String subtitle;
  final List<ChatParticipant> participants;
  final List<ChatMessage> messages;

  const GroupChatDetail({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.participants,
    required this.messages,
  });
}


/////////////////////////////////////

class ChatUser {
  final String id;
  final String fullName;
  final String? email;
  final String? profilePhoto;

  const ChatUser({
    required this.id,
    required this.fullName,
    this.email,
    this.profilePhoto,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['_id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString(),
      profilePhoto: json['profilePhoto']?.toString(),
    );
  }
}

class ChatMessage {
  final String id;
  final ChatUser sender;
  final String content;
  final String chatId;
  final List<dynamic> attachments;
  final List<String> seenBy;
  final bool isSystemMessage;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.chatId,
    required this.attachments,
    required this.seenBy,
    required this.isSystemMessage,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final chat = json['chat'];

    String chatId = '';

    if (chat is String) {
      chatId = chat;
    } else if (chat is Map<String, dynamic>) {
      chatId = chat['_id']?.toString() ?? '';
    }

    return ChatMessage(
      id: json['_id']?.toString() ?? '',
      sender: ChatUser.fromJson(
        (json['sender'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      content: json['content']?.toString() ?? '',
      chatId: chatId,
      attachments: json['attachments'] as List? ?? [],
      seenBy: (json['seenBy'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      isSystemMessage: json['isSystemMessage'] == true,
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      )?.toLocal() ??
          DateTime.now(),
    );
  }
}

class Chat {
  final String id;
  final String chatName;
  final bool isGroupChat;
  final List<ChatUser> users;
  final String chatType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ChatMessage? latestMessage;

  const Chat({
    required this.id,
    required this.chatName,
    required this.isGroupChat,
    required this.users,
    required this.chatType,
    required this.createdAt,
    required this.updatedAt,
    this.latestMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id']?.toString() ?? '',
      chatName: json['chatName']?.toString() ?? '',
      isGroupChat: json['isGroupChat'] == true,
      users: (json['users'] as List?)
          ?.whereType<Map>()
          .map(
            (e) =>
            ChatUser.fromJson(
              e.cast<String, dynamic>(),
            ),
      )
          .toList() ??
          [],
      chatType: json['chatType']?.toString() ?? 'Normal',
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(
        json['updatedAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
      latestMessage: json['latestMessage'] is Map
          ? ChatMessage.fromJson(
        (json['latestMessage'] as Map).cast<String, dynamic>(),
      )
          : null,
    );
  }
}

class ChatsResponse {
  final bool success;
  final List<Chat> chats;

  const ChatsResponse({
    required this.success,
    required this.chats,
  });

  factory ChatsResponse.fromJson(Map<String, dynamic> json) {
    return ChatsResponse(
      success: json['success'] == true,
      chats: (json['chats'] as List?)
          ?.whereType<Map>()
          .map(
            (e) =>
            Chat.fromJson(
              e.cast<String, dynamic>(),
            ),
      )
          .toList() ??
          [],
    );
  }
}

class MessagesResponse {
  final bool success;
  final List<ChatMessage> messages;

  const MessagesResponse({
    required this.success,
    required this.messages,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) {
    return MessagesResponse(
      success: json['success'] == true,
      messages: (json['messages'] as List?)
          ?.whereType<Map>()
          .map(
            (e) =>
            ChatMessage.fromJson(
              e.cast<String, dynamic>(),
            ),
      )
          .toList() ??
          [],
    );
  }
}