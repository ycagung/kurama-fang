import 'package:fang/classes.dart';
import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  final ProfileData partner;
  final bool isOnline;
  final bool isTyping;
  final VoidCallback? onMenuTap;

  const ChatHeader({
    super.key,
    required this.partner,
    this.isOnline = false,
    this.isTyping = false,
    this.onMenuTap,
  });

  String _getPartnerName() {
    // Try to get name from partner data structure
    // This might need adjustment based on actual data structure
    if (partner.firstName.isNotEmpty) {
      return '${partner.firstName} ${partner.lastName ?? ''}'.trim();
    } else if (partner.phoneNumber != null) {
      final phoneCode = partner.country?.phoneCode ?? '';
      return '$phoneCode ${partner.phoneNumber}';
    }
    return partner.email ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey[300]),
            onPressed: () => Navigator.pop(context),
          ),
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              shape: BoxShape.circle,
            ),
            child: partner.avatar != null
                ? ClipOval(
                    child: Image.network(
                      partner.avatar!,
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          // Name and status
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getPartnerName(),
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  isTyping
                      ? 'Typing...'
                      : isOnline
                          ? 'Online'
                          : 'Offline',
                  style: TextStyle(
                    color: isTyping
                        ? Colors.blue[300]
                        : isOnline
                            ? Colors.green[300]
                            : Colors.grey[500],
                    fontSize: 12,
                    fontStyle: isTyping ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
          // Menu button
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey[300]),
            onPressed: onMenuTap,
          ),
        ],
      ),
    );
  }
}

