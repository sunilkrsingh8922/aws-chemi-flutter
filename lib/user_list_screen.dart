import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hipsterassignment/helper/api_data.dart';
import 'package:hipsterassignment/services/notification_service.dart';
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
                        appId: ApiData.app_id,
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

