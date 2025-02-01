import 'package:flutter/material.dart';

const Color kThemeColor = Color.fromRGBO(143, 148, 251, 1);

class OtpLoginScreen extends StatefulWidget {
  const OtpLoginScreen({Key? key}) : super(key: key);

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kThemeColor.withOpacity(0.3),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            end: Alignment.topCenter,
            begin: Alignment.bottomCenter,
            colors: [
              kThemeColor.withOpacity(0.6),
              kThemeColor.withOpacity(0.1),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 250,
                decoration: const BoxDecoration(
                    // image: DecorationImage(
                    //   image: AssetImage('assets/images/background.png'),
                    //   fit: BoxFit.fill
                    // ),
                    ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-1.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: Container(
                        decoration:
                            const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/light-2.png'))),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: Container(
                        decoration:
                            const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/clock.png'))),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        // color: Colors.blue,
                        margin: const EdgeInsets.only(top: 120),
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          child: Form(
                            key: globalKey,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromRGBO(143, 148, 251, .2),
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Theme(
                                data: ThemeData.light().copyWith(
                                  inputDecorationTheme: InputDecorationTheme(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                  ),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 60,
                                      padding: const EdgeInsets.only(left: 8, right: 8),
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
                                      child: TextFormField(
                                        onChanged: (value) {},
                                        keyboardType: TextInputType.emailAddress,
                                        cursorColor: const Color.fromRGBO(143, 148, 251, 1),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Enter Mobile Number",
                                            hintStyle: TextStyle(color: Colors.grey[400])),
                                      ),
                                    ),
                                    // Container(
                                    //   height: 60,
                                    //   padding: EdgeInsets.only(left: 8, right: 8),
                                    //   child: TextFormField(
                                    //     onEditingComplete: () {},
                                    //     onChanged: (value) {},
                                    //     cursorColor: kThemeColor,
                                    //     decoration: InputDecoration(
                                    //       border: InputBorder.none,
                                    //       suffix: IconButton(
                                    //         onPressed: () {},
                                    //         icon: const Icon(CupertinoIcons.eye_fill),
                                    //       ),
                                    //       hintText: "Enter User Name",
                                    //       hintStyle: TextStyle(
                                    //         color: Colors.grey[400],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeDashBoardScreen()));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: RadialGradient(
                            colors: [
                              kThemeColor,
                              kThemeColor.withOpacity(0.6),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FadeAnimation extends StatelessWidget {
  const FadeAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
