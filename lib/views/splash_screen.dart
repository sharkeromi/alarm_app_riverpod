

import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:alarm_app_riverpod/controllers/splash_screen_controller.dart';
import 'package:alarm_app_riverpod/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  SplashScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final setAlarmNotifier = ref.watch(setAlarmChangeNotifierProvider);
  final  controller = SplashScreenController(setAlarmNotifier);
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
