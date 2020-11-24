import 'dart:async';

import 'package:BlogApp/screens/authentication_screen/auth_screen.dart';
import 'package:BlogApp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          PageTransition(
              child: HomeScreen(),
              type: PageTransitionType.rightToLeftWithFade),
        );
      } else {
        Navigator.pushReplacement(
          context,
          PageTransition(
              child: Authentication(),
              type: PageTransitionType.rightToLeftWithFade),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: _isPortrait ? 300.0 : 200.0,
                width: _isPortrait ? 400.0 : 300.0,
                child: Lottie.asset('animation/person-on-laptop.json'),
              ),
              RichText(
                text: TextSpan(
                  text: 'Blog',
                  style: TextStyle(
                    fontSize: 56.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  children: [
                    TextSpan(
                      text: 'osphere',
                      style: TextStyle(
                        fontSize: 56.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
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
