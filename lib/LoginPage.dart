import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hipsterassignment/helper/CustomeWidget.dart';
import 'package:hipsterassignment/login_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = Get.put(LoginController());
  final RxBool isPasswordHidden = true.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: ClipOval(
                        child: Image.asset('assets/logo.jpeg', width: 84, height: 84),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Welcome Back',
                        style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text('Sign in to continue',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                    const SizedBox(height: 24),

                    // Login Card
                    Card(
                      color: Colors.white,
                      elevation: 10,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            TextField(
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: CustomeWidget().inputDecoration(label: 'Email', prefix: Icons.email_outlined),
                            ),
                            const SizedBox(height: 16),
                            Obx(() => TextField(
                              controller: controller.passwordController,
                              obscureText: isPasswordHidden.value,
                              decoration: CustomeWidget().inputDecoration(
                                label: 'Password',
                                prefix: Icons.lock_outline,
                                suffix: IconButton(
                                  icon: Icon(isPasswordHidden.value
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () => isPasswordHidden.value = !isPasswordHidden.value,
                                ),
                              ),
                            )),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(onPressed: () {}, child: const Text('Forgot password?')),
                            ),
                            Obx(() => controller.errorMessage.value.isEmpty
                                ? const SizedBox.shrink()
                                : Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(controller.errorMessage.value,
                                      style: const TextStyle(color: Colors.red)),
                                ),
                              ],
                            )),
                            const SizedBox(height: 8),
                            Obx(() => SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value ? null : controller.login,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2575FC),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12))),
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                )
                                    : const Text('Login'),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'By continuing you agree to our Terms and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
