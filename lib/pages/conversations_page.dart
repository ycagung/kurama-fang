import 'package:fang/components/chat/chat_list_item.dart';
import 'package:fang/pages/chat/chat_page.dart';
import 'package:fang/services/chat_service.dart';
import 'package:fang/storage/auth_storage.dart';
import 'package:flutter/material.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final ChatService _chatService = ChatService();
  String? _currentProfileId;
  String? _selectedChatId;
  List<dynamic>? _chats;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    final profileId = await AuthStorage.getProfileId();
    if (profileId == null) return;

    setState(() {
      _currentProfileId = profileId;
    });

    try {
      final chats = await _chatService.getPersonalChats(profileId);
      setState(() {
        _chats = chats;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load chats: $e')),
        );
      }
    }
  }

  void _navigateToChat(String chatId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(chatId: chatId),
      ),
    ).then((_) {
      // Refresh chats when returning from chat page
      _loadChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Conversations',
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey[300]),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[900],
      body: _currentProfileId == null
          ? const Center(child: CircularProgressIndicator())
          : _chats == null
              ? const Center(child: CircularProgressIndicator())
              : _chats!.isEmpty
                  ? Center(
                      child: Text(
                        'No conversations yet',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadChats,
                      color: Colors.grey[300],
                      child: ListView.builder(
                        itemCount: _chats!.length,
                        itemBuilder: (context, index) {
                          final chat = _chats![index] as dynamic;
                          return ChatListItem(
                            chat: chat,
                            currentProfileId: _currentProfileId!,
                            isSelected: _selectedChatId == chat.id,
                            onTap: () => _navigateToChat(chat.id),
                          );
                        },
                      ),
                    ),
    );
  }
}
