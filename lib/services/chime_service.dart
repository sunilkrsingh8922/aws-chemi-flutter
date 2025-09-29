import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChimeService {
  static String get _baseUrl {
    if (kIsWeb) return 'http://192.168.0.16:3000';
    if (Platform.isAndroid) return 'http://192.168.0.16:3000';
    return 'http://192.168.0.16:3000';
  }

  static Future<Map<String, dynamic>> createMeeting() async {
    final uri = Uri.parse('$_baseUrl/chime/createMeeting');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    throw Exception(
      'createMeeting failed: ${response.statusCode} ${response.body}',
    );
  }

  static Future<Map<String, dynamic>> initiateCall({
    required String name,
    required String attendeeId
  }) async {
    // If token not provided, fetch from FirebaseMessaging
    final uri = Uri.parse('$_baseUrl/chime/call');
    final payload = json.encode({'username': name, 'attendeeId': attendeeId});
    debugPrint("payloadpayload==$payload");
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('call failed: ${response.statusCode} ${response.body}');
    }

    final data = json.decode(response.body);
    debugPrint("chime/call response: $data");
    return data;
  }

  static Future<Map<String, dynamic>> acceptCall({
    required String name,
    required String meetingId
  }) async {
    final uri = Uri.parse('$_baseUrl/chime/call/accept');
    final payload = json.encode({'name': name, 'meetingId': meetingId});
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('call failed: ${response.statusCode} ${response.body}');
    }

    // Parse JSON
    final data = json.decode(response.body);
    return data;
  }

}
