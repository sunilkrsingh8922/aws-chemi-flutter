import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/user_model.dart';

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
      final url = Uri.parse('https://dummyjson.com/users?limit=20');

      final response = await http.get(url, headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
      });

      if (response.statusCode == 200) {
        final List usersJson = json.decode(response.body)['users']; // reqres wraps users in 'data'

        final fetchedUsers =
        usersJson.map((json) => UserModel.fromJson(json)).toList();

        // Update Hive cache
        await userBox.clear();
        await userBox.addAll(fetchedUsers);

        // Update reactive list
        users.assignAll(fetchedUsers);
      } else {
        debugPrint("Failed to fetch users, statusCode: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Failed to fetch users, using cache: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
