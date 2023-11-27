import 'dart:async';
import 'dart:developer';
import 'package:alarm_app_riverpod/const/routes.dart';
import 'package:alarm_app_riverpod/controllers/sp_controller.dart';
import 'package:alarm_app_riverpod/notifiers/set_alarm.dart';
import 'package:flutter/material.dart';

class SplashScreenController extends ChangeNotifier {
  final SpController _spController = SpController();
   final SetAlarmNotifier setAlarmNotifier;
  SplashScreenController(this.setAlarmNotifier) {
    startSplashScreen();
  }

  Timer startSplashScreen() {
    var duration = const Duration(seconds: 5);
    return Timer(
      duration,
      () async {
        // setAlarmNotifier.alarmList.clear();
        setAlarmNotifier.alarmList = await _spController.getAlarmList();
        // log()
        log(setAlarmNotifier.alarmList.toString());
        goRouter.go(krHomePage);
      },
    );
  }
}
