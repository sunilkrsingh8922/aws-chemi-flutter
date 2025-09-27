import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

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

  static String? _extractMeetingId(Map<String, dynamic> payload) {
    // Flexible extraction: support {meetingId}, {MeetingId}, or nested meeting.MeetingId
    if (payload.containsKey('meetingId')) {
      return payload['meetingId']?.toString();
    }
    if (payload.containsKey('MeetingId')) {
      return payload['MeetingId']?.toString();
    }
    final meeting = payload['meeting'] ?? payload['meeting'] ?? payload['data'];
    if (meeting is Map<String, dynamic>) {
      final value =
          meeting['MeetingId'] ?? meeting['meetingId'] ?? meeting['id'];
      return value?.toString();
    }
    return null;
  }

  static Future<Map<String, dynamic>> initiateCall({
    required String name,
    required String attendeeId
  }) async {
    // If token not provided, fetch from FirebaseMessaging
    final uri = Uri.parse('$_baseUrl/chime/call');
    final payload = json.encode({'username': name, 'attendeeId': attendeeId});
    print("payloadpayload==$payload");
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('call failed: ${response.statusCode} ${response.body}');
    }

    final data = json.decode(response.body);
    print("chime/call response: ${data}");
    return data;
  }

  static Future<Map<String, dynamic>> acceptCall({
    required String name,
    required String meetingId
  }) async {
    // If token not provided, fetch from FirebaseMessaging
    final uri = Uri.parse('$_baseUrl/chime/call/accept');
    final payload = json.encode({'name': name, 'meetingId': meetingId});
    // print("payloadpayload==$payload");
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
