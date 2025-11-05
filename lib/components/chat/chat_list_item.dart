import 'package:fang/classes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatListItem extends StatelessWidget {
  final DisplayChatData chat;
  final String currentProfileId;
  final bool isSelected;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.chat,
    required this.currentProfileId,
    this.isSelected = false,
    required this.onTap,
  });

  bool get _isUnread {
    return chat.lastMessage.senderId != currentProfileId &&
        chat.lastMessage.statusId != 'r';
  }

  String _getPartnerName() {
    // Partner is a ProfileData, so use firstName directly
    if (chat.partner.firstName.isNotEmpty) {
      return '${chat.partner.firstName} ${chat.partner.lastName ?? ''}'.trim();
    } else if (chat.partner.phoneNumber != null) {
      final phoneCode = chat.partner.country?.phoneCode ?? '';
      return '$phoneCode ${chat.partner.phoneNumber}';
    }
    return chat.partner.email ?? 'Unknown';
  }

  String _getLastMessageText() {
    if (chat.lastMessage.content == null) {
      return 'No messages';
    }
    return chat.lastMessage.content!;
  }

  String _getLastMessageTime() {
    if (chat.lastMessage.createdAt == null) {
      return '';
    }
    final date = chat.lastMessage.createdAt!;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(date);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEE').format(date);
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[800] : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Colors.grey[800]!, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                shape: BoxShape.circle,
              ),
              child: chat.partner.avatar != null
                  ? ClipOval(
                      child: Image.network(
                        chat.partner.avatar!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.person, color: Colors.grey[300]),
                      ),
                    )
                  : Center(
                      child: Text(
                        _getPartnerName().isNotEmpty
                            ? _getPartnerName()[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getPartnerName(),
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 16,
                            fontWeight: _isUnread
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      const SizedBox(width: 8),
                      Text(
                        _getLastMessageTime(),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                          Text(
                            _getLastMessageText(),
                            style: TextStyle(
                              color: _isUnread ? Colors.grey[300] : Colors.grey[500],
                              fontSize: 14,
                              fontWeight:
                                  _isUnread ? FontWeight.w500 : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

