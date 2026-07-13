import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eyeson/app/controller/controller.dart';
import 'package:eyeson/app/themes/apptheme.dart';

class TextDetectionView extends StatelessWidget {
  final Controller controller = Get.find<Controller>();
  final ImagePicker _picker = ImagePicker();

  // List of popular fonts to preview
  final List<String> previewFonts = [
    'Roboto',
    'Playfair Display',
    'Lora',
    'Oswald',
    'Pacifico',
    'Dancing Script',
    'Montserrat',
    'Abril Fatface',
    'Bebas Neue',
    'Caveat',
    'Righteous',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text("Font & Text Lab",
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.themeColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildTopBanner(),
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.extractedText.value.isEmpty) {
                return _buildEmptyState();
              }
              return _buildFontGallery();
            }),
          ),
          _buildBottomAction(context),
        ],
      ),
    );
  }

  Widget _buildTopBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.themeColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Text(
            "Detected Text",
            style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 5),
          Obx(() => Text(
                controller.extractedText.value.isEmpty
                    ? "No text yet"
                    : controller.extractedText.value,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  Widget _buildFontGallery() {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: previewFonts.length,
      itemBuilder: (context, index) {
        String fontName = previewFonts[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(fontName,
                        style: GoogleFonts.outfit(
                            color: Colors.grey, fontSize: 12)),
                    if (controller.predictedFont.value == fontName)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Text("MATCHED",
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  controller.extractedText.value,
                  style: GoogleFonts.getFont(fontName,
                      fontSize: 22, color: AppTheme.blackColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.text_fields_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          Text(
            "Upload an image to detect text\nand preview styles",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCircularButton(Icons.photo_library, "Gallery",
              () => _pickImage(ImageSource.gallery)),
          _buildCircularButton(
              Icons.camera_alt, "Camera", () => _pickImage(ImageSource.camera)),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: AppTheme.themeColor, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(label,
              style: GoogleFonts.outfit(
                  fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      controller.analyzeImage(File(image.path));
    }
  }
}
