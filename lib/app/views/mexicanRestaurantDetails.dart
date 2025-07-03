import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:eyeson/app/routes/app_routes.dart';
import 'package:eyeson/app/themes/apptheme.dart';
import 'package:eyeson/app/widgets/actionButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MexicanRestaurantDetails extends StatefulWidget {
  String id;
  MexicanRestaurantDetails({super.key, required this.id});

  @override
  State<MexicanRestaurantDetails> createState() =>
      _MexicanRestaurantDetailsState();
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

class _MexicanRestaurantDetailsState extends State<MexicanRestaurantDetails> {
  Map<String, dynamic> data = {};
  @override
  initState() {
    getYelpData();
    super.initState();
  }

  void openDialPad(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch $telUri';
    }
  }

  void openChrome(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode
            .externalApplication, // open external browser (Chrome, Safari, etc)
      );
    } else {
      throw 'Could not launch $uri';
    }
  }

  void openMap(double latitude, double longitude) async {
    final Uri uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $uri';
    }
  }

  String formatCategories(List<dynamic> categories) {
    return categories.map((cat) => cat['title']).join(' - ');
  }

  Future<void> getYelpData() async {
    final dio = Dio();
    try {
      final response =
          await dio.get('https://api.yelp.com/v3/businesses/${widget.id}',
              options: Options(
                headers: {
                  "Authorization":
                      "Bearer MGegcpYYc20n3uQgMO70KWPAQ07RfWAd5KG9-pcyUJ_ga3p2qZIHLXumHu8VFWLbxjkGDKsup5rpGyzx7Y8WIviNnUQAqdc8PTxUPh7cQJtq9qrExzqN5S-vm8RFaHYx",
                  'accept': 'application/json',
                },
              ));

      if (response.statusCode == 200) {
        setState(() {
          data.assignAll(response.data);
        });
      }
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: AppTheme.whiteColor,
        child: data.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Image with overlay
                    Stack(
                      children: [
                        Image.network(
                          '${data['image_url']}',
                          width: double.infinity,
                          height: size.height * 0.35,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 40,
                          left: 20,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 60,
                          child:
                              Icon(Icons.favorite_border, color: Colors.white),
                        ),
                        Positioned(
                          top: 40,
                          right: 20,
                          child: Icon(Icons.share, color: Colors.white),
                        ),
                        Positioned(
                          top: 40,
                          right: 100,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.orange, size: 16),
                                Text(
                                  "${data['rating']}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Title and Address
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${data['name']}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRoutesPath.AIRPORTSECURITY);
                                },
                                child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3),
                                    child: Icon(Icons.bookmark_border)),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            "${formatAddress(data['location'])}",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),

                    // Events Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Photos",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 160,
                      child: CarouselSlider(
                        options: CarouselOptions(height: 400.0, autoPlay: true),
                        items:
                            (data['photos'] as List<dynamic>).map<Widget>((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration:
                                    BoxDecoration(color: Colors.black12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    i.toString(), // safely convert dynamic to string
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(), // <-- now correctly returns List<Widget>
                      ),

                      // child: Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Container(
                      //       width: size.width * 0.3,
                      //       height: size.height * 0.2,
                      //       child: Image.asset(
                      //         "assets/mexicanProductImg1.jpg",
                      //         fit: BoxFit.cover,
                      //       ),
                      //     ),
                      //     Container(
                      //       width: size.width * 0.6,
                      //       height: size.height * 0.2,
                      //       child: Image.asset(
                      //         "assets/mexicanProductImg2.jpg",
                      //         fit: BoxFit.cover,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),

                    // Order online
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () {
                          openChrome(
                              data['attributes']['menu_url'] ?? data['url']);
                        },
                        child: Container(
                          width: size.width,
                          height: size.height * 0.16,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.greyColor,
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: size.width * 0.2,
                                  height: size.height * 0.12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Image.network(
                                    '${data['image_url']}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.65,
                                  height: size.height * 0.14,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Order Food Online",
                                              style: TextStyle(
                                                color: AppTheme.blackColor,
                                                fontSize: size.width * 0.04,
                                              ),
                                            ),
                                            Container(
                                              width: Get.width * 0.5,
                                              child: Text(
                                                formatCategories(
                                                    data['categories']),
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: AppTheme.blackColor,
                                                  fontSize: size.width * 0.025,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          size: size.width * 0.08,
                                          color: AppTheme.themeColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ActionButton(
                            icon: Icons.reviews,
                            label: "${data['review_count']}\nReviews",
                            bgColor: Colors.blue.shade100,
                            size: size,
                          ),
                          GestureDetector(
                            onTap: () {
                              openDialPad(data['phone']);
                            },
                            child: ActionButton(
                              icon: Icons.call,
                              label: "Call",
                              bgColor: Colors.green.shade100,
                              size: size,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              openMap(data['coordinates']['latitude'],
                                  data['coordinates']['longitude']);
                            },
                            child: ActionButton(
                              icon: Icons.directions,
                              label: "Direction",
                              bgColor: Colors.grey.shade300,
                              size: size,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              openChrome(data['attributes']['menu_url'] ??
                                  data['url']);
                            },
                            child: ActionButton(
                              icon: Icons.language,
                              label: "Website",
                              bgColor: Colors.brown.shade100,
                              size: size,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
