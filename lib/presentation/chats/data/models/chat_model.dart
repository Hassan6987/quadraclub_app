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

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime sentAt;
  final bool isMe;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.sentAt,
    required this.isMe,
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
