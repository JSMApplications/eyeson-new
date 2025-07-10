import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eyeson/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Controller extends GetxController {
  LatLng currentPosition = LatLng(0, 0);
  RxList<dynamic> resData = RxList();
  void navigateToNextScreen() {
    Get.toNamed(AppRoutesPath.HOME);
  }

  RxString extractedText = ''.obs;
  RxBool loading = false.obs;

  Future<void> analyzeImage(File file) async {
    const String endpoint =
        'https://eyeson-vision.cognitiveservices.azure.com/';
    const String subscriptionKey = '1e26ab0dbbd1491b9f4380578a292f73';
    const String apiUrl = '${endpoint}computervision/imageanalysis:analyze'
        '?features=caption,read&model-version=latest&language=en&api-version=2024-02-01';

    loading.value = true;
    extractedText.value = '';
    try {
      final dio = Dio();
      final imageBytes = await file.readAsBytes();

      final response = await dio.post(
        apiUrl,
        data: imageBytes,
        options: Options(
          headers: {
            'Ocp-Apim-Subscription-Key': subscriptionKey,
            'Content-Type': 'application/octet-stream',
            'Content-Length': imageBytes.length.toString(),
          },
          responseType: ResponseType.json,
        ),
      );

      final data = response.data;
      print(data);
      List<String> ocrLines = [];

      if (data["readResult"] != null && data["readResult"]["blocks"] != null) {
        for (var block in data["readResult"]["blocks"]) {
          if (block["lines"] != null) {
            for (var line in block["lines"]) {
              ocrLines.add(line["text"]);
            }
          }
        }
      }

      extractedText.value = ocrLines.join('\n');
      print(ocrLines.join('\n'));
      getYelpData(ocrLines.join('\n'));
    } catch (e) {
      print('Error: $e');
      extractedText.value = '❌ Failed to analyze image.';
    } finally {
      loading.value = false;
    }
    update();
  }

  Future<void> getYelpData(String search) async {
    final dio = Dio();
    String qurey = currentPosition.latitude != 0
        ? 'latitude=${currentPosition.latitude}&longitude=${currentPosition.longitude}'
        : 'location=New York City';
    print(qurey);
    try {
      final response = await dio.get(
          'https://api.yelp.com/v3/businesses/search?${qurey}&term=${search}',
          options: Options(
            headers: {
              "Authorization":
                  "Bearer MGegcpYYc20n3uQgMO70KWPAQ07RfWAd5KG9-pcyUJ_ga3p2qZIHLXumHu8VFWLbxjkGDKsup5rpGyzx7Y8WIviNnUQAqdc8PTxUPh7cQJtq9qrExzqN5S-vm8RFaHYx",
              'accept': 'application/json',
            },
          ));

      if (response.statusCode == 200) {
        resData.assignAll(response.data['businesses']);
      }
      Get.back();
      Get.back();
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: "Error",
        message: "Please restart the app & try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      ));
      print('Error: $e');
    }
  }
}
