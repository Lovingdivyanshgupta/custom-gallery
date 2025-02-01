import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

import '../app_helper/route.dart';
import '../manager/auth_manager.dart';
import 'home_page.dart';

const kAppBarThemeColor = Color(0xFFe71b73);
final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

class SocialSignInScreen extends StatefulWidget {
  const SocialSignInScreen({Key? key}) : super(key: key);

  static const String id = "/SocialSignInScreen";

  @override
  State<SocialSignInScreen> createState() => _SocialSignInScreenState();
}

class _SocialSignInScreenState extends State<SocialSignInScreen> {
  SignInProvider signInProvider = SignInProvider();

  var adUnitId = "ca-app-pub-1041458321270655/7111999688";
  var adUnitId2 = "ca-app-pub-1041458321270655/9920305477";
  BannerAd? _bannerAd;
  InterstitialAd? _bannerAd2;
  @override
  void initState() {
    super.initState();
    _loadAd();
    _loadAd2();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        backgroundColor: kAppBarThemeColor,
        elevation: 10,
        centerTitle: true,
        title: const Text("Firebase Social Integration"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: _bannerAd ==null ? const SizedBox(): AdWidget(ad: _bannerAd!),
          ),
          const Divider(),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width,
          //   height: 100,
          //   child: _bannerAd2 ==null ? const SizedBox(): Adw(ad: _bannerAd2!),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RawMaterialButton(
                  onPressed: signInProvider.signInWithGoogleOnPressed,
                  child: Card(
                    elevation: 5,
                    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/json/google.json", width: 30, height: 30),
                        const Text(" Sign in with Google"),
                      ],
                    ),
                  ),
                ),
                RawMaterialButton(
                  onPressed: signInProvider.signInFaceBook,
                  child: Card(
                    elevation: 5,
                    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/json/facebook-icon.json", width: 30, height: 30),
                        const Text(" Sign in with Facebook"),
                      ],
                    ),
                  ),
                ),
                RawMaterialButton(
                  onPressed: ()=>signInProvider.signInPhone(context),
                  child: Card(
                    elevation: 5,
                    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lottie.asset("assets/json/facebook-icon.json", width: 30, height: 30),
                        Icon(Icons.phone,),
                        Text(" Sign in with Phone"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),
                RawMaterialButton(
                  onPressed: () {
                    _showAd();
                  },
                  child: Card(
                      elevation: 5,
                      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Skip",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd2?.dispose();
    super.dispose();
  }
  /// Loads a banner ad.
  void _loadAd() {
    final bannerAd = BannerAd(
      size: const AdSize(width: 300, height: 100),
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    bannerAd.load();
  }

  void _loadAd2() async {
     await InterstitialAd.load(
      adUnitId: adUnitId2,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd2 = ad;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: $error');
          // ad.dispose();
        },
      ),
    );

    // Start loading.
    // bannerAd.load();
  }


  void _showAd() {
    if ( _bannerAd2 != null) {
      _bannerAd2!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) async {
          ad.dispose();
          setState(() {
            _bannerAd2 = null;
          });
          _loadAd2();  // Load a new ad after the current one is shown
          await Navigator.pushNamed(
            context,
            Routes.myHomePage,
            arguments: {
              "type": SignInType.skip,
              "object": {"email": "Guest@gmail.com", "name": "Login Now", "url": ""}
            },
          );
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          setState(() {
            _bannerAd2 = null;
          });
          debugPrint('InterstitialAd failed to show: $error');
        },
      );
      _bannerAd2!.show();
    } else {
      debugPrint('Ad is not loaded yet');
    }
  }
}
