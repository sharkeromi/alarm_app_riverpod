import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:alarm_app_riverpod/controllers/sp_controller.dart';
import 'package:alarm_app_riverpod/providers.dart';
import 'package:alarm_app_riverpod/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExampleAlarmRingScreen extends ConsumerWidget {
  final AlarmSettings? alarmSettings;

  const ExampleAlarmRingScreen({Key? key, this.alarmSettings}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setAlarmNotifier = ref.watch(setAlarmChangeNotifierProvider);
    return Scaffold(
      backgroundColor: cPrimaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Wake up",
              style: TextStyle(color: cWhiteColor, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text("🔔", style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomElevatedButton(
                  isCircularHead: true,
                  buttonWidth: (width / 2) - 50,
                  buttonColor: cPrimaryTintColor,
                  onPressed: () {
                    final now = DateTime.now();
                    Alarm.set(
                      alarmSettings: alarmSettings!.copyWith(
                        dateTime: DateTime(
                          now.year,
                          now.month,
                          now.day,
                          now.hour,
                          now.minute,
                          0,
                          0,
                        ).add(const Duration(minutes: 1)),
                      ),
                    ).then((_) => Navigator.pop(context));
                  },
                  label: "Snooze",
                  textStyle: const TextStyle(color: cBlueAccent, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                CustomElevatedButton(
                  isCircularHead: true,
                  buttonWidth: (width / 2) - 50,
                  buttonColor: cPrimaryTintColor,
                  onPressed: () async {
                    for (int i = 0; i < setAlarmNotifier.alarmList.length; i++) {
                      if (setAlarmNotifier.alarmList[i]['id'] == alarmSettings!.id) {
                        if (setAlarmNotifier.alarmList[i]['repeat'] == 'Once') {
                          Alarm.stop(alarmSettings!.id).then((_) => Navigator.pop(context));
                          setAlarmNotifier.alarmList[i]['isAlarmOn'] = false;
                        } else if (setAlarmNotifier.alarmList[i]['repeat'] == 'Daily') {
                          Alarm.stop(alarmSettings!.id).then((_) => Navigator.pop(context));
                          setAlarmNotifier.alarmList[i]['isAlarmOn'] = true;
                          DateTime selectedDateTime = DateTime.parse(setAlarmNotifier.alarmList[i]['dateTime']);
                          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
                          log(selectedDateTime.toString());
                          setAlarmNotifier.alarmList[i]['dateTime'] = selectedDateTime.toString();
                          final newAlarmSettings = AlarmSettings(
                            id: setAlarmNotifier.alarmList[i]['id'],
                            dateTime: selectedDateTime,
                            assetAudioPath: setAlarmNotifier.alarmList[i]['ringtone'],
                            loopAudio: true,
                            vibrate: setAlarmNotifier.alarmList[i]['vibration'],
                            volumeMax: true,
                            fadeDuration: 3.0,
                            notificationTitle: 'This is the title',
                            notificationBody: 'This is the body',
                            enableNotificationOnKill: true,
                          );
                          Alarm.set(alarmSettings: newAlarmSettings);
                          await SpController().deleteAllData();
                          for (int i = 0; i < setAlarmNotifier.alarmList.length; i++) {
                            await SpController().saveAlarmList(setAlarmNotifier.alarmList[i]);
                          }
                          setAlarmNotifier.alarmList.clear();
                          setAlarmNotifier.alarmList = await SpController().getAlarmList();
                        } else if (setAlarmNotifier.alarmList[i]['repeat'] == 'Custom') {
                          Alarm.stop(alarmSettings!.id).then((_) => Navigator.pop(context));
                          setAlarmNotifier.alarmList[i]['isAlarmOn'] = true;
                          int closestDay = 8;
                          for (int j = 0; j < setAlarmNotifier.alarmList[i]['customDays'].length; j++) {
                            if (closestDay > setAlarmNotifier.getDayOfWeek(setAlarmNotifier.alarmList[i]['customDays'][j])) {
                              closestDay = setAlarmNotifier.getDayOfWeek(setAlarmNotifier.alarmList[i]['customDays'][j]);
                            }
                          }
                          DateTime selectedDateTime = DateTime.parse(setAlarmNotifier.alarmList[i]['dateTime']);
                          selectedDateTime = selectedDateTime.add(Duration(days: closestDay));
                          log('nextAlarmTIme: $selectedDateTime');
                          setAlarmNotifier.alarmList[i]['dateTime'] = selectedDateTime.toString();
                          final newAlarmSettings = AlarmSettings(
                            id: setAlarmNotifier.alarmList[i]['id'],
                            dateTime: selectedDateTime,
                            assetAudioPath: setAlarmNotifier.alarmList[i]['ringtone'],
                            loopAudio: true,
                            vibrate: setAlarmNotifier.alarmList[i]['vibration'],
                            volumeMax: true,
                            fadeDuration: 3.0,
                            notificationTitle: 'This is the title',
                            notificationBody: 'This is the body',
                            enableNotificationOnKill: true,
                          );
                          Alarm.set(alarmSettings: newAlarmSettings);
                        }
                      }
                    }
                    // Alarm.stop(alarmSettings!.id).then((_) => Navigator.pop(context));
                  },
                  textStyle: const TextStyle(color: cBlueAccent, fontSize: 20, fontWeight: FontWeight.bold),
                  label: "Stop",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
