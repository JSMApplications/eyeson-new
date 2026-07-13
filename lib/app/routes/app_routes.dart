import 'package:eyeson/app/views/Home.dart';
import 'package:eyeson/app/views/airPortSecurity.dart';
import 'package:eyeson/app/views/favourites.dart';
import 'package:eyeson/app/views/mexicanRestaurantDetails.dart';
import 'package:eyeson/app/views/mexicanRetaurent.dart';
import 'package:eyeson/app/views/onBoarding.dart';
import 'package:eyeson/app/views/scanCamera.dart';
import 'package:eyeson/app/views/splashscreen.dart';
import 'package:eyeson/app/views/text_detection_view.dart';
import 'package:eyeson/app/views/venueDetails.dart';
import 'package:get/get.dart';
part 'app_routes_path.dart';

class AppRoutes {
  static List<GetPage> pages = [
    GetPage(name: AppRoutesPath.SPLASH, page: () => Splashscreen()),
    GetPage(name: AppRoutesPath.ONBOARDING, page: () => OnBoarding()),
    GetPage(name: AppRoutesPath.HOME, page: () => Home()),
    GetPage(name: AppRoutesPath.FAVOURITES, page: () => Favourites()),
    GetPage(name: AppRoutesPath.VENUEDETAILS, page: () => VenueDetails()),
    GetPage(
        name: AppRoutesPath.MEXICANRESTAURENT, page: () => MexicanRetaurent()),
    GetPage(
        name: AppRoutesPath.MEXICANRESTAURENTDETAILS,
        page: () => MexicanRestaurantDetails(
              id: "",
              resData: {},
            )),
    GetPage(name: AppRoutesPath.AIRPORTSECURITY, page: () => AirPortSecurity()),
    GetPage(name: AppRoutesPath.SCANCAMERA, page: () => ScanCamera()),
    GetPage(
        name: AppRoutesPath.TEXT_DETECTION, page: () => TextDetectionView()),
  ];
}
