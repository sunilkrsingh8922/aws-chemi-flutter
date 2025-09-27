import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/UserModel.dart';

class UserController extends GetxController {
  var users = <UserModel>[].obs;
  var isLoading = false.obs;

  late Box<UserModel> userBox;

  @override
  void onInit() async {
    super.onInit();
    userBox = Hive.box<UserModel>('users');
    _loadFromCache();
    await fetchUsers();
  }

  void _loadFromCache() {
    final cachedUsers = userBox.values.toList();
    if (cachedUsers.isNotEmpty) {
      users.assignAll(cachedUsers);
    }
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('https://reqres.in/api/users?page=1'),
      );

      if (response.statusCode == 200) {
        final List usersJson = json.decode(response.body)['data']; // reqres wraps users in 'data'
        final fetchedUsers =
        usersJson.map((json) => UserModel.fromJson(json)).toList();

        print("fetchedUsers == $fetchedUsers");

        // Update Hive cache
        await userBox.clear();
        await userBox.addAll(fetchedUsers);

        // Update reactive list
        users.assignAll(fetchedUsers);
      } else {
        print("Failed to fetch users, statusCode: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to fetch users, using cache: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
