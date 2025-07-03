import 'package:eyeson/app/routes/app_routes.dart';
import 'package:eyeson/app/themes/apptheme.dart';
import 'package:eyeson/app/widgets/actionButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VenueDetails extends StatelessWidget {
  const VenueDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: AppTheme.whiteColor,
          child: Column(
            children: [
              // Header Image with overlay
              Stack(
                children: [
                  Image.asset(
                    'assets/venueDetailsImg1.jpeg',
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
                    child: Icon(Icons.favorite_border, color: Colors.white),
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
                          Icon(Icons.star, color: Colors.orange, size: 16),
                          Text(
                            "4.6",
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
                            "Planterra Conservatory",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutesPath.MEXICANRESTAURENT);
                          },
                          child: Icon(Icons.bookmark_border),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      "West Bloomfield Township, MI\nSan Francisco, CA 94132",
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
                    "Events",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _eventCard(
                      "Eric Church Tickets",
                      "20min only",
                      "assets/venueDetailsImg2.jpg",
                    ),
                    _eventCard(
                      "Music Events",
                      "Next in 30min",
                      "assets/venueDetailsImg3.jpg",
                    ),
                    _eventCard(
                      "Fest Season",
                      "Today 5PM",
                      "assets/venueDetailsImg4.jpeg",
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ActionButton(
                      icon: Icons.local_parking,
                      label: "Parking",
                      bgColor: Colors.blue.shade100,
                      size: size,
                    ),
                    ActionButton(
                      icon: Icons.call,
                      label: "Call",
                      bgColor: Colors.green.shade100,
                      size: size,
                    ),
                    ActionButton(
                      icon: Icons.directions,
                      label: "Direction",
                      bgColor: Colors.grey.shade300,
                      size: size,
                    ),
                    ActionButton(
                      icon: Icons.language,
                      label: "Website",
                      bgColor: Colors.brown.shade100,
                      size: size,
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

  Widget _eventCard(String title, String subtitle, String imageUrl) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
