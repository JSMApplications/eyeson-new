import 'package:eyeson/app/themes/apptheme.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String? imagePath;
  final String? title;
  final String? description;
  final String? rating;
  final String? price;
  final Function()? onTap;
  const ProductCard({
    this.imagePath,
    this.title,
    this.description,
    this.rating,
    this.price,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        color: AppTheme.whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  '$imagePath',
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              // Name
              Text(
                '$title',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Description
              Text(
                '$description',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              // Rating
              Row(
                children: [
                  Icon(Icons.star, size: 16, color: AppTheme.starColor),
                  Text(
                    "$rating",
                    style: TextStyle(color: AppTheme.FontColor, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Price
              Text(
                '\$$price',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.FontColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
