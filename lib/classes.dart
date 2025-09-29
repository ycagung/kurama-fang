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
      createdAt: DateTime.parse(json['id']),
      senderId: json['senderId'] as String,
      content: json['content'] as String,
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
