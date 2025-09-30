import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hipsterassignment/aws_list_page.dart';
import 'package:hipsterassignment/state/notification_controller.dart';
import 'package:hipsterassignment/videocall/agora_call.dart';
import 'event/user_controller.dart';
import 'package:http/http.dart' as http;

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key}); // fixed constructor

  @override
  UserListScreenState createState() => UserListScreenState();
}

class UserListScreenState extends State<UserListScreen> {
  final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
      ),
        body: Obx(() {
        if (controller.isLoading.value && controller.users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.users.isEmpty) {
          return const Center(child: Text("No users available"));
        }
        return ListView.separated(
          itemCount: controller.users.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return ListTile(
                trailing: IconButton(
                  icon: const Icon(Icons.videocam_outlined),
                  tooltip: 'Start video call',
                  onPressed: () async {
                    await NotificationService().sendNotification();
                    Get.to(
                          () => AgoraCall(
                        appId: "0b53dbbc6f5149bfb6a5747c987a3e45",
                        channelName: "Room1",
                        token: "",
                      ),
                    );
                  }),
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.avatar),
              ),
              title: Text(user.name),
            );
          },
        );
      }),
    );
  }
}

class NotificationService {
  Future<void> sendNotification() async {
    final url = Uri.parse('http://192.168.0.16:3000/agora-notification');
    print(token);
    final payload = {
      "token": token=="cLozKptYQSWv6QeFpI0c4o:APA91bEFQFTvvWZpIDUiB-xQNNiw41C2iciNwHMy3h2Jmdl31tzlFunBos7_yjha0TSZgbcuObKqdHdsatFKO6vcQkjmr9Xw6Sfd68V7AOMcpARuDhDqhsQ"?
      "fs6qlrAUTdGpJK88Zp5PVh:APA91bG4Zt2m4IlMzk_zqA2-kJw2J7dgsG1rhkIlu0KKzV9hjWs2L3fgzNEFb8pEpkyFFhPeLwar_sNuboCgZjkTduEGe2ZwGPy9ktdTbQIU0nkUCOQK35o":token,
      "title": "Incoming Call",
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
        print(response.body);
      } else {
        print(
          'Failed to send notification. Status code: ${response.statusCode}',
        );
        print(response.body);
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
