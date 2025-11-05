import 'package:fang/classes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final MessageData message;
  final String currentProfileId;
  final bool showAvatar;
  final bool isGrouped;

  const MessageBubble({
    super.key,
    required this.message,
    required this.currentProfileId,
    this.showAvatar = false,
    this.isGrouped = false,
  });

  bool get _isSent => message.senderId == currentProfileId;

  String _getTime() {
    if (message.createdAt == null) return '';
    return DateFormat('HH:mm').format(message.createdAt!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: isGrouped ? 2 : 8,
        bottom: 4,
        left: 16,
        right: 16,
      ),
      child: Row(
        mainAxisAlignment:
            _isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!_isSent && showAvatar)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 20, color: Colors.grey[300]),
            ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _isSent ? Colors.grey[800] : Colors.blue[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.content != null)
                    Text(
                      message.content!,
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 15,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getTime(),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 11,
                        ),
                      ),
                      if (_isSent) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.statusId == 'r'
                              ? Icons.done_all
                              : message.statusId == 'd'
                                  ? Icons.done_all
                                  : Icons.done,
                          size: 14,
                          color: message.statusId == 'r'
                              ? Colors.blue[300]
                              : Colors.grey[400],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

