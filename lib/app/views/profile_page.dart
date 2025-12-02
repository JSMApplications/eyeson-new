// profile_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Assuming LoginPage is in app/views/login.dart
import 'login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ... (Your existing state and controller setup: user, _nameController, _emailController, _formKey)
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _nameController.text = user!.displayName ?? '';
      _emailController.text = user!.email ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ... (Your existing logout and updateProfile functions)

  // Function to handle logout
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => LoginPage());
      Get.snackbar('Success', 'Logged out successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print(e);
    }
  }

  // Function to update user profile
  Future<void> updateProfile() async {
    if (_formKey.currentState?.validate() != true || user == null) {
      return;
    }

    try {
      await user!.updateDisplayName(_nameController.text.trim());
      await user!.reload();
      setState(() {});

      Get.snackbar('Success', 'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
          'Update Failed', e.message ?? 'An error occurred during update.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  // --- UI Build Method (FIXED) ---

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: const Center(child: Text("User not logged in.")),
      );
    }

    // Determine the maximum width for the content (e.g., 600 for web/tablet look)
    final double maxContentWidth = 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        iconTheme: const IconThemeData(color: Colors.white),
        // Ensure primaryColor is defined in your theme
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Card(
              elevation: 8, // Added elevation for a nice lift
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Center vertically within the card
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Icon
                      const Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(height: 30),

                      // --- Display Name Field ---
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Display Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          // Added helper text for clarity
                          helperText: 'This name will be visible to others.',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your display name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // --- Email Field (Read-only) ---
                      TextFormField(
                        controller: _emailController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.email),
                          // Added visual cue that it's read-only
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 40),

                      // --- Action Buttons ---

                      // 1. Update Profile Button (Re-activated and styled)
                      ElevatedButton.icon(
                        onPressed: updateProfile,
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'Update Profile',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // 2. Logout Button
                      OutlinedButton.icon(
                        onPressed: logout,
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(
                              color: Colors.redAccent, width: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
