import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:hipsterassignment/model/User.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserApiService {
  static const String _overrideBase = String.fromEnvironment('REST_BASE_URL');

  static String get _baseUrl {
    if (_overrideBase.isNotEmpty) return _overrideBase;
    if (kIsWeb) return 'http://192.168.0.16:3000';
    if (Platform.isAndroid) return 'http://192.168.0.16:3000';
    return 'http://192.168.0.16:3000';
  }

  static Future<List<User>> fetchUsers() async {
    final uri = Uri.parse('$_baseUrl/users/all');
    final response = await http.get(uri);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data
          .whereType<Map>()
          .map(
            (e) => User(
              id: (e['id'] ?? e['username'] ?? e['_id'] ?? '').toString(),
              name: (e['name'] ?? e['username'] ?? '').toString(),
              fcmToken: (e['fcmToken'] ?? e['fcmToken'] ?? '').toString(),
              avatar:
                  (e['avatar'] ??
                          'https://i.pravatar.cc/150?u=${e['id'] ?? e['username'] ?? ''}')
                      .toString(),
            ),
          )
          .toList();
    }
    throw Exception(
      'fetchUsers failed: ${response.statusCode} ${response.body}',
    );
  }

  static Future<String> _getOrCreateDeviceId() async {
    final box = await Hive.openBox('device');
    String? id = box.get('device_id');
    if (id == null || id.isEmpty) {
      id =
          'dev-${DateTime.now().millisecondsSinceEpoch}-${Platform.operatingSystem}';
      await box.put('device_id', id);
    }
    return id;
  }

  static Future<User> addUser(String name) async {
    final uri = Uri.parse('$_baseUrl/users/add');

    final fcmToken = await FirebaseMessaging.instance.getToken();
    final deviceId = await _getOrCreateDeviceId();
    final username = name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');

    final body = json.encode({
      'username': username,
      'deviceId': deviceId,
      'name': name,
      'fcmToken': fcmToken ?? '',
    });
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> e = json.decode(response.body);
      return User(
        id: (e['id'] ?? e['username'] ?? e['_id'] ?? username).toString(),
        name: (e['name'] ?? name).toString(),
        fcmToken: (e['fcmToken'] ?? name).toString(),
        avatar:
            (e['avatar'] ??
                    'https://i.pravatar.cc/150?u=${e['id'] ?? username}')
                .toString(),
      );
    }
    throw Exception('addUser failed: ${response.statusCode} ${response.body}');
  }
}
