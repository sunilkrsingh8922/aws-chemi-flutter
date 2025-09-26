import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hipsterassignment/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hipsterassignment/UserListPage.dart';
import 'package:hipsterassignment/videocall/VideoCallPage.dart';

import 'GraphQLService.dart';

void main() async {
  await initHiveForFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Request permissions on iOS and macOS
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Get and log FCM token
  try {
    final token = await FirebaseMessaging.instance.getToken();
    // ignore: avoid_print
    print('FCM Token: $token');
    // ignore: avoid_print
    print('FCM Token length: ${token?.length ?? 0}');
  } catch (e) {
    // ignore token errors for now
  }

  // Listen to token refreshes and print them
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    // ignore: avoid_print
    print('FCM Token refreshed: $newToken');
  });

  runApp(MyApp());

  // Set up notification tap handlers AFTER navigator is ready
  // Background/foreground tap
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    _handleNotificationTap(message);
  });

  // Terminated state tap
  FirebaseMessaging.instance.getInitialMessage().then((initialMessage) {
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  });
}

void _handleNotificationTap(RemoteMessage message) {
  final data = message.data;
  final name = (data['name'] ?? '').toString();
  final meetingId = (data['meetingId'] ?? data['metingid'] ?? '').toString();

  // Navigate to user list first, then to the 1-to-1 video call
  Get.offAll(() => UserListPage());
  Get.to(
    () => VideoCallPage(
      userName: name.isNotEmpty ? name : null,
      meetingId: meetingId.isNotEmpty ? meetingId : null,
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQLService.initClient(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(), // 👈 splash first
      ),
    );
  }
}
