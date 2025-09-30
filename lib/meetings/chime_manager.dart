import 'package:flutter/services.dart';

class ChimeManager {
  static dynamic _currentMeeting;
  static dynamic _currentAttendee;

  static Future<void> endCurrentMeeting() async {
    try {
      const platform = MethodChannel('flutter_aws_chime');
      await platform.invokeMethod('leaveMeeting');
      _currentMeeting = null;
      _currentAttendee = null;
    } catch (e) {
      print("Failed to leave current meeting: $e");
    }
  }

  static Future<void> startMeeting({
    required dynamic meeting,
    required dynamic attendee,
  }) async {
    await endCurrentMeeting(); // 🚨 leave old one first
    _currentMeeting = meeting;
    _currentAttendee = attendee;
  }

  static dynamic get meeting => _currentMeeting;
  static dynamic get attendee => _currentAttendee;
}
