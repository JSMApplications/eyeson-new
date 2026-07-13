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
  Map<String, dynamic> resData;
  MexicanRestaurantDetails(
      {super.key, required this.id, required this.resData});

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
          await dio.get('https://serpapi.com/search', queryParameters: {
        "engine": "yelp_place",
        "place_id": widget.id,
        "full_menu": "true",
        "api_key":
            "cc6dc4b357b1a8c6f9859feed3f9dc7bbb5d8be39ddfb80b36b8479666727c42"
      });

      if (response.statusCode == 200) {
        final results = response.data['full_menu_results'];
        if (results != null) {
          setState(() {
            data = results;
          });
        }
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: "Error",
        message: "Failed to fetch restaurant details from SerpApi.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      ));
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(data['popular_items']);
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
                          '${widget.resData['thumbnail']}',
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
                                  "${widget.resData['rating']}",
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
                                  "${widget.resData['title']}",
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
                            "${widget.resData['phone']}",
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
                    Container(
                      width: Get.width * 0.9,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: (widget.resData['categories'] as List)
                            .map<Widget>((cat) {
                          return Container(
                            margin: EdgeInsets.only(right: 5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.themeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: AppTheme.themeColor.withOpacity(0.5)),
                            ),
                            child: Text(
                              cat['title'] ?? '',
                              style: TextStyle(
                                  color: AppTheme.themeColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Order online
                    // Padding(
                    //   padding: EdgeInsets.all(16),
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       openChrome(
                    //           data['attributes']['menu_url'] ?? data['url']);
                    //     },
                    //     child: Container(
                    //       width: size.width,
                    //       height: size.height * 0.16,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: AppTheme.greyColor,
                    //           style: BorderStyle.solid,
                    //           width: 1,
                    //         ),
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Row(
                    //           children: [
                    //             Container(
                    //               width: size.width * 0.2,
                    //               height: size.height * 0.12,
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(12),
                    //               ),
                    //               child: Image.network(
                    //                 '${data['image_url']}',
                    //                 fit: BoxFit.cover,
                    //               ),
                    //             ),
                    //             Container(
                    //               width: size.width * 0.65,
                    //               height: size.height * 0.14,
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     Column(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.start,
                    //                       children: [
                    //                         Text(
                    //                           "Order Food Online",
                    //                           style: TextStyle(
                    //                             color: AppTheme.blackColor,
                    //                             fontSize: size.width * 0.04,
                    //                           ),
                    //                         ),
                    //                         Container(
                    //                           width: Get.width * 0.5,
                    //                           child: Text(
                    //                             formatCategories(
                    //                                 data['categories']),
                    //                             maxLines: 2,
                    //                             style: TextStyle(
                    //                               color: AppTheme.blackColor,
                    //                               fontSize: size.width * 0.025,
                    //                             ),
                    //                           ),
                    //                         )
                    //                       ],
                    //                     ),
                    //                     Icon(
                    //                       Icons.chevron_right,
                    //                       size: size.width * 0.08,
                    //                       color: AppTheme.themeColor,
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ActionButton(
                            icon: Icons.reviews,
                            label: "${widget.resData['reviews']}\nReviews",
                            bgColor: Colors.blue.shade100,
                            size: size,
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     openDialPad(widget.resData['phone']);
                          //   },
                          //   child: ActionButton(
                          //     icon: Icons.call,
                          //     label: "Call",
                          //     bgColor: Colors.green.shade100,
                          //     size: size,
                          //   ),
                          // ),
                          // GestureDetector(
                          //   onTap: () {
                          //     openMap(data['coordinates']['latitude'],
                          //         data['coordinates']['longitude']);
                          //   },
                          //   child: ActionButton(
                          //     icon: Icons.directions,
                          //     label: "Direction",
                          //     bgColor: Colors.grey.shade300,
                          //     size: size,
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              openChrome(widget.resData['link']);
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

                    data['popular_items'] != null &&
                            (data['popular_items'] as List).isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Popular Items",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.blackColor),
                              ),
                            ),
                          )
                        : SizedBox(),
                    Container(
                      width: size.width * 0.95,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: data['popular_items'] != null &&
                              (data['popular_items'] as List).isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data['popular_items'].length,
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 30),
                              itemBuilder: (context, index) {
                                final item = data['popular_items'][index];
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image on the left
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item['thumbnail'] ??
                                            'https://via.placeholder.com/80',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.fastfood,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Details on the right
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title'] ?? '',
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${item['reviewer'] ?? 'Anonymous'}: ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: item['review'] ??
                                                      'No review text available.',
                                                ),
                                              ],
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // const SizedBox(height: 4),
                                          // const Text(
                                          //   "Read more",
                                          //   style: TextStyle(
                                          //     color: Colors.blue,
                                          //     fontWeight: FontWeight.w500,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : SizedBox(),
                    ),
                    const SizedBox(height: 20),
                    data['sections'] != null &&
                            data['sections'] is List &&
                            (data['sections'] as List).isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "All Menus",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.blackColor),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Container(
                      width: size.width * 0.95,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: data['sections'] != null &&
                              data['sections'] is List
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: (data['sections'] as List).length,
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final section = data['sections'][index];
                                if (section == null) return const SizedBox();

                                final items = section['items'] as List? ?? [];

                                if (items.isEmpty) return const SizedBox();
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Text(
                                        section['title'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: items.length,
                                      separatorBuilder: (context, index) =>
                                          const Divider(height: 4),
                                      itemBuilder: (context, index) {
                                        final item1 = items[index];
                                        if (item1 == null)
                                          return const SizedBox();

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  item1['thumbnail'] ??
                                                      'https://via.placeholder.com/80',
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Container(
                                                    width: 80,
                                                    height: 80,
                                                    color: Colors.grey[200],
                                                    child: const Icon(
                                                        Icons.fastfood,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item1['title'] ?? '',
                                                      style: const TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    RichText(
                                                      text: TextSpan(
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14),
                                                        children: [
                                                          TextSpan(
                                                            text: item1[
                                                                    'description'] ??
                                                                'No description available.',
                                                          ),
                                                        ],
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    // const SizedBox(height: 4),
                                                    // const Text(
                                                    //   "Read more",
                                                    //   style: TextStyle(
                                                    //     color: Colors.blue,
                                                    //     fontWeight:
                                                    //         FontWeight.w500,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
