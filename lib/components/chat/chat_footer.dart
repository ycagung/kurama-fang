import 'package:flutter/material.dart';

class ChatFooter extends StatefulWidget {
  final Function(String) onSend;
  final VoidCallback? onTypingStart;
  final VoidCallback? onTypingStop;

  const ChatFooter({
    super.key,
    required this.onSend,
    this.onTypingStart,
    this.onTypingStop,
  });

  @override
  State<ChatFooter> createState() => _ChatFooterState();
}

class _ChatFooterState extends State<ChatFooter> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      widget.onSend(message);
      _messageController.clear();
      if (_isTyping) {
        _isTyping = false;
        widget.onTypingStop?.call();
      }
    }
  }

  void _onTextChanged(String text) {
    if (text.length == 1 && !_isTyping) {
      _isTyping = true;
      widget.onTypingStart?.call();
    } else if (text.isEmpty && _isTyping) {
      _isTyping = false;
      widget.onTypingStop?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          top: BorderSide(color: Colors.grey[800]!, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 100),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  onChanged: _onTextChanged,
                  onSubmitted: (_) => _sendMessage(),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(color: Colors.grey[200]),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[800],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

