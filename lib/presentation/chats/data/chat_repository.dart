import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/chats/data/chat_services.dart';
import 'package:quadraclub_app/presentation/chats/data/models/chat_model.dart';

class ChatRepository {
  final ChatServices chatServices = locator.get<ChatServices>();

  Future<List<Chat>> getChats() async {
    try {
      final response = await chatServices.getChats();

      final data = response.data as Map<String, dynamic>;

      final result = ChatsResponse.fromJson(data);

      return result.chats;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChatMessage>> getMessages(String chatId) async {
    try {
      final response = await chatServices.getMessages(chatId);

      final data = response.data as Map<String, dynamic>;

      final result = MessagesResponse.fromJson(data);

      return result.messages;
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatMessage?> sendMessage({
    required String content,
    required String chatId,
    List<dynamic> attachments = const [],
  }) async {
    try {
      final response = await chatServices.sendMessage(
        content: content,
        chatId: chatId,
        attachments: attachments,
      );

      final data = response.data as Map<String, dynamic>;

      if (data['message'] is Map) {
        return ChatMessage.fromJson(
          (data['message'] as Map).cast<String, dynamic>(),
        );
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markMessagesSeen(String chatId) async {
    try {
      await chatServices.markMessagesSeen(chatId);
    } catch (e) {
      rethrow;
    }
  }
}
