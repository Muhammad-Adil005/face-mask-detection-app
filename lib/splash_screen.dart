import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      backgroundColor: Colors.blue,
      durationInSeconds: 8,
      navigator: HomePage(),
      title: const Text(
        'Face Mask Detection App',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      logo: Image.asset('assets/splash.png'),
      logoWidth: 130,
      showLoader: false,
    );
  }
}
