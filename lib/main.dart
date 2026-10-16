import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:poc_custom_gallery/app_helper/route_generator.dart';
import 'package:poc_custom_gallery/screens/sign_in_page.dart';

List<CameraDescription> camera = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  await Firebase.initializeApp();
  camera = await availableCameras();
  print("camera main : $camera");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      home: const SocialSignInScreen(),
    );
  }
}



class BackgroundRemovalService {
  var _apiKey = "sAtDg6iGCywmyk9APDcHy4eL";
  static const String _endpoint =
      'https://api.remove.bg/v1.0/removebg';

  BackgroundRemovalService();

  Future<Uint8List> removeBackground(File imageFile) async {
    if (!await imageFile.exists()) {
      throw Exception('Selected image does not exist.');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(_endpoint),
    );

    request.headers['X-Api-Key'] = _apiKey;
    request.fields['size'] = 'auto';
    request.files.add(
      await http.MultipartFile.fromPath(
        'image_file',
        imageFile.path,
      ),
    );

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 90),
    );

    final response = await http.Response.fromStream(
      streamedResponse,
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    // The API may return a JSON or text error instead of an image.
    final details = response.body.length > 1000
        ? response.body.substring(0, 1000)
        : response.body;

    throw Exception(
      'Background removal failed '
          '(${response.statusCode}): $details',
    );
  }
}