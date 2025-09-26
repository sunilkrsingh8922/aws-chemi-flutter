import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'LoginPage.dart';
import 'UserListPage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    // Navigate after 3 seconds based on auth flag
    Timer(const Duration(seconds: 3), () async {
      try {
        final box = await Hive.openBox('auth');
        final loggedIn = box.get('logged_in', defaultValue: false) as bool;
        if (loggedIn) {
          Get.off(() => UserListPage());
          return;
        }
      } catch (_) {}
      Get.off(() => LoginPage()); // fallback to login
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.flutter_dash, color: Colors.white, size: 100),
                const SizedBox(height: 20),
                Text(
                  "Hipster Inc",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
