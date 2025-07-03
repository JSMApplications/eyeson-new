import 'package:eyeson/app/themes/apptheme.dart';
import 'package:flutter/material.dart';

class FavouritesCard extends StatelessWidget {
  final String? cardImage;
  final size;
  final String? name;
  final String? subName;
  final String? title;
  final String? subTile;
  final String? month_date;
  final String? day_time;

  const FavouritesCard({
    this.cardImage,
    this.size,
    this.name,
    this.subName,
    this.title,
    this.subTile,
    this.month_date,
    this.day_time,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: size.width,
        height: size.height * 0.22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppTheme.greyColor,
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.greyColor,
                    style: BorderStyle.solid,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: size.width * 0.3,
                    height: size.height * 0.1,
                    child: Image.asset("$cardImage", fit: BoxFit.cover),
                  ),
                  Container(
                    width: size.width * 0.65,
                    height: size.height * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$name",
                                style: TextStyle(
                                  fontSize: size.width * 0.045,
                                  color: AppTheme.themeColor,
                                ),
                              ),
                              Text(
                                "$subName",
                                style: TextStyle(
                                  fontSize: size.width * 0.035,
                                  color: AppTheme.FontColor,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.favorite,
                            size: size.width * 0.08,
                            color: AppTheme.purpleColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.3,
                  height: size.height * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$month_date",
                          style: TextStyle(
                            color: AppTheme.purpleColor,
                            fontSize: size.width * 0.045,
                          ),
                        ),
                        Text(
                          "$day_time",
                          style: TextStyle(
                            color: AppTheme.FontColor,
                            fontSize: size.width * 0.03,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.65,
                  height: size.height * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$title",
                          style: TextStyle(
                            color: AppTheme.FontColor,
                            fontSize: size.width * 0.045,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "$subTile",
                          style: TextStyle(
                            color: AppTheme.greyColor,
                            fontSize: size.width * 0.03,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
