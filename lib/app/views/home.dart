import 'package:eyeson/app/controller/controller.dart';
import 'package:eyeson/app/routes/app_routes.dart';
import 'package:eyeson/app/themes/apptheme.dart';
import 'package:eyeson/app/views/login.dart';
import 'package:eyeson/app/views/mexicanRestaurantDetails.dart';
import 'package:eyeson/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

String formatAddress(Map<String, dynamic> location) {
  List<String> parts = [];

  if ((location['address1'] ?? '').isNotEmpty) {
    parts.add(location['address1']);
  }
  if ((location['address2'] ?? '').isNotEmpty) {
    parts.add(location['address2']);
  }
  if ((location['address3'] ?? '').isNotEmpty) {
    parts.add(location['address3']);
  }

  String cityStateZip = '';
  if ((location['city'] ?? '').isNotEmpty) {
    cityStateZip += location['city'];
  }
  if ((location['state'] ?? '').isNotEmpty) {
    cityStateZip += ', ${location['state']}';
  }
  if ((location['zip_code'] ?? '').isNotEmpty) {
    cityStateZip += ' ${location['zip_code']}';
  }
  if (cityStateZip.isNotEmpty) {
    parts.add(cityStateZip);
  }

  return parts.join(", ");
}

class _HomeState extends State<Home> {
  Controller controller = Get.put(Controller());
  bool hasLocationPermission = false;
  Position? currentPosition;
  bool? isLocation;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;

  Future<void> _handleLocationAccess() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location services are disabled")),
      );
      return;
    }

    // Check current permission status
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Location permission denied.')));
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('❌ Location permission permanently denied.')));
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool("@isLocation", true);

    setState(() {
      hasLocationPermission = true;
      currentPosition = position;
      controller.currentPosition =
          LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    checkLocation();
    _handleLocationAccess();
    _checkCurrentUser();
    super.initState();
  }

  void _checkCurrentUser() {
    currentUser = _auth.currentUser;
    setState(() {});
  }

  Future<void> checkLocation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLocation = sharedPreferences.getBool("@isLocation") ?? false;
    setState(() {
      this.isLocation = isLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: AppTheme.whiteColor,
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: isLocation == null
                        ? const Center(child: CircularProgressIndicator())
                        : hasLocationPermission && currentPosition != null
                            ? GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    currentPosition!.latitude,
                                    currentPosition!.longitude,
                                  ),
                                  zoom: 16,
                                ),
                                myLocationEnabled: true,
                                markers: {
                                  Marker(
                                    markerId: const MarkerId("currentLocation"),
                                    position: LatLng(
                                      currentPosition!.latitude,
                                      currentPosition!.longitude,
                                    ),
                                    infoWindow:
                                        const InfoWindow(title: "You are here"),
                                  ),
                                },
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: GestureDetector(
                                      onTap: _handleLocationAccess,
                                      child: Container(
                                        width: size.width,
                                        height: size.height * 0.07,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: AppTheme.themeColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Allow access to your location",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppTheme.whiteColor,
                                              fontSize: size.width * 0.05,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      width: Get.width,
                      height: Get.height * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/logo.gif",
                            fit: BoxFit.contain,
                            width: Get.width * 0.85,
                            height: Get.height * 0.1,
                            alignment: Alignment.center,
                          ),
                          GestureDetector(
                              onTap: () {
                                if (currentUser == null) {
                                  Get.to(() => const LoginPage());
                                } else {
                                  Get.to(() => const ProfilePage());
                                }
                              },
                              child: const Icon(Icons.account_circle, size: 30)),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    child: Container(
                      width: Get.width,
                      height: Get.height * 0.18,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Obx(() {
                        if (controller.resData.isEmpty) {
                          if (controller.loading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return Container(
                            alignment: Alignment.center,
                            child: const Text("No matching places found.",
                                style: TextStyle(color: Colors.grey)),
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: controller.resData.length,
                            itemBuilder: (context, i) {
                              final res = controller.resData[i];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(MexicanRestaurantDetails(
                                      resData: res,
                                      id: res['place_ids']?[0] ?? ''));
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  elevation: 5,
                                  shadowColor: Colors.black26,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Colors.white,
                                  child: Container(
                                    width: Get.width * 0.86,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      children: [
                                        // Image thumbnail
                                        Container(
                                          width: Get.width * 0.28,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      res['thumbnail'] ?? '')),
                                              borderRadius:
                                                  const BorderRadius.horizontal(
                                                      left:
                                                          Radius.circular(20))),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle),
                                                  child: const Icon(
                                                      Icons.favorite_border,
                                                      size: 16,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Information section
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 10, 12, 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "${res['title'] ?? 'Restaurant'}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.star_rounded,
                                                            color:
                                                                Colors.orange,
                                                            size: 16),
                                                        Text(
                                                          " ${res['rating'] ?? '4.0'}",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.orange,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.phone_outlined,
                                                        size: 14,
                                                        color:
                                                            Colors.blueGrey),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "${res['phone'] ?? 'N/A'}",
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                if (res['categories'] != null)
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children:
                                                          (res['categories']
                                                                  as List)
                                                              .take(3)
                                                              .map<Widget>(
                                                                  (cat) {
                                                        return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 6),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 4),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppTheme
                                                                .themeColor
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Text(
                                                            cat['title'] ?? '',
                                                            style: const TextStyle(
                                                                color: AppTheme
                                                                    .themeColor,
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ),

            // The scan button section stays always visible
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: size.width * 0.24,
                    height: size.width * 0.24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.themeColor, width: 2),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRoutesPath.SCANCAMERA,
                            arguments: cameras,
                          );
                        },
                        child: Container(
                          width: size.width * 0.2,
                          height: size.width * 0.2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.themeColor,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.center_focus_strong_outlined,
                              color: AppTheme.whiteColor,
                              size: size.width * 0.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
