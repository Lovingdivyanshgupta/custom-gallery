import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:poc_custom_gallery/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_helper/route.dart';
import '../screens/sign_in_page.dart';

class SignInProvider extends ChangeNotifier {
  bool? isUserSignIn;
  String? name;
  String? email;
  String? phone;
  User? currentUser;

  final FirebaseAuth authFirebase = FirebaseAuth.instance;
  final FacebookAuth authFacebook = FacebookAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> checkIfSignIn() async {
    SharedPreferences getSignIn = await SharedPreferences.getInstance();
    isUserSignIn = getSignIn.getBool('sign_in') ?? false;
    notifyListeners();
  }

  Future<void> signInWithGoogleOnPressed() async {
    try {
      GoogleSignInAccount? accountGoogle = await googleSignIn.signIn();
      if (accountGoogle != null) {
        //print("google sign data : ${accountGoogle.email}");
        //print("google sign data : ${accountGoogle.displayName}");
      }
      //print("google sign in : ${accountGoogle.toString()}");
      GoogleSignInAuthentication googleAuth = await accountGoogle!.authentication;
      AuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      UserCredential googleUserCredential = await authFirebase.signInWithCredential(googleAuthCredential);
      User? googleUser = googleUserCredential.user;
      currentUser = googleUser;

      Navigator.pushNamed(key.currentContext!, Routes.myHomePage,
          arguments: {"type": SignInType.google, "object": googleUser});
    } catch (e) {
      //print("google sign in error: ${e.toString()}");
    }
  }

  Future<void> signInFaceBook() async {
    try {
      LoginResult? loginFaceBook = await authFacebook.login();

      if (loginFaceBook.status == LoginStatus.success) {
        // print("loginFaceBook sign data : ${loginFaceBook.status}");
        // print("loginFaceBook sign data : ${loginFaceBook.accessToken}");
        // print("loginFaceBook sign data : ${loginFaceBook.accessToken?.token}");
        String url =
            "https://graph.facebook.com/${loginFaceBook.accessToken?.userId}?fields=id,name,email,picture&access_token=${loginFaceBook.accessToken?.token}";
        http.Response response = await http.get(Uri.parse(url));
        // print("response api status : ${response.statusCode}");
        // print("response api body : ${response.body}");

        OAuthCredential credential = FacebookAuthProvider.credential(loginFaceBook.accessToken!.token);
        authFirebase.signInWithCredential(credential);
        if (response.statusCode == 200) {
          var facebookData = json.decode(response.body);
          // print("data facebook : $facebookData");
          // print("data facebook : ${facebookData['id']}");

          Navigator.pushNamed(
            key.currentContext!,
            Routes.myHomePage,
            arguments: {"type": SignInType.facebook, "object": facebookData},
          );
        }
      }
      // print("google sign in : ${accountGoogle.toString()}");
    } catch (e) {
      // print("loginFaceBook sign in error: ${e.toString()}");
    }
  }

  Future<void> googleSignOutOnPressed() async {
    try {
      await googleSignIn.signOut();
      if (kDebugMode) {
        print("logout google ");
      }
      navigateToExitScreen();
      navigateToExitScreen();
    } catch (e) {
      // print("logout google in error: ${e.toString()}");
    }
  }

  Future<void> faceBookSignOutOnPressed() async {
    try {
      await authFacebook.logOut();
      // print("logoutFaceBook ");
      navigateToExitScreen();
      navigateToExitScreen();
    } catch (e) {
      // print("logoutFaceBook in error: ${e.toString()}");
    }
  }

  Future<void> signInPhone(BuildContext context) async {
    try {
      // print("signInPhone ");
      // String code ;
      // int? codeId ;
      await authFirebase.verifyPhoneNumber(   //  7694034029
        phoneNumber: "+91",
        timeout: const Duration(seconds: 60),
        forceResendingToken: 0,
        // autoRetrievedSmsCodeForTesting: "123456",
        multiFactorInfo: const PhoneMultiFactorInfo(
          displayName: 'vnbvnb',
          enrollmentTimestamp: 0.8,
          factorId: '',
          uid: '',
          phoneNumber: '+91',
        ),
        verificationCompleted: (_) {
          // print("verificationCompleted : ${_.verificationId} , code : ${_.smsCode} , token : ${_.accessToken}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("verificationCompleted : ${_.verificationId} , code : ${_.smsCode} , token : ${_.accessToken}")));
        },
        verificationFailed: (e) {
          // print("verificationFailed : ${e.credential?.accessToken}");
          // print("verificationFailed : ${e.credential?.providerId}");
          // print("verificationFailed : ${e.credential?.signInMethod}");
          // print("verificationFailed : ${e.credential?.token}");
          // print("verificationFailed : ${e.email}");
          // print("verificationFailed : ${e.phoneNumber}");
          // print("verificationFailed : ${e.code}");
          // print("verificationFailed : ${e.plugin}");
          // print("verificationFailed : ${e.tenantId}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("verificationFailed : ${e.message}")));
        },
        codeSent: (codeSent, i) {
          // print("codeSent : $codeSent , code : $i ");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("codeSent : $codeSent , code : $i ")));
          // code = codeSent;
          // codeId = i;
        },
        codeAutoRetrievalTimeout: (c) {
          // print("codeAutoRetrievalTimeout : $c ");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("codeAutoRetrievalTimeout : $c ")));
        },
      );
    } catch (e) {
      // print("loginFaceBook sign in error: ${e.toString()}");
    }
  }

  void navigateToExitScreen() => Navigator.pop(key.currentContext!);
}
