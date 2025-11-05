import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class NavPage {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;

  const NavPage(this.label, this.icon, this.selectedIcon, this.page);
}

class Device {
  static const _storage = FlutterSecureStorage();

  final String id;
  final String browser;
  final String os;

  const Device({required this.id, required this.browser, required this.os});

  /// Create a Device object from the actual device info
  static Future<Device> getData() async {
    final deviceInfo = DeviceInfoPlugin();

    // Load or generate device ID
    String? deviceId = await _storage.read(key: 'device_id');
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await _storage.write(key: 'device_id', value: deviceId);
    }

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return Device(
        id: deviceId,
        os: 'Android ${androidInfo.version.release}',
        browser: '${androidInfo.brand} ${androidInfo.model}',
      );
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return Device(
        id: deviceId,
        os: 'iOS ${iosInfo.systemVersion}',
        browser: iosInfo.utsname.machine, // or iosInfo.name for user-friendly
      );
    } else {
      return Device(id: deviceId, os: 'Unknown', browser: 'Unknown');
    }
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String,
      browser: json['browser'] as String,
      os: json['os'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'browser': browser, 'os': os};
}

class AuthData {
  final String accessToken;
  final String sessionId;

  const AuthData({required this.accessToken, required this.sessionId});

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'accessToken': String accessToken, 'sessionId': String sessionId} =>
        AuthData(accessToken: accessToken, sessionId: sessionId),
      _ => throw const FormatException('Failed to load auth data'),
    };
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'sessionId': sessionId,
  };
}

class CountryData {
  final String phoneCode;

  const CountryData({required this.phoneCode});

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(phoneCode: json['phoneCode'] as String);
  }

  Map<String, dynamic> toJson() => {'phoneCode': phoneCode};
}

class UserData {
  final String id;
  final String email;
  final String? phoneNumber;
  final CountryData? country;

