

import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:alarm_app_riverpod/controllers/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final SplashScreenController _controller = SplashScreenController();

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: splashScreenBackground,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        backgroundColor: cTransparentColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 56),
          child: Image.asset('assets/alarm.gif')
        ),
      ),
    );
  }
}
