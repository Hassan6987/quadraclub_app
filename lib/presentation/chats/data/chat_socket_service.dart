import 'dart:async';
import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketService {
  IO.Socket? _socket;

  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  bool get isConnected => _socket?.connected ?? false;

  void connect({
    required String serverUrl,
    required String userId,
    String? token,
  }) {
    if (_socket?.connected == true) {
      log('Socket already connected');
      return;
    }

    final options = IO.OptionBuilder().setTransports([
      'websocket',
    ]).disableAutoConnect();

    if (token != null && token.isNotEmpty) {
      options.setAuth({'token': token});
    }

    _socket = IO.io(serverUrl, options.build());

    _socket!.connect();

    _socket!.onConnect((_) {
      log('Socket connected: ${_socket?.id}');

      _socket!.emit('setup', {'_id': userId});

      log('Socket setup emitted');
    });

    _socket!.on('message received', (data) {
      log('Socket message received: $data');

      if (data is Map) {
        _messageController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket!.onDisconnect((_) {
      log('Socket disconnected');
    });

    _socket!.onConnectError((error) {
      log('Socket connection error: $error');
    });

    _socket!.onError((error) {
      log('Socket error: $error');
    });
  }

  void joinChat(String chatId) {
    if (_socket?.connected != true) {
      log('Cannot join chat. Socket is not connected.');
      return;
    }

    log('Joining chat: $chatId');

    _socket!.emit('join chat', chatId);
  }

  void disconnect() {
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
