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
    final meeting = payload['meeting'] ?? payload['Meeting'] ?? payload['data'];
    if (meeting is Map<String, dynamic>) {
      final value =
          meeting['MeetingId'] ?? meeting['meetingId'] ?? meeting['id'];
      return value?.toString();
    }
    return null;
  }

  static Future<Map<String, dynamic>> initiateCall({
    required String name,
    required String fcmToken,
    required String metingId,
  }) async {
    // If token not provided, fetch from FirebaseMessaging
    if (fcmToken.isEmpty) {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('FCM token unavailable');
      }
      fcmToken = token;
    }

    final uri = Uri.parse('$_baseUrl/chime/call');
    final payload = json.encode({'name': name, 'fcmToken': fcmToken, "metingId":metingId});

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );

    print("chime/call response: ${response.body}");

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('call failed: ${response.statusCode} ${response.body}');
    }

    // Parse JSON
    final data = json.decode(response.body);

    // Return only the needed parts
    return {
      "Meeting": data["meeting"]["Meeting"],
      "Attendee": data["atendee"]["Attendee"],
    };
  }

  static Future<String?> startCallFlow(String name) async {
    // Ensure we have a token
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('FCM token unavailable');
    }

    // 1) Create meeting on server
    final meetingResp = await createMeeting();
    final meetingId = _extractMeetingId(meetingResp);
    print("meetingResp===${meetingResp}");
    print("meetingId====$meetingId");
    // 2) Notify server to place the call with our name and token
    // await initiateCall(name: name, fcmToken: token);
    return meetingId;
  }
}
