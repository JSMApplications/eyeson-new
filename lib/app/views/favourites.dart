import 'package:eyeson/app/routes/app_routes.dart';
import 'package:eyeson/app/themes/apptheme.dart';
import 'package:eyeson/app/widgets/favouritesCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.lightblackColor,
        iconTheme: IconThemeData(color: AppTheme.whiteColor),
        title: Text(
          "Favorites",
          style: TextStyle(
            color: AppTheme.whiteColor,
            fontSize: size.width * 0.05,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutesPath.VENUEDETAILS);
            },
            child: Icon(Icons.add, size: size.width * 0.065),
          ),
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: AppTheme.whiteColor,
        child: Column(
          children: [
            // Category Tabs
            Container(
              width: size.width,
              height: size.height * 0.1,
              color: AppTheme.lightblackColor,
              child: Row(
                children: [
                  _buildTab("Performers", 0, _selectedTabIndex, size),
                  _buildTab("Teams", 1, _selectedTabIndex, size),
                  _buildTab("Venues", 2, _selectedTabIndex, size),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                children: [
                  _buildFavouritesList(size),
                  _buildFavouritesList(size),
                  _buildFavouritesList(size),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index, int selectedTabIndex, Size size) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.whiteColor,
                  fontSize: size.width * 0.045,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 2,
                width: size.width * 0.2,
                color:
                    selectedTabIndex == index
                        ? Colors.white
                        : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavouritesList(Size size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "On Tour Near",
                  style: TextStyle(
                    color: AppTheme.blackColor,
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " Los Angeles ",
                  style: TextStyle(
                    color: AppTheme.blackColor,
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "(75 Miles)",
                  style: TextStyle(
                    color: AppTheme.blackColor,
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          FavouritesCard(
            cardImage: "assets/favourite1.webp",
            size: size,
            name: "Khalid",
            subName: "2 Events",
            title: "Khalid Free Spirit World Tour",
            subTile:
                "Los Angeles, CA -- Staples Center hosted a sold-out event featuring top performers and a vibrant crowd.",
            month_date: "JUL 25",
            day_time: "THU - 7:30 PM",
          ),
          FavouritesCard(
            cardImage: "assets/favourite2.jpg",
            size: size,
            name: "Hamilton",
            subName: "30 Events",
            title: "Hamilton",
            subTile:
                "Hamilton, CA -- Pantages Theatre lit up the night with a spectacular performance that drew in theater lovers from across the region.",
            month_date: "JUL 27",
            day_time: "THU - 7:30 PM",
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "On The Outside Your Area",
                  style: TextStyle(
                    color: AppTheme.blackColor,
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          FavouritesCard(
            cardImage: "assets/favourite1.webp",
            size: size,
            name: "Khalid",
            subName: "2 Events",
            title: "Khalid Free Spirit World Tour",
            subTile:
                "Los Angeles, CA -- Staples Center hosted a sold-out event featuring top performers and a vibrant crowd.",
            month_date: "JUL 25",
            day_time: "THU - 7:30 PM",
          ),
          FavouritesCard(
            cardImage: "assets/favourite2.jpg",
            size: size,
            name: "Hamilton",
            subName: "30 Events",
            title: "Hamilton",
            subTile:
                "Hamilton, CA -- Pantages Theatre lit up the night with a spectacular performance that drew in theater lovers from across the region.",
            month_date: "JUL 27",
            day_time: "THU - 7:30 PM",
          ),
        ],
      ),
    );
  }
}
