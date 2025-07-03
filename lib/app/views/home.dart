import 'package:eyeson/app/controller/controller.dart';
import 'package:eyeson/app/routes/app_routes.dart';
import 'package:eyeson/app/themes/apptheme.dart';
import 'package:eyeson/app/views/mexicanRestaurantDetails.dart';
import 'package:eyeson/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<void> _handleLocationAccess() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        hasLocationPermission = true;
        currentPosition = position;
        controller.currentPosition =
            LatLng(position.latitude, position.longitude);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
    }
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: hasLocationPermission && currentPosition != null
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
                              // Image.asset(
                              //   "assets/logo.gif",
                              //   fit: BoxFit.contain,
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: GestureDetector(
                                  onTap: _handleLocationAccess,
                                  child: Container(
                                    width: size.width,
                                    height: size.height * 0.07,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
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
                      child: Image.asset(
                        "assets/logo.gif",
                        fit: BoxFit.contain,
                        width: Get.width,
                        height: Get.height * 0.1,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    child: Container(
                      width: Get.width,
                      height: Get.height * 0.18,
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: Obx(() {
                        if (controller.resData.isEmpty) {
                          return SizedBox();
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.resData.length,
                            itemBuilder: (context, i) {
                              String fullAddress = formatAddress(
                                  controller.resData[i]['location']);
                              bool isOpen = controller.resData[i]
                                  ['business_hours'][0]['is_open_now'];

                              return GestureDetector(
                                onTap: () {
                                  Get.to(MexicanRestaurantDetails(
                                      id: controller.resData[i]['id']));
                                },
                                child: Card(
                                  margin: EdgeInsets.only(
                                      left: 10, top: 10, bottom: 10, right: 10),
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    width: Get.width * 0.93,
                                    height: Get.height * 0.11,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: Get.width * 0.32,
                                          height: Get.height,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                      controller.resData[i]
                                                          ['image_url'])),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                  width: 35,
                                                  height: 35,
                                                  margin: EdgeInsets.only(
                                                      top: 5, right: 5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: Icon(
                                                      Icons.favorite_border)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              top: 10,
                                              bottom: 10,
                                              right: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: Get.width * 0.56,
                                                color: Colors.transparent,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: Get.width * 0.4,
                                                      child: Text(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          "${controller.resData[i]['name']}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                    ),
                                                    Text(
                                                      "★ ${controller.resData[i]['rating']}",
                                                      style: TextStyle(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              244, 179, 26),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: isOpen
                                                        ? Get.width * 0.42
                                                        : Get.width * 0.4,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    child: Text(
                                                        "📞${controller.resData[i]['phone']}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2,
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        color: isOpen
                                                            ? Colors.green
                                                            : const Color
                                                                .fromARGB(219,
                                                                254, 18, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100)),
                                                    alignment:
                                                        Alignment.centerRight,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    child: Text(
                                                        isOpen
                                                            ? "Open"
                                                            : "Closed",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: Get.width * 0.5,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: Text("📍${fullAddress}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              )
                                            ],
                                          ),
                                        )
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
                // Text(
                //   "Scan",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //       color: AppTheme.FontColor,
                //       fontSize: size.width * 0.045,
                //       fontWeight: FontWeight.w600),
                // ),
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
                          // Navigate to scan screen if needed
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
