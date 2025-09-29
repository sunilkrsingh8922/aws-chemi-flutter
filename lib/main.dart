import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hipsterassignment/model/user_model.dart';
import 'package:hipsterassignment/state/notification_controller.dart';
import 'package:hive_flutter/adapters.dart';
import 'graph_ql_service.dart';
import 'splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase once here
  await Firebase.initializeApp();

  // ✅ Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('users');

  // ✅ Put NotificationController after Firebase init
  Get.putAsync(() async => NotificationController());

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
