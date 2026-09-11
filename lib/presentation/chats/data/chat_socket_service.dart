import 'dart:async';
import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketService {
  IO.Socket? _socket;
  String? _currentUserId;
  String? _activeChatId;

  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  bool get isConnected => _socket?.connected ?? false;

  void connect({
    required String serverUrl,
    required String userId,
    String? token,
  }) {
    _currentUserId = userId;

    if (_socket?.connected == true) {
      log('Socket already connected. Ensuring setup for user: $userId');
      _socket!.emit('setup', {'_id': userId});
      return;
    }

    final options = IO.OptionBuilder().setTransports([
      'websocket',
    ]).enableAutoConnect();

    if (token != null && token.isNotEmpty) {
      options.setAuth({'token': token});
    }

    _socket = IO.io(serverUrl, options.build());

    _socket!.connect();

    _socket!.onConnect((_) {
      log('✅ SOCKET CONNECTED: ${_socket?.id}');

      if (_currentUserId != null && _currentUserId!.isNotEmpty) {
        _socket!.emit('setup', {'_id': _currentUserId});
        log('✅ setup emitted for user: $_currentUserId');
      }

      if (_activeChatId != null && _activeChatId!.isNotEmpty) {
        _socket!.emit('join chat', _activeChatId);
        log('✅ Re-joined active chat: $_activeChatId');
      }
    });

    _socket!.on('message received', (data) {
      log('🟢 SOCKET MESSAGE RECEIVED: $data');

      if (data is Map) {
        _messageController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket!.onDisconnect((_) {
      log('❌ Socket disconnected');
    });

    _socket!.onConnectError((error) {
      log('⚠️ Socket connection error: $error');
    });

    _socket!.onError((error) {
      log('⚠️ Socket error: $error');
    });
  }

  void joinChat(String chatId) {
    _activeChatId = chatId;
    log('========================================');
    log('JOIN CHAT REQUEST');
    log('Chat ID: $chatId');
    log('Socket exists: ${_socket != null}');
    log('Socket connected: ${_socket?.connected}');
    log('Socket ID: ${_socket?.id}');
    log('========================================');

    if (_socket?.connected != true) {
      log('⚠️ Socket not yet connected. Will join chat on connect: $chatId');
      return;
    }

    log('✅ EMITTING join chat: $chatId');
    _socket!.emit('join chat', chatId);
  }

  void leaveChat() {
    _activeChatId = null;
  }

  void emitNewMessage(Map<String, dynamic> messageData) {
    if (_socket?.connected != true) {
      log('❌ Cannot emit new message. Socket is not connected.');
      return;
    }

    log('📤 Socket emitting new message: ${messageData['_id']}');
    _socket!.emit('new message', messageData);
  }

  void emitTyping(String chatId) {
    if (_socket?.connected == true) {
      _socket!.emit('typing', chatId);
    }
  }

  void emitStopTyping(String chatId) {
    if (_socket?.connected == true) {
      _socket!.emit('stop typing', chatId);
    }
  }

  void disconnect() {
    _activeChatId = null;
    _currentUserId = null;
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  Future<void> dispose() async {
    disconnect();

    if (!_messageController.isClosed) {
      await _messageController.close();
    }
  }
}
