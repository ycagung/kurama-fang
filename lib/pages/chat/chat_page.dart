import 'dart:async';

import 'package:fang/classes.dart';
import 'package:fang/components/chat/chat_footer.dart';
import 'package:fang/components/chat/chat_header.dart';
import 'package:fang/components/chat/message_bubble.dart';
import 'package:fang/services/chat_service.dart';
import 'package:fang/services/message_service.dart';
import 'package:fang/services/socket_service.dart';
import 'package:fang/storage/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final String chatId;

  const ChatPage({super.key, required this.chatId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final MessageService _messageService = MessageService();
  final SocketService _socketService = SocketService.instance;
  final ScrollController _scrollController = ScrollController();

  String? _profileId;
  Map<String, dynamic>? _chatRoom;
  List<MessageGroup> _messageGroups = [];
  bool _partnerOnline = false;
  bool _partnerTyping = false;
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;
  StreamSubscription<Map<String, dynamic>>? _typingSubscription;

  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _typingSubscription?.cancel();
    _scrollController.dispose();
    _socketService.leaveRoom(widget.chatId);
    super.dispose();
  }

  Future<void> _loadChat() async {
    final profileId = await AuthStorage.getProfileId();
    if (profileId == null) return;

    setState(() {
      _profileId = profileId;
    });

    try {
      final chatRoom = await _chatService.getChatById(profileId, widget.chatId);
      if (chatRoom != null) {
        setState(() {
          _chatRoom = chatRoom;
        });
        final chatRoomData = chatRoom['chatRoom'] as Map<String, dynamic>?;
        if (chatRoomData != null) {
          final messages = chatRoomData['messages'] as List<dynamic>? ?? [];
          _organizeMessages(messages);
        }
        _setupSocketListeners();
        _socketService.joinRoom(widget.chatId);
        
        // Scroll to bottom after messages load
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load chat: $e')),
        );
      }
    }
  }

  void _setupSocketListeners() {
    final chatRoom = _chatRoom?['chatRoom'] as Map<String, dynamic>?;
    final partner = chatRoom?['partner'] as Map<String, dynamic>?;
    final partnerProfile = partner?['profile'] as Map<String, dynamic>?;
    final partnerProfileId = partnerProfile?['id'] as String?;

    if (partnerProfileId == null) return;

    // Listen for new messages
    _messageSubscription = _socketService
        .listenToMessages(widget.chatId)
        .listen((event) {
      if (event['message'] != null) {
        final messageData = event['message'];
        MessageData message;
        if (messageData is Map<String, dynamic>) {
          message = MessageData.fromJson(messageData);
        } else {
          // Handle case where message might be in different format
          return;
        }
        _addMessage(message);
      }
    });

    // Listen for typing indicators
    _typingSubscription =
        _socketService.listenToTyping(partnerProfileId).listen((event) {
      if (event['event'] == 'typing-start') {
        setState(() {
          _partnerTyping = true;
        });
      } else if (event['event'] == 'typing-stop') {
        setState(() {
          _partnerTyping = false;
        });
      }
    });

    // Listen for online/offline status (simplified - would need socket events)
    // This would need to be implemented based on socket events
  }

  void _organizeMessages(List<dynamic> messages) {
    final Map<String, List<MessageData>> grouped = {};

    for (var msg in messages) {
      final message = MessageData.fromJson(msg as Map<String, dynamic>);
      final date = message.createdAt != null
          ? DateFormat('MMM d, yyyy').format(message.createdAt!)
          : DateFormat('MMM d, yyyy').format(DateTime.now());

      grouped.putIfAbsent(date, () => []).add(message);
    }

    setState(() {
      _messageGroups = grouped.entries.map((entry) {
        return MessageGroup(date: entry.key, messages: entry.value);
      }).toList();
    });
  }

  void _addMessage(MessageData message) {
    final date = message.createdAt != null
        ? DateFormat('MMM d, yyyy').format(message.createdAt!)
        : DateFormat('MMM d, yyyy').format(DateTime.now());

    setState(() {
      if (_messageGroups.isNotEmpty &&
          _messageGroups.last.date == date) {
        _messageGroups.last.messages.add(message);
      } else {
        _messageGroups.add(MessageGroup(date: date, messages: [message]));
      }
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String content) async {
    if (_profileId == null) return;

    final messageId = const Uuid().v4();
    final message = MessageData(
      id: messageId,
      createdAt: DateTime.now(),
      senderId: _profileId!,
      content: content,
      statusId: 's', // sent
    );

    // Optimistically add message
    _addMessage(message);

    try {
      // Send via socket (preferred for real-time)
      await _socketService.sendMessage(
        id: messageId,
        chatId: widget.chatId,
        senderId: _profileId!,
        content: content,
        statusId: 's',
      );

      // Also send via REST API as backup
      await _messageService.sendMessage(
        id: messageId,
        chatId: widget.chatId,
        senderId: _profileId!,
        content: content,
        statusId: 's',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  void _handleTypingStart() {
    if (_profileId != null) {
      _socketService.startTyping(
        roomId: widget.chatId,
        profileId: _profileId!,
      );
    }
  }

  void _handleTypingStop() {
    if (_profileId != null) {
      _socketService.stopTyping(
        roomId: widget.chatId,
        profileId: _profileId!,
      );
    }
  }

  ProfileData? get _partner {
    final chatRoom = _chatRoom?['chatRoom'] as Map<String, dynamic>?;
    final partner = chatRoom?['partner'] as Map<String, dynamic>?;
    if (partner == null) return null;

    // Partner structure has firstName/lastName at top level and nested profile
    final profile = partner['profile'] as Map<String, dynamic>?;
    if (profile == null) return null;

    // Merge partner firstName/lastName with profile data
    final profileData = Map<String, dynamic>.from(profile);
    profileData['firstName'] = partner['firstName'] ?? profile['firstName'] ?? '';
    profileData['lastName'] = partner['lastName'];

    return ProfileData.fromJson(profileData);
  }

  @override
  Widget build(BuildContext context) {
    if (_chatRoom == null || _profileId == null) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final partner = _partner;
    if (partner == null) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: const Center(child: Text('Chat not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          ChatHeader(
            partner: partner,
            isOnline: _partnerOnline,
            isTyping: _partnerTyping,
          ),
          Expanded(
            child: _messageGroups.isEmpty
                ? Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _messageGroups.length,
                    itemBuilder: (context, groupIndex) {
                      final group = _messageGroups[groupIndex];
                      return Column(
                        children: [
                          // Date header
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                group.date,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          // Messages
                          ...group.messages.asMap().entries.map((entry) {
                            final index = entry.key;
                            final message = entry.value;
                            final prevMessage = index > 0
                                ? group.messages[index - 1]
                                : null;
                            final isGrouped = prevMessage != null &&
                                prevMessage.senderId == message.senderId &&
                                (message.createdAt == null ||
                                    prevMessage.createdAt == null ||
                                    message.createdAt!
                                        .difference(prevMessage.createdAt!)
                                        .inMinutes < 5);

                            return MessageBubble(
                              message: message,
                              currentProfileId: _profileId!,
                              isGrouped: isGrouped,
                            );
                          }),
                        ],
                      );
                    },
                  ),
          ),
          ChatFooter(
            onSend: _sendMessage,
            onTypingStart: _handleTypingStart,
            onTypingStop: _handleTypingStop,
          ),
        ],
      ),
    );
  }
}

class MessageGroup {
  final String date;
  final List<MessageData> messages;

  MessageGroup({required this.date, required this.messages});
}

