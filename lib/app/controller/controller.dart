import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eyeson/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:apple_vision_recognize_text/apple_vision_recognize_text.dart';

import 'package:geocoding/geocoding.dart';

class Controller extends GetxController {
  LatLng currentPosition = LatLng(0, 0);
  RxList<dynamic> resData = RxList();

  void navigateToNextScreen() {
    Get.toNamed(AppRoutesPath.HOME);
  }

  RxString extractedText = ''.obs;
  RxString predictedFont = 'Roboto'.obs;
  RxBool loading = false.obs;
  RxBool isAIThinking = false.obs;
  RxBool isSearching = false.obs;
  RxString statusMessage = ''.obs;

  Future<void> analyzeImage(File file) async {
    loading.value = true;
    extractedText.value = '';

    try {
      // 1. Priority: Try Offline Apple Vision (Fast & Local for iOS/macOS)
      statusMessage.value = "Detecting text (Offline)...";
      if (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        bool appleSuccess = await _analyzeWithAppleVision(file);
        if (appleSuccess) return;
      }

      // 2. Fallback: Python API (AWS Rekognition via Server)
      statusMessage.value = "Processing with Server...";
      bool pythonSuccess = await _analyzeWithPythonApi(file);
      if (pythonSuccess) return;

      extractedText.value =
          '❌ Detection failed. Please check internet or try a clearer image.';
    } catch (e) {
      extractedText.value = '❌ An error occurred: $e';
    } finally {
      loading.value = false;
      isAIThinking.value = false;
      isSearching.value = false;
      statusMessage.value = "";
    }
    update();
  }

  Future<bool> _analyzeWithAppleVision(File file) async {
    isAIThinking.value = true;
    statusMessage.value = "Detecting Text (Offline)...";
    try {
      final bytes = await file.readAsBytes();
      final AppleVisionRecognizeTextController recognizer =
          AppleVisionRecognizeTextController();
      RecognizeTextData textData =
          RecognizeTextData(image: bytes, imageSize: Size(640, 640 * 9 / 16));
      final List<RecognizedText>? result =
          await recognizer.processImage(textData);

      if (result != null && result.isNotEmpty) {
        // Collect all detected text
        String detected = result.map((e) => e.listText).join(" ").trim();
        extractedText.value = detected;
        predictedFont.value = "Roboto";

        isAIThinking.value = false;
        statusMessage.value = "AI Detected: '$detected'";

        // Brief delay so user can read what AI found
        await Future.delayed(const Duration(milliseconds: 1500));

        await loadJsonAndSearch(detected);
        return true;
      }
    } catch (e) {
      isAIThinking.value = false;
      print('Apple Vision Error: $e');
    }
    isAIThinking.value = false;
    return false;
  }

  Future<bool> _analyzeWithPythonApi(File file) async {
    isAIThinking.value = true;
    statusMessage.value = "AI Font Detect...";
    const String apiUrl = 'http://52.201.211.254:3440/process';
    try {
      final dio = Dio();
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await dio.post(apiUrl, data: formData);
      final data = response.data;
      if (data["status"] == "success") {
        String detected = (data["text"] ?? "").toString().trim();
        extractedText.value = detected;
        predictedFont.value = data["font"] ?? "System Detected";

        isAIThinking.value = false;
        statusMessage.value = "AI Detected: '$detected'";

        // Brief delay so user can read what AI found
        await Future.delayed(const Duration(milliseconds: 1500));

        await loadJsonAndSearch(detected);
        return true;
      }
    } catch (e) {
      isAIThinking.value = false;
      print('Python OCR Error: $e');
    }
    isAIThinking.value = false;
    return false;
  }

