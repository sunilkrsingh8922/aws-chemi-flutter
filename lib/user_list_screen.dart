import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hipsterassignment/aws_list_page.dart';
import 'event/user_controller.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            tooltip: "Start Video Call",
            onPressed: () {
              Get.to(() => const AwsListScreen());
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // handle more options
            },
          ),
        ],
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
