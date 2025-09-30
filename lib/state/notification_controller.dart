
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../meetings/chime_manager.dart';
import '../services/chime_service.dart';
import '../videocall/video_call_page.dart';
import '../aws_list_page.dart';

class NotificationController extends GetxController {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    try {
      final token = await _messaging.getToken();
      print("✅ FCM Token: $token");
    } catch (e) {
      print("❌ Error getting token: $e");
    }

    _messaging.onTokenRefresh.listen((newToken) {
      print("🔄 Token refreshed: $newToken");
    });

    FirebaseMessaging.onMessage.listen(_handleNotificationTap);
    // FirebaseMessaging.onBackgroundMessage(_handleNotificationTap);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }
}

  Future<void> _handleNotificationTap(RemoteMessage message) async {
    final data = message.data;
    final name = (data['name'] ?? '').toString();
    final meetingId = data['meetingId'] ?? data['metingid'];
    final reciever = data['receiver'];
    if (meetingId == null) {
      Get.offAll(() => AwsListScreen());
      return;
    }

    final meeting = await ChimeService.acceptCall(
      name: name.isEmpty ? "Guest" : name,
      meetingId: meetingId,
    );

    final attendee = (meeting['Attendees'] as List<dynamic>).firstWhere((a)=>reciever==a['AttendeeId']);
    await ChimeManager.startMeeting(meeting: meeting['Meeting'], attendee: attendee);
    Get.to(() => VideoCallPage(meeting: meeting['Meeting'],attendee:attendee));
  }

