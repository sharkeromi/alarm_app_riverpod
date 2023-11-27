import 'package:alarm/alarm.dart';
import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:alarm_app_riverpod/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ExampleAlarmRingScreen extends StatelessWidget {
  final AlarmSettings? alarmSettings;

  const ExampleAlarmRingScreen({Key? key, this.alarmSettings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {
                    Alarm.stop(alarmSettings!.id).then((_) => Navigator.pop(context));
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
