import 'package:camera/camera.dart';
import 'package:camera_android/camera_android.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:eyeson/app/controller/splash_controller.dart';
import 'package:eyeson/app/routes/app_routes.dart';
import 'package:eyeson/app/themes/apptheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android) {
    CameraPlatform.instance = AndroidCamera();
  }
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  try {
    if (Firebase.apps.isEmpty) {
      FirebaseOptions options;
      if (defaultTargetPlatform == TargetPlatform.android) {
        options = const FirebaseOptions(
          apiKey: 'AIzaSyAtf4YStpEL9oituVTsJu5k4_kHDvF1X4g',
          appId: '1:464702258818:android:258372aa1de216b5c93e9b',
          messagingSenderId: '464702258818',
          projectId: 'eyeson-1808f',
          storageBucket: 'eyeson-1808f.firebasestorage.app',
        );
      } else {
        // iOS, macOS, etc.
        options = const FirebaseOptions(
          apiKey: 'AIzaSyDAGQNcKZ1ZA8bbHkEATmUMi4oK4t_fgMY',
          appId: '1:464702258818:ios:ecb70b50d40a35a6c93e9b',
          messagingSenderId: '464702258818',
          projectId: 'eyeson-1808f',
          storageBucket: 'eyeson-1808f.firebasestorage.app',
          iosBundleId: 'com.eyeson.app',
        );
      }
      await Firebase.initializeApp(options: options);
      if (kDebugMode) {
        print("✅ Firebase initialized successfully for ${defaultTargetPlatform.name}");
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print("Firebase initialization error: $e");
    }
  }
  try {
    cameras = await availableCameras();
  } catch (e) {
    if (kDebugMode) {
      print("Error fetching available cameras: $e");
    }
    cameras = []; // Fallback to empty list
  }

  runApp(const MyApp());
}

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: MyTheme.myTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutesPath.SPLASH,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.leftToRight,
      initialBinding: MainBinding(),
    );
  }
}
