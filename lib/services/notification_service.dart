

import 'dart:convert';
import '../helper/api_data.dart';
import 'package:http/http.dart' as http;

import '../state/notification_controller.dart';

class NotificationService {
  Future<void> sendNotification() async {
    final url = Uri.parse('http://192.168.0.16:3000/agora-notification');
    // print(token);
    final payload = {
      "token": token=="cLozKptYQSWv6QeFpI0c4o:APA91bEFQFTvvWZpIDUiB-xQNNiw41C2iciNwHMy3h2Jmdl31tzlFunBos7_yjha0TSZgbcuObKqdHdsatFKO6vcQkjmr9Xw6Sfd68V7AOMcpARuDhDqhsQ"?
      "fs6qlrAUTdGpJK88Zp5PVh:APA91bG4Zt2m4IlMzk_zqA2-kJw2J7dgsG1rhkIlu0KKzV9hjWs2L3fgzNEFb8pEpkyFFhPeLwar_sNuboCgZjkTduEGe2ZwGPy9ktdTbQIU0nkUCOQK35o":token,
      "title": ApiData.title,
      "body": "You have an incoming call",
      "data": {"room": "Room1"},
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        print('Notification sent successfully!');
      } else {
        print(
          'Failed to send notification. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
