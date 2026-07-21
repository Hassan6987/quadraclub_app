import '../models/chat_model.dart';

class ChatDummyData {
  ChatDummyData._();

  static final List<ChatParticipant> _sampleParticipants = const [
    ChatParticipant(id: 'p1', name: 'Alex'),
    ChatParticipant(id: 'p2', name: 'Diego'),
    ChatParticipant(id: 'p3', name: 'Maria'),
    ChatParticipant(id: 'p4', name: 'Johon'),
  ];

  static final List<ChatPreview> chatPreviews = [
    ChatPreview(
      id: 'c1',
      venueName: 'Arena Sports Club',
      type: ChatType.game,
      scheduledAt: DateTime(2025, 4, 20, 9, 0),
      lastMessage: 'You: See you there',
      unreadCount: 2,
      timeAgo: '15min',
      participants: _sampleParticipants.take(2).toList(),
      extraParticipantsCount: 3,
    ),
    ChatPreview(
      id: 'c2',
      venueName: 'Victory Tennis Center',
      type: ChatType.game,
      scheduledAt: DateTime(2025, 4, 20, 9, 0),
      lastMessage: 'Diego : professor confirmed the class!',
      unreadCount: 0,
      timeAgo: '15min',
      participants: _sampleParticipants.take(2).toList(),
      extraParticipantsCount: 3,
    ),
    ChatPreview(
      id: 'c3',
      venueName: 'Victory Tennis Center',
      type: ChatType.classroom,
      scheduledAt: DateTime(2025, 4, 20, 9, 0),
      lastMessage: 'You: See you there',
      unreadCount: 0,
      timeAgo: '15min',
      participants: [_sampleParticipants[0]],
      extraParticipantsCount: 0,
    ),
    ChatPreview(
      id: 'c4',
      venueName: 'Victory Tennis Center',
      type: ChatType.classroom,
      scheduledAt: DateTime(2025, 4, 20, 9, 0),
      lastMessage: 'You: See you there',
      unreadCount: 0,
      timeAgo: '15min',
      participants: [_sampleParticipants[1]],
      extraParticipantsCount: 0,
    ),
  ];

  static final GroupChatDetail groupChatDetail = GroupChatDetail(
    id: 'gc1',
    title: 'Group Chat',
    subtitle: 'Mixed Doubles Match',
    participants: _sampleParticipants.take(3).toList(),
    messages: [
      ChatMessage(
        id: 'm1',
        senderId: 'me',
        senderName: 'You',
        text: 'Hey everyone! Ready for the mixed doubles match today? 🏓',
        sentAt: DateTime(2025, 4, 19, 16, 12),
        isMe: true,
      ),
      ChatMessage(
        id: 'm2',
        senderId: 'p1',
        senderName: 'Alex',
        text: 'YES',
        sentAt: DateTime(2025, 4, 19, 16, 12),
        isMe: false,
      ),
      ChatMessage(
        id: 'm3',
        senderId: 'me',
        senderName: 'You',
        text: "Absolutely! I've booked the court for 5 PM at the Central Park.",
        sentAt: DateTime(2025, 4, 20, 16, 12),
        isMe: true,
      ),
    ],
  );
}
