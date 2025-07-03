import 'package:camera/camera.dart';
import 'package:eyeson/app/controller/splash_controller.dart';
import 'package:eyeson/app/routes/app_routes.dart';
import 'package:eyeson/app/themes/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  cameras = await availableCameras();
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
