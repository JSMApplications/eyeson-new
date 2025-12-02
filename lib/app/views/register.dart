import 'dart:io';
import 'package:eyeson/app/service/auth_service.dart';
import 'package:eyeson/app/themes/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  Future<void> registerWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final user = await AuthService().registerWithEmail(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    if (user != null) print("Registration Success: ${user.user?.email}");
  }

  Future<void> registerWithGoogle() async {
    final user = await AuthService().loginWithGoogle();
    if (user != null) {
      Get.offAllNamed(AppRoutesPath.HOME);
    }
  }

  void registerWithApple() {
    print("Apple register");
  }

  Future<void> registerWithFacebook() async {
    final user = await AuthService().loginWithFacebook();
    if (user != null) {
      Get.offAllNamed(AppRoutesPath.HOME);
    }
  }

  void goToLogin() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isAndroid = Platform.isAndroid;
    final bool isIOS = Platform.isIOS;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Logo
                SizedBox(
                  height: size.height * 0.15,
                  child: Image.asset(
                    "assets/logo-final-01.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Create Your Account",
                  style: TextStyle(
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sign up to explore nearby restaurants and offers.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 30),

                // Email Field
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: AppTheme.themeColor,
                  decoration: InputDecoration(
                    hintText: "Email",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.themeColor)),
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Password Field
                TextField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  cursorColor: AppTheme.themeColor,
                  decoration: InputDecoration(
                    hintText: "Password",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.themeColor)),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Confirm Password Field
                TextField(
                  controller: confirmPasswordController,
                  obscureText: hideConfirmPassword,
                  cursorColor: AppTheme.themeColor,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.themeColor)),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hideConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          hideConfirmPassword = !hideConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: registerWithEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // OR separator
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "OR",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 20),

                // Social Signup Buttons (icons only)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isAndroid)
                      IconButton(
                        onPressed: registerWithGoogle,
                        icon: Image.asset(
                          "assets/google.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                    if (isIOS)
                      IconButton(
                        onPressed: registerWithApple,
                        icon: const Icon(Icons.apple,
                            color: Colors.black, size: 40),
                      ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: registerWithFacebook,
                      icon: Icon(Icons.facebook,
                          color: Colors.blue[800], size: 40),
                    ),
                  ],
                ),

                SizedBox(height: Get.height * 0.03),

                // Login Redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: goToLogin,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.themeColor),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