  Future<void> loadJsonAndSearch(String search) async {
    // Clean the search string: replace newlines with spaces and trim
    search = search.replaceAll('\n', ' ').replaceAll('\r', ' ').trim();
    // Remove multiple spaces
    search = search.replaceAll(RegExp(r'\s+'), ' ');

    if (search.isEmpty || search.trim().length < 2) {
      Get.snackbar(
        "Invalid Query",
        "The detected text is too short to search.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    loading.value = true;
    isSearching.value = true;
    statusMessage.value = "Searching Data...";
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ));
      String baseUrl = "https://serpapi.com/search";
      String locationParam = "San Francisco, CA";

      if (currentPosition.latitude != 0 && currentPosition.longitude != 0) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
              currentPosition.latitude, currentPosition.longitude);
          if (placemarks.isNotEmpty) {
            final place = placemarks[0];

            // Check if the current country is Pakistan
            bool isPakistan = (place.isoCountryCode == 'PK' ||
                (place.country ?? '').toLowerCase().contains('pakistan'));

            if (!isPakistan) {
              // If NOT Pakistan, use the detected city, state, and country
              locationParam = [
                place.locality,
                place.administrativeArea,
                place.country
              ]
                  .where((element) => element != null && element.isNotEmpty)
                  .join(", ");
            } else {
              // If it IS Pakistan, default to San Francisco (Yelp doesn't work in PK)
              locationParam = "San Francisco, CA";
            }
          }
        } catch (e) {
          print("Geocoding Error: $e");
        }
      }
      print("Location Param: $locationParam");

      final queryParams = {
        "engine": "yelp",
        "find_desc": search,
        "find_loc": locationParam,
        "api_key":
            "cc6dc4b357b1a8c6f9859feed3f9dc7bbb5d8be39ddfb80b36b8479666727c42"
      };

      // Logging the FULL URL for debugging
      final fullUrl =
          Uri.parse(baseUrl).replace(queryParameters: queryParams).toString();
      print("🚀 FULL API REQUEST URL: $fullUrl");

      final response = await dio.get(baseUrl, queryParameters: queryParams);

      final organic = response.data['organic_results'];
      final ads = response.data['ads_results'];

      List? rawResults;
      if (organic != null && organic is List && organic.isNotEmpty) {
        rawResults = organic;
        print("✅ Found Organic Results (${organic.length})");
      } else if (ads != null && ads is List && ads.isNotEmpty) {
        rawResults = ads;
        print("✅ Found Ads Results (${ads.length})");
      }

      if (rawResults != null && rawResults.isNotEmpty) {
        // Map results to match UI data structure
        final mappedResults = rawResults.map((e) {
          return {
            'title': e['title'] ?? 'No Title',
            'thumbnail': e['thumbnail'] ?? 'https://via.placeholder.com/150',
            'reviews': e['reviews']?.toString() ?? '0',
            'rating': e['rating']?.toString() ?? 'N/A',
            'phone': e['phone'] ?? 'N/A',
            'link': e['link'],
            'snippet': e['snippet'] ?? e['address'] ?? '',
            'place_ids': e['place_ids'] ?? [],
            'categories': e['categories'] ?? [],
          };
        }).toList();

        resData.assignAll(mappedResults);
        loading.value = false;
        isSearching.value = false;
        update();
        return;
      } else {
        print("⚠️ SerpApi returned zero results (Organic & Ads both empty).");
      }
    } catch (e) {
      Get.snackbar(
        "Search Error",
        "Could not fetch online results. Switching to offline mode.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }

    // Fallback to Local JSON if Scraper fails
    print("Falling back to local search...");
    statusMessage.value = "Searching offline...";
    await _searchLocalJson(search);

    // Ensure loading is turned off after fallback
    loading.value = false;
    isSearching.value = false;
    statusMessage.value = "";
    update();
  }

  Future<void> _searchLocalJson(String search) async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/yelp_data.json');
      final dynamic decodedData = json.decode(response);

      List businesses = [];
      if (decodedData is List) {
        businesses = decodedData;
      } else if (decodedData is Map && decodedData.containsKey('businesses')) {
        businesses = decodedData['businesses'];
      } else {
        businesses = [decodedData];
      }

      final term = search.toLowerCase();
      var filtered = businesses.where((b) {
        final name = (b['name'] ?? '').toString().toLowerCase();
        final location = b['location'] ?? {};
        final city = (location['city'] ?? '').toString().toLowerCase();

        final categoryList = b['categories'] as List? ?? [];
        final categories = categoryList
            .map((c) => (c['title'] ?? '').toString().toLowerCase())
            .join(' ');

        return name.contains(term) ||
            city.contains(term) ||
            categories.contains(term);
      }).toList();

      final mappedFiltered = filtered.map((e) {
        return {
          'title': e['name'] ?? 'No Title',
          'thumbnail': e['image_url'] ?? 'https://via.placeholder.com/150',
          'reviews': e['review_count']?.toString() ?? '0',
          'rating': e['rating']?.toString() ?? 'N/A',
          'phone': e['phone'] ?? 'N/A',
          'link': e['url'],
          'snippet': e['location']?['display_address']?.join(', ') ?? '',
          'place_ids': [e['id']],
          'categories': e['categories'] ?? [],
        };
      }).toList();

      resData.assignAll(mappedFiltered);

      if (mappedFiltered.isEmpty) {
        Get.snackbar(
          "No Results",
          "No matching places found offline or online for '$search'.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Local Search Error: $e');
      Get.snackbar("Error", "Failed to search local data.");
    }
  }
}
