import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poc_custom_gallery/manager/auth_manager.dart';
import 'package:poc_custom_gallery/screens/sign_in_page.dart';

import '../app_helper/route.dart';

enum CameraMediaType { image, video, gallery }

enum SignInType { google, facebook, apple, skip }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.type, required this.object});

  final SignInType type;
  final Object? object;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SignInProvider signIn = SignInProvider();

  dynamic loginData;

  String userEmail = '';
  String userName = '';
  String userPhotoUrl = '';

  @override
  void initState() {
    setDrawerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: double.infinity,
              color: kAppBarThemeColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: ClipOval(
                      child: userPhotoUrl.isEmpty
                          ? null
                          : Image.network(
                              userPhotoUrl,
                              fit: BoxFit.scaleDown,
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                shape:
                    RoundedRectangleBorder(side: const BorderSide(width: 1), borderRadius: BorderRadius.circular(10)),
                tileColor: Colors.grey,
                leading: const Icon(Icons.person),
                title: Text((widget.type == SignInType.skip) ? "Login" : "Logout"),
                trailing: const Icon(Icons.chevron_right),
                onTap: (widget.type == SignInType.google)
                    ? signIn.googleSignOutOnPressed
                    : (widget.type == SignInType.facebook)
                        ? signIn.faceBookSignOutOnPressed
                        : () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Custom Gallery Home"),
        backgroundColor: kAppBarThemeColor,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            customHomeMaterialButton(
              title: 'Capture Image',
              image: 'assets/image/camera123.png',
              type: CameraMediaType.image,
            ),
            const SizedBox(
              height: 20,
            ),
            customHomeMaterialButton(
              title: 'Capture Video',
              image: 'assets/image/video-camera.png',
              type: CameraMediaType.video,
            ),
            const SizedBox(
              height: 20,
            ),
            customHomeMaterialButton(
              title: 'Display Gallery',
              image: 'assets/image/picture.png',
              type: CameraMediaType.gallery,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget customHomeMaterialButton({required String title, required String image, required CameraMediaType type}) {
    return MaterialButton(
      height: MediaQuery.of(context).size.height * 0.2,
      color: Colors.white,
      elevation: 10,
      onPressed: () {
        if (type == CameraMediaType.image) {
          Navigator.pushNamed(
            context,
            Routes.cameraServicePage,
            arguments: {"type": type},
          );
        } else if (type == CameraMediaType.video) {
          Navigator.pushNamed(
            context,
            Routes.cameraServicePage,
            arguments: {"type": type},
          );
        } else {
          Navigator.pushNamed(context, Routes.customMediaManager, arguments: {"": ""});
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: (type == CameraMediaType.image) ? const Color(0xff0cb0ff) : const Color(0xff1565c0),
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              image,
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  void setDrawerData() {
    if (widget.type == SignInType.google) {
      loginData = widget.object as User?;
      userEmail = loginData!.email!;
      userName = loginData!.displayName!;
      userPhotoUrl = loginData!.photoURL!;
    } else if (widget.type == SignInType.facebook) {
      loginData = widget.object;
      userEmail = loginData['email'].toString();
      userName = loginData['name'].toString();
      userPhotoUrl = loginData['picture']['data']['url'].toString();
    } else {
      loginData = widget.object;
      userEmail = loginData['email'].toString();
      userName = loginData['name'].toString();
      userPhotoUrl = loginData['url'].toString();
    }
  }
}
// Color(0xff1565c0)
