import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hipsterassignment/GraphQLService.dart';
import 'package:hipsterassignment/AwsListPage.dart';
import 'package:hipsterassignment/UserListScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = "".obs;

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Reset previous error
    errorMessage.value = "";

    // Basic validation
    if (email.isEmpty) {
      errorMessage.value = "Email cannot be empty";
      return;
    }

    if (!GetUtils.isEmail(email)) {
      errorMessage.value = "Invalid email format";
      return;
    }

    if (password.isEmpty) {
      errorMessage.value = "Password cannot be empty";
      return;
    }

    if (password.length < 6) {
      errorMessage.value = "Password must be at least 6 characters";
      return;
    }

    // Optional: enforce stronger password rules
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{6,}$');
    if (!passwordRegex.hasMatch(password)) {
      errorMessage.value =
          "Password must contain uppercase, lowercase, and number";
      return;
    }

    try {
      isLoading.value = true;

      final client = GraphQLService.initClient().value;

      final String query = r'''
      query GetUser($id: ID!) {
        user(id: $id) {
          id
          name
          email
        }
      }
    ''';

      final result = await client.query(
        QueryOptions(
          document: gql(query),
          variables: {"id": "1"}, // Mock user id
        ),
      );

      if (result.hasException) {
        errorMessage.value = "GraphQL Error: ${result.exception.toString()}";
        return;
      }

      final user = result.data?["user"];
      if (user != null &&
          email == "test@gmail.com" &&
          password == "Kgs@123") {
        // persist auth
        try {
          final box = await Hive.openBox('auth');
          await box.put('logged_in', true);
          await box.put('user', {
            'id': user['id'].toString(),
            'name': user['name'] ?? '',
            'email': user['email'] ?? email,
          });
        } catch (_) {}

        Get.snackbar("Success", "Login successful as ${user["name"]}");
        Get.offAll(() => UserListScreen());
      } else {
        errorMessage.value = "Invalid credentials";
      }
    } catch (e) {
      errorMessage.value = "Unexpected error: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
