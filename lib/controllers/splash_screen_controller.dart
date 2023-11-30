import 'dart:async';
import 'dart:developer';
import 'package:alarm/alarm.dart';
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
        setAlarmNotifier.alarmList.clear();
        setAlarmNotifier.alarmList = await _spController.getAlarmList();
        // log()
        log(setAlarmNotifier.alarmList.toString());
        repeatAlarmChecker(setAlarmNotifier.alarmList);
        goRouter.go(krHomePage);
      },
    );
  }

  void repeatAlarmChecker(alarmList) async {
    log(alarmList.length.toString());
    for (int i = 0; i < alarmList.length; i++) {
      final alarm = Alarm.getAlarm(alarmList[i]['id']);

      if (alarm != null) {
        log('Alarm is enabled');
      } else {
        log('Alarm is disabled');
        if (alarmList[i]['isAlarmOn']) {
          if (alarmList[i]['repeat'] == "Once") {
            alarmList[i]['isAlarmOn'] = false;
          } else if (alarmList[i]['repeat'] == "Daily") {
            alarmList[i]['isAlarmOn'] = true;
            DateTime selectedDateTime = DateTime.parse(alarmList[i]['dateTime']);
            if (selectedDateTime.isBefore(DateTime.now())) {
              selectedDateTime = selectedDateTime.add(const Duration(days: 1));
            }
            alarmList[i]['dateTime'] = selectedDateTime.toString();
          }
        }
      }
    }
    await _spController.deleteAllData();
    for (int i = 0; i < alarmList.length; i++) {
      await _spController.saveAlarmList(alarmList[i]);
    }
    setAlarmNotifier.alarmList.clear();
    setAlarmNotifier.alarmList = await _spController.getAlarmList();
    log(setAlarmNotifier.alarmList.toString());
  }
}
