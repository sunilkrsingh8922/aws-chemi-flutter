import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hipsterassignment/model/user_model.dart';
import 'package:hipsterassignment/state/notification_controller.dart';
import 'package:hive_flutter/adapters.dart';
import 'graph_ql_service.dart';
import 'splash_screen.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter(); // Initialize Hive for Flutter
  Hive.registerAdapter(UserModelAdapter()); // Register adapter
  await Hive.openBox<UserModel>('users');
  // Initialize NotificationController
  Get.put(NotificationController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQLService.initClient(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
