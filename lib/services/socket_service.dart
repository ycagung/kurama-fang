import 'dart:async';

import 'package:fang/config/environment.dart';
import 'package:fang/storage/auth_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Socket.io service for real-time chat functionality
/// Handles connection, authentication, and all real-time events
class SocketService {
  static SocketService? _instance;
  IO.Socket? _socket;
  bool _isConnected = false;
  bool _isConnecting = false;

  // Stream controllers for different events
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();
  final _newChatController = StreamController<Map<String, dynamic>>.broadcast();

  SocketService._();

  /// Get singleton instance
  static SocketService get instance {
    _instance ??= SocketService._();
    return _instance!;
  }

  /// Stream of new messages
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  /// Stream of typing indicators
  Stream<Map<String, dynamic>> get typingStream => _typingController.stream;

  /// Stream of connection status changes
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Stream of new chat notifications
  Stream<Map<String, dynamic>> get newChatStream => _newChatController.stream;

  /// Check if socket is connected
  bool get isConnected => _isConnected && _socket?.connected == true;

  /// Connect to socket.io server
  Future<void> connect() async {
    if (_isConnecting || _isConnected) return;

    _isConnecting = true;

    try {
      final accountId = await AuthStorage.getAccountId();
      final profileId = await AuthStorage.getProfileId();

      if (accountId == null || profileId == null) {
        print('SocketService: Missing accountId or profileId');
        _isConnecting = false;
        return;
      }

      final socketUrl = EnvironmentConfig.socketUrl;

      _socket = IO.io(
        socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .setAuth({
              'accountId': accountId,
              'profileId': profileId,
            })
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setReconnectionAttempts(5)
            .build(),
      );

      _setupEventListeners();
    } catch (e) {
      print('SocketService: Connection error: $e');
      _isConnecting = false;
    }
  }

  /// Setup all event listeners
  void _setupEventListeners() async {
    if (_socket == null) return;

    final profileId = await AuthStorage.getProfileId();

    // Connection events
    _socket!.onConnect((_) {
      print('SocketService: Connected');
      _isConnected = true;
      _isConnecting = false;
      _connectionController.add(true);
    });

    _socket!.onDisconnect((_) {
      print('SocketService: Disconnected');
      _isConnected = false;
      _connectionController.add(false);
    });

    _socket!.onConnectError((error) {
      print('SocketService: Connection error: $error');
      _isConnecting = false;
      _connectionController.add(false);
    });

    // User connection/disconnection events
    if (profileId != null) {
      _socket!.on('$profileId-connected', (_) {
        print('SocketService: User connected');
      });

      _socket!.on('$profileId-disconnected', (_) {
        print('SocketService: User disconnected');
      });
    }

    // Message events - listen for new messages in specific chat rooms
    // Format: new-message-from-{senderId}-in-{chatId}
    _socket!.onAny((event, data) {
      if (event.startsWith('new-message-from-') && event.contains('-in-')) {
        final parts = event.split('-in-');
        if (parts.length == 2) {
          final chatId = parts[1];
          final messageData = data is Map ? data['message'] : data;
          _messageController.add({
            'event': 'new-message',
            'chatId': chatId,
            'message': messageData,
          });
        }
      } else if (event.startsWith('new-message-for-')) {
        final profileId = event.replaceFirst('new-message-for-', '');
        _newChatController.add({
          'event': 'new-chat-notification',
          'profileId': profileId,
          'data': data,
        });
      } else if (event.contains('-started-typing')) {
        final profileId = event.replaceFirst('-started-typing', '');
        _typingController.add({
          'event': 'typing-start',
          'profileId': profileId,
          'data': data,
        });
      } else if (event.contains('-stopped-typing')) {
        final profileId = event.replaceFirst('-stopped-typing', '');
        _typingController.add({
          'event': 'typing-stop',
          'profileId': profileId,
          'data': data,
        });
      }
    });
  }

  /// Join a chat room
  Future<void> joinRoom(String roomId) async {
    if (_socket == null || !_isConnected) {
      await connect();
      // Wait a bit for connection
      await Future.delayed(const Duration(milliseconds: 500));
    }

    _socket?.emit('join-room', roomId);
    print('SocketService: Joined room $roomId');
  }

  /// Leave a chat room
  Future<void> leaveRoom(String roomId) async {
    if (_socket == null || !_isConnected) return;
    _socket?.emit('leave-room', roomId);
    print('SocketService: Left room $roomId');
  }

  /// Send a new message
  /// Returns the callback response from server
  Future<String?> sendMessage({
    required String id,
    required String chatId,
    required String senderId,
    required String content,
    required String statusId,
  }) async {
    if (_socket == null || !_isConnected) {
      await connect();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    final payload = {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'statusId': statusId,
    };

    Completer<String?> completer = Completer<String?>();

    _socket?.emitWithAck(
      'new-message',
      {'payload': payload},
      ack: (response) {
        if (!completer.isCompleted) {
          completer.complete(response is String ? response : null);
        }
      },
    );

    // Timeout after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    });

    return completer.future;
  }

  /// Send typing start indicator
  void startTyping({required String roomId, required String profileId}) {
    if (_socket == null || !_isConnected) return;
    _socket?.emit('user-start-typing', {
      'roomId': roomId,
      'profileId': profileId,
    });
  }

  /// Send typing stop indicator
  void stopTyping({required String roomId, required String profileId}) {
    if (_socket == null || !_isConnected) return;
    _socket?.emit('user-stop-typing', {
      'roomId': roomId,
      'profileId': profileId,
    });
  }

  /// Listen for typing events in a specific room
  Stream<Map<String, dynamic>> listenToTyping(String profileId) {
    return _typingController.stream.where((event) {
      return event['profileId'] == profileId;
    });
  }

  /// Listen for messages in a specific chat
  Stream<Map<String, dynamic>> listenToMessages(String chatId) {
    return _messageController.stream.where((event) {
      return event['chatId'] == chatId;
    });
  }

  /// Disconnect from socket
  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _isConnected = false;
      _isConnecting = false;
    }
  }

  /// Dispose all resources
  void dispose() {
    disconnect();
    _messageController.close();
    _typingController.close();
    _connectionController.close();
    _newChatController.close();
  }
}

