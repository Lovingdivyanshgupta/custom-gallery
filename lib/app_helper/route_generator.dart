import 'package:flutter/cupertino.dart';
import 'package:poc_custom_gallery/app_helper/route.dart';
import 'package:poc_custom_gallery/manager/custom_media_manager.dart';
import 'package:poc_custom_gallery/screens/camera_service_page.dart';
import 'package:poc_custom_gallery/screens/home_page.dart';
import 'package:poc_custom_gallery/screens/image_preview.dart';
import 'package:poc_custom_gallery/screens/profile_page.dart';
import 'package:poc_custom_gallery/screens/sign_in_page.dart';
import 'package:poc_custom_gallery/screens/video_preview.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>;

    switch (settings.name) {
      case Routes.cameraServicePage:
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
              CameraServicePage(type: args["type"]  as CameraMediaType),
        );
      case Routes.myHomePage:
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
              MyHomePage(type: args["type"] as SignInType, object: args["object"]),
        );
      case Routes.socialSignInScreen:
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
              const SocialSignInScreen(),
        );
      case Routes.userProfileScreen:
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
              const UserProfileScreen(),
        );
      case Routes.videoPreview:
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
              VideoPreview(path: args["path"] as String),
        );
      case Routes.imagePreview:
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
              ImagePreview(path: args["path"] as String),
        );
      case Routes.customMediaManager:
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
              const CustomMediaManager(),
        );
      default:
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
              const SocialSignInScreen(),
        );
    }
  }
}
