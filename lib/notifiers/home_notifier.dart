import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm_app_riverpod/const/routes.dart';
import 'package:flutter/material.dart';

class HomeNotifier extends ChangeNotifier {
  late List<AlarmSettings> alarms;
  static StreamSubscription<AlarmSettings>? subscription;
  HomeNotifier() {
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await goRouter.push(krAlarmRing, extra: alarmSettings);
    loadAlarms();
    notifyListeners();
  }

  void loadAlarms() {
    alarms = Alarm.getAlarms();
    alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    notifyListeners();
  }
}
