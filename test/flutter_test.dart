import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hipsterassignment/login_page.dart';
import 'package:get/get.dart';

void main() {
  tearDown(() {
    Get.reset(); // clean up after each test
  });

  testWidgets('LoginPage loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign in to continue'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Logo is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Email and Password fields are present', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('Password visibility toggle works', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));
    final toggleButton = find.byIcon(Icons.visibility_off);
    expect(toggleButton, findsOneWidget);

    await tester.tap(toggleButton);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

  testWidgets('Forgot password link exists', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));
    expect(find.text('Forgot password?'), findsOneWidget);
  });

}
