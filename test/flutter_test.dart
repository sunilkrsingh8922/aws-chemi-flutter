
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hipsterassignment/login_page.dart';
import 'package:hipsterassignment/splash_screen.dart';

void main() {
  testWidgets('Splash screen shows logo', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('LoginPage loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
