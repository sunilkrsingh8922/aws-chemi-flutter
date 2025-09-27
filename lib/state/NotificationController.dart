import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/ChimeService.dart';
import '../videocall/VideoCallPage.dart';
import '../AwsListPage.dart';

class NotificationController extends GetxController {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    _initFirebase();
  }

  Future<void> _initFirebase() async {
    await Firebase.initializeApp();

    // Request permissions (iOS/macOS)
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Print FCM token
    try {
      final token = await _messaging.getToken();
      print("FCM Token: $token");
    } catch (e) {
      print("Error getting token: $e");
    }

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      print("Token refreshed: $newToken");
    });

    // Foreground notifications
    FirebaseMessaging.onMessage.listen(_handleNotificationTap);

    // When app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // When app is opened from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  Future<void> _handleNotificationTap(RemoteMessage message) async {
    final data = message.data;
    final name = (data['name'] ?? '').toString();
    final meetingId = data['meetingId'] ?? data['metingid'];

    if (meetingId == null) {
      Get.offAll(() => AwsListScreen());
      return;
    }

    final meeting = await ChimeService.acceptCall(
      name: name.isEmpty ? "Guest" : name,
      meetingId: meetingId,
    );

    Get.to(() => VideoCallPage(meeting: meeting));
  }
}