  const UserData({
    required this.id,
    required this.email,
    this.phoneNumber,
    this.country,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      country: json['country'] != null
          ? CountryData.fromJson(json['country'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'phoneNumber': phoneNumber,
    'country': country?.toJson(),
  };
}

class ProfileData {
  final String id;
  final String? email;
  final String? phoneNumber;
  final String firstName;
  final String? lastName;
  final String? dob;
  final String? bio;
  final String? avatar;
  final CountryData? country;

  const ProfileData({
    required this.id,
    this.email,
    this.phoneNumber,
    required this.firstName,
    this.lastName,
    this.dob,
    this.bio,
    this.avatar,
    this.country,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String?,
      dob: json['dob'] as String?,
      bio: json['bio'] as String?,
      avatar: json['avatar'] as String?,
      country: json['country'] != null
          ? CountryData.fromJson(json['country'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'phoneNumber': phoneNumber,
    'firstName': firstName,
    'lastName': lastName,
    'dob': dob,
    'bio': bio,
    'avatar': avatar,
    'country': country?.toJson(),
  };
}

class ContactProfileData {
  final String id;
  final String? email;
  final String? phoneNumber;
  final String? avatar;
  final CountryData? country;

  const ContactProfileData({
    required this.id,
    this.email,
    this.phoneNumber,
    this.avatar,
    this.country,
  });

  factory ContactProfileData.fromJson(Map<String, dynamic> json) {
    return ContactProfileData(
      id: json['id'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      avatar: json['avatar'] as String?,
      country: json['country'] != null
          ? CountryData.fromJson(json['country'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'phoneNumber': phoneNumber,
    'avatar': avatar,
    'country': country?.toJson(),
  };
}

class ContactData {
  final String id;
  final String firstName;
  final String? lastName;
  final bool blocked;
  final ContactProfileData profile;

  const ContactData({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.blocked,
    required this.profile,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String?,
      blocked: json['blocked'] as bool,
      profile: ContactProfileData.fromJson(
        json['profile'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'blocked': blocked,
    'profile': profile.toJson(),
  };
}

class MessageData {
  final String id;
  final DateTime? createdAt;
  final String senderId;
  final String? content;
  final String statusId;

  const MessageData({
    required this.id,
    this.createdAt,
    required this.senderId,
    this.content,
    required this.statusId,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      id: json['id'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      senderId: json['senderId'] as String,
      content: json['content'] as String?,
      statusId: json['statusId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt,
    'senderId': senderId,
    'content': content,
    'statusId': statusId,
  };
}

class DisplayChatData {
  final String id;
  final MessageData lastMessage;
  final ProfileData partner;

  const DisplayChatData({
    required this.id,
    required this.lastMessage,
    required this.partner,
  });

  factory DisplayChatData.fromJson(Map<String, dynamic> json) {
    return DisplayChatData(
      id: json['id'] as String,
      lastMessage: MessageData.fromJson(json['lastMessage']),
      partner: ProfileData.fromJson(json['partner']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lastMessage': lastMessage,
    'partner': partner,
  };
}

// --- Generated model classes for additional tables ---

class AccountData {
  final String id;
  final DateTime? createdAt;
  final String email;
  final String? phoneNumber;
  final CountryData? country;
  final String? activeProfileId;

  const AccountData({
    required this.id,
    this.createdAt,
    required this.email,
    this.phoneNumber,
    this.country,
    this.activeProfileId,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      id: json['id'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      country: json['country'] != null
          ? CountryData.fromJson(json['country'] as Map<String, dynamic>)
          : null,
      activeProfileId: json['activeProfileId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt?.toIso8601String(),
        'email': email,
        'phoneNumber': phoneNumber,
        'country': country?.toJson(),
        'activeProfileId': activeProfileId,
      };
}

class SessionData {
  final String id;
  final DateTime? createdAt;
  final String accountId;
  final String lastToken;
  final DateTime? expiryDate;
  final bool valid;
  final String deviceId;
  final DateTime? endedAt;
  final String? socketId;

  const SessionData({
    required this.id,
    this.createdAt,
    required this.accountId,
    required this.lastToken,
    this.expiryDate,
    required this.valid,
    required this.deviceId,
    this.endedAt,
    this.socketId,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      id: json['id'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      accountId: json['accountId'] as String,
      lastToken: json['lastToken'] as String,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      valid: json['valid'] as bool,
      deviceId: json['deviceId'] as String,
      endedAt: json['endedAt'] != null
          ? DateTime.parse(json['endedAt'] as String)
          : null,
      socketId: json['socketId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt?.toIso8601String(),
        'accountId': accountId,
        'lastToken': lastToken,
        'expiryDate': expiryDate?.toIso8601String(),
        'valid': valid,
        'deviceId': deviceId,
        'endedAt': endedAt?.toIso8601String(),
        'socketId': socketId,
      };
}

class ProfileFlagData {
  final String id;
  final String name;

  const ProfileFlagData({required this.id, required this.name});

  factory ProfileFlagData.fromJson(Map<String, dynamic> json) {
    return ProfileFlagData(id: json['id'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class GroupData {
  final String id;
  final DateTime? createdAt;
  final String name;
  final String? imgUrl;
  final String? description;

  const GroupData({
    required this.id,
    this.createdAt,
    required this.name,
    this.imgUrl,
    this.description,
  });

  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(
      id: json['id'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      name: json['name'] as String,
      imgUrl: json['imgUrl'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt?.toIso8601String(),
        'name': name,
        'imgUrl': imgUrl,
        'description': description,
      };
}

class GroupMemberData {
  final String id;
  final DateTime? createdAt;
  final String groupId;
  final String profileId;
  final String roleId;

  const GroupMemberData({
    required this.id,
    this.createdAt,
    required this.groupId,
    required this.profileId,
    required this.roleId,
  });

  factory GroupMemberData.fromJson(Map<String, dynamic> json) {
    return GroupMemberData(
      id: json['id'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      groupId: json['groupId'] as String,
      profileId: json['profileId'] as String,
      roleId: json['roleId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt?.toIso8601String(),
        'groupId': groupId,
        'profileId': profileId,
        'roleId': roleId,
      };
}

class GroupMemberRoleData {
  final String id;
  final String name;

  const GroupMemberRoleData({required this.id, required this.name});

  factory GroupMemberRoleData.fromJson(Map<String, dynamic> json) {
    return GroupMemberRoleData(id: json['id'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class ChatData {
  final String id;
  final DateTime? createdAt;
  final String chatTypeId;
  final String? groupId;

  const ChatData({
    required this.id,
    this.createdAt,
    required this.chatTypeId,
    this.groupId,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      id: json['id'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      chatTypeId: json['chatTypeId'] as String,
      groupId: json['groupId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt?.toIso8601String(),
        'chatTypeId': chatTypeId,
        'groupId': groupId,
      };
}

class ChatParticipantData {
  final String id;
  final String chatId;
  final String profileId;

  const ChatParticipantData({required this.id, required this.chatId, required this.profileId});

  factory ChatParticipantData.fromJson(Map<String, dynamic> json) {
    return ChatParticipantData(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      profileId: json['profileId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'chatId': chatId, 'profileId': profileId};
}

class ChatTypeData {
  final String id;
  final String name;

  const ChatTypeData({required this.id, required this.name});

  factory ChatTypeData.fromJson(Map<String, dynamic> json) {
    return ChatTypeData(id: json['id'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class MessageStatusData {
  final String id;
  final String name;

  const MessageStatusData({required this.id, required this.name});

  factory MessageStatusData.fromJson(Map<String, dynamic> json) {
    return MessageStatusData(id: json['id'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class AttachmentData {
  final int id;
  final String messageId;
  final String url;

  const AttachmentData({required this.id, required this.messageId, required this.url});

  factory AttachmentData.fromJson(Map<String, dynamic> json) {
    return AttachmentData(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      messageId: json['messageId'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'messageId': messageId, 'url': url};
}

class ScheduleData {
  final int id;
  final DateTime? createdAt;
  final String ownerId;
  final String title;
  final DateTime start;
  final DateTime end;
  final String? note;
  final String? messageId;

  const ScheduleData({
    required this.id,
    this.createdAt,
    required this.ownerId,
    required this.title,
    required this.start,
    required this.end,
    this.note,
    this.messageId,
  });

  factory ScheduleData.fromJson(Map<String, dynamic> json) {
    return ScheduleData(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      ownerId: json['ownerId'] as String,
      title: json['title'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      note: json['note'] as String?,
      messageId: json['messageId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt?.toIso8601String(),
        'ownerId': ownerId,
        'title': title,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'note': note,
        'messageId': messageId,
      };
}

class ScheduleMemberData {
  final int id;
  final DateTime? createdAt;
  final int scheduleId;
  final String memberId;
  final String? responseId;

  const ScheduleMemberData({
    required this.id,
    this.createdAt,
    required this.scheduleId,
    required this.memberId,
    this.responseId,
  });

  factory ScheduleMemberData.fromJson(Map<String, dynamic> json) {
    return ScheduleMemberData(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      scheduleId: json['scheduleId'] is int ? json['scheduleId'] as int : int.parse(json['scheduleId'].toString()),
      memberId: json['memberId'] as String,
      responseId: json['responseId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt?.toIso8601String(),
        'scheduleId': scheduleId,
        'memberId': memberId,
        'responseId': responseId,
      };
}

class ScheduleMemberResponseData {
  final String id;
  final String name;

  const ScheduleMemberResponseData({required this.id, required this.name});

  factory ScheduleMemberResponseData.fromJson(Map<String, dynamic> json) {
    return ScheduleMemberResponseData(id: json['id'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
