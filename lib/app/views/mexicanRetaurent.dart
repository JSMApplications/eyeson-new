import 'package:eyeson/app/routes/app_routes.dart';
import 'package:eyeson/app/themes/apptheme.dart';
import 'package:eyeson/app/widgets/foodCategory.dart';
import 'package:eyeson/app/widgets/productCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MexicanRetaurent extends StatelessWidget {
  const MexicanRetaurent({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.whiteColor,
        iconTheme: IconThemeData(color: AppTheme.IconColor),
        title: Text(
          "Maxican Restaurent",
          style: TextStyle(
            color: AppTheme.FontColor,
            fontSize: size.width * 0.045,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Bottom Sheet For Review
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: AppTheme.whiteColor,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "How would you rate the quality\nof this scan and information?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.FontColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.green,
                          size: 36,
                        ),
                        Icon(
                          Icons.sentiment_satisfied,
                          color: Colors.lightGreen,
                          size: 36,
                        ),
                        Icon(
                          Icons.sentiment_neutral,
                          color: Colors.amber,
                          size: 36,
                        ),
                        Icon(
                          Icons.sentiment_dissatisfied,
                          color: Colors.orange,
                          size: 36,
                        ),
                        Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: Colors.red,
                          size: 36,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Add a comment...",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: AppTheme.themeColor.withOpacity(0.05),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.themeColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Submit review logic here
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Submit Review",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: AppTheme.floatingButtonBgColor,
        shape: CircleBorder(),
        child: Stack(
          children: [
            Icon(Icons.shopping_cart_outlined, color: AppTheme.whiteColor),
            Positioned(
              top: -6,
              right: -4,
              child: Container(
                width: 20,
                height: 25,
                child: Text(
                  "4",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: AppTheme.whiteColor,
        child: Column(
          children: [
            // Food Type Category
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FoodCategory(name: "Dinner", size: size),
                    FoodCategory(name: "Lunch", size: size),
                    FoodCategory(name: "Pasta", size: size),
                    FoodCategory(name: "Dessert", size: size),
                    FoodCategory(name: "Dinner", size: size),
                    FoodCategory(name: "Lunch", size: size),
                    FoodCategory(name: "Pasta", size: size),
                    FoodCategory(name: "Dessert", size: size),
                    FoodCategory(name: "Dinner", size: size),
                    FoodCategory(name: "Lunch", size: size),
                    FoodCategory(name: "Pasta", size: size),
                    FoodCategory(name: "Dessert", size: size),
                  ],
                ),
              ),
            ),
            // Food Category
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FoodCategory(name: "Budget Meal", size: size),
                    FoodCategory(name: "Steak", size: size),
                    FoodCategory(name: "Burger", size: size),
                    FoodCategory(name: "Fast Foods", size: size),
                    FoodCategory(name: "Budget Meal", size: size),
                    FoodCategory(name: "Steak", size: size),
                    FoodCategory(name: "Burger", size: size),
                    FoodCategory(name: "Fast Foods", size: size),
                    FoodCategory(name: "Budget Meal", size: size),
                    FoodCategory(name: "Steak", size: size),
                    FoodCategory(name: "Burger", size: size),
                    FoodCategory(name: "Fast Foods", size: size),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: size.width,
                height: size.height * 0.6,
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      onTap: () {
                        // Handle tap
                        Get.toNamed(AppRoutesPath.MEXICANRESTAURENTDETAILS);
                        print("Product: $index");
                      },
                      imagePath:
                          "assets/mexicanProductImg1.jpg",
                      title: "Product Name $index",
                      description: "Short product description goes here.",
                      rating: "4.6",
                      price: "99.99",
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
