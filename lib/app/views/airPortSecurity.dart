import 'package:carousel_slider/carousel_slider.dart';
import 'package:eyeson/app/themes/apptheme.dart';
import 'package:eyeson/app/widgets/actionButton.dart';
import 'package:flutter/material.dart';

class AirPortSecurity extends StatelessWidget {
  const AirPortSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: AppBar(
        backgroundColor: AppTheme.whiteColor,
        iconTheme: IconThemeData(color: AppTheme.IconColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Airport Security",
                    style: TextStyle(
                      color: AppTheme.FontColor,
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.bookmark_border,
                    size: size.width * 0.06,
                    color: AppTheme.IconColor,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Airport security refers to the techniques and methods used in an attempt to protect passengers, staff, aircraft, and airport property from accidental/ malicious",
                style: TextStyle(
                  color: AppTheme.FontColor,
                  fontSize: size.width * 0.03,
                ),
              ),
              SizedBox(height: 20),
              CarouselSlider(
                items: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/airPortImg1.jpeg",
                      fit: BoxFit.cover,
                      height: size.height * 0.2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/airPortImg2.webp",
                      fit: BoxFit.cover,
                      height: size.height * 0.2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/airPortImg3.jpg",
                      fit: BoxFit.cover,
                      height: size.height * 0.2,
                    ),
                  ),
                ],
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Description",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppTheme.FontColor,
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Large numbers of people pass through airports every day. This presents potential targets for terrorism and other forms of crime because of the number of people located in one place.[2] Similarly, the high concentration of people on large airliners increases the potentially high death rate with attacks on aircraft, and the ability to use a hijacked airplane as a lethal weapon may provide an alluring target for terrorism (such as during the September 11 attacks).[citation needed] \n\n\n Passport control at Dubai Airport Airport security attempts to prevent any threats or potentially dangerous situations from arising or entering the country. If airport security does succeed then the chances of any dangerous.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppTheme.FontColor,
                  fontSize: size.width * 0.035,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: size.height * 0.2,
        color: AppTheme.transparentColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Action Buttons
              ActionButton(
                icon: Icons.call,
                label: "Call",
                bgColor: Colors.green.shade100,
                size: size,
              ),
              SizedBox(width: 5,),
              ActionButton(
                icon: Icons.language,
                label: "Website",
                bgColor: Colors.brown.shade100,
                size: size,
              ),
              SizedBox(width: 5,),
              // Scan Button
              Expanded(
                child: Container(
                  height: size.height * 0.12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppTheme.themeColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.filter_center_focus_outlined,
                        color: AppTheme.whiteColor,
                        size: size.width * 0.06,
                      ),
                      Text(
                        "Scan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.whiteColor,
                          fontSize: size.width * 0.04,
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
  }
}
