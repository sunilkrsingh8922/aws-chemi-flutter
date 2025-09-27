import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hipsterassignment/AwsListPage.dart';
import 'package:hipsterassignment/model/UserModel.dart';
import 'package:get/get.dart';
import 'event/UserController.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call), // or any icon you want
            tooltip: "Start Video Call",
            onPressed: () {
              Get.to(() => AwsListScreen());
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert), // optional more menu
            onPressed: () {
              // handle more options
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.users.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.users.isEmpty) {
          return Center(child: Text("No users available"));
        }

        return ListView.separated(
          itemCount: controller.users.length,
          separatorBuilder: (_, __) => Divider(height: 1),
          itemBuilder: (context, index) {
            final UserModel user = controller.users[index];
            return ListTile(
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
