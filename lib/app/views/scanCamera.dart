import 'dart:io';

import 'package:camera/camera.dart';
import 'package:eyeson/app/controller/controller.dart';
import 'package:eyeson/app/themes/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanCamera extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const ScanCamera({this.cameras, super.key});

  @override
  State<ScanCamera> createState() => _ScanCameraState();
}

class _ScanCameraState extends State<ScanCamera> {
  late CameraController controller;
  bool isInitialized = false;
  List<CameraDescription> cameras = [];
  Controller getController = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args is List<CameraDescription>) {
      cameras = args;
    }

    if (cameras.isNotEmpty) {
      controller = CameraController(cameras.first, ResolutionPreset.high);
      controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          isInitialized = true;
        });
      }).catchError((e) {
        print("Camera initialization error: $e");
      });
    } else {
      print("No cameras found");
    }
  }

  @override
  void dispose() {
    if (isInitialized) controller.dispose();
    super.dispose();
  }

  Future<void> onImagePick() async {
    try {
      if (!controller.value.isInitialized || controller.value.isTakingPicture)
        return;
      final image = await controller.takePicture();
      // Optionally save or preview the image
      print("Captured image path: ${image.path}");
      // Send image path to the next screen or upload
      // await getController.analyzeImage(File(image.path));
      // Show modal with image preview
      Get.dialog(
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  if (getController.isAIThinking.value) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.themeColor),
                          ),
                        ),
                        const Icon(Icons.psychology,
                            size: 40, color: AppTheme.themeColor),
                      ],
                    );
                  } else if (getController.isSearching.value) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                        ),
                        const Icon(Icons.search, size: 40, color: Colors.green),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
                const SizedBox(height: 25),
                Obx(() => Text(
                      getController.statusMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                      ),
                    )),
                const SizedBox(height: 10),
                const Text(
                  "Please wait while we process",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
      await getController.analyzeImage(File(image.path));
      
      // Safety check: close the dialog if it's still open
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      
      // Close the Camera Screen (using Navigator to be more specific than Get.back)
      if (mounted) {
        Navigator.of(context).pop();
      }
      // showDialog(
      //   context: context,
      //   builder: (_) => AlertDialog(
      //     contentPadding: EdgeInsets.zero,
      //     content: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Image.file(File(image.path)),
      //         const SizedBox(height: 10),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             ElevatedButton(
      //               onPressed: () {
      //                 Get.back(); // close modal
      //                 // Optionally delete file if you don't want to keep it
      //               },
      //               child: const Text("Retake"),
      //             ),
      //             ElevatedButton(
      //               onPressed: () async {
      //                 await getController.analyzeImage(File(image.path));
      //               },
      //               child: const Text("Use"),
      //             ),
      //           ],
      //         ),
      //         const SizedBox(height: 10),
      //       ],
      //     ),
      //   ),
      // );
      // Get.toNamed(AppRoutesPath.FAVOURITES, arguments: {"ocrText": ocrText});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: cameras.isEmpty
          ? const Center(child: Text("No camera available"))
          : isInitialized
              ? Stack(
                  children: [
                    Positioned.fill(child: CameraPreview(controller)),

                    // Close button top-right
                    Positioned(
                      top: 40,
                      right: 20,
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.close,
                          color: AppTheme.whiteColor,
                          size: 28,
                        ),
                      ),
                    ),

                    // Overlay corners
                    Center(
                      child: SizedBox(
                        width: size.width * 0.65,
                        height: size.width * 0.65,
                        child: CustomPaint(painter: _ScanOverlayPainter()),
                      ),
                    ),

                    // Scan Button bottom
                    Positioned(
                      bottom: 30,
                      left: 20,
                      right: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          onImagePick();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.themeColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Obx(() => getController.loading.value
                            ? const CircularProgressIndicator()
                            : Text(
                                "SCAN NOW",
                                style: TextStyle(
                                  color: AppTheme.whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                      ),
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.themeColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const cornerSize = 30.0;

    // Top-left
    canvas.drawLine(Offset(0, 0), Offset(cornerSize, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerSize), paint);

    // Top-right
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - cornerSize, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerSize),
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerSize, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cornerSize),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerSize, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cornerSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
