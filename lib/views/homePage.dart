import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:alarm_app_riverpod/const/routes.dart';
import 'package:alarm_app_riverpod/controllers/sp_controller.dart';
import 'package:alarm_app_riverpod/providers.dart';
import 'package:alarm_app_riverpod/views/clock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends ConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.watch(homeChangeNotifierProvider);
    final setAlarmNotifier = ref.watch(setAlarmChangeNotifierProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: () {
            // setAlarmNotifier.tempReset();
            setAlarmNotifier.isEditModeOn = false;
            ref.read(setAlarmNotifier.pickedTimeProvider.notifier).state = DateTime.now();
            setAlarmNotifier.selectedRepeatType = 'Daily';
            goRouter.push(krSetAlarm);
          },
          backgroundColor: cPrimaryColor,
          child: const Icon(
            Icons.add,
            color: cWhiteColor,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.background,
      //   elevation: 0,
      //   title: Padding(
      //     padding: const EdgeInsets.only(left: 6.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         const Text(
      //           'Alarms',
      //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cPrimaryTintColor),
      //         ),
      //         kH8sizedBox,
      //         if (setAlarmNotifier.alarmList.isNotEmpty && setAlarmNotifier.getNextAlarmETA() != null)
      //           Text(
      //             setAlarmNotifier.getNextAlarmETA() ?? '',
      //             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: cPrimaryTintColor),
      //           )
      //       ],
      //     ),
      //   ),
      // ),
      body: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: <Color>[cTransparentColor, cWhiteColor],
            stops: [0.0, 0.5],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: SizedBox(
          height: height,
          width: width,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClockView(),
                // if (setAlarmNotifier.alarmList.isNotEmpty)
                //   const Text(
                //     'Alarms',
                //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cPrimaryTintColor),
                //   ),
                // kH8sizedBox,
                if (setAlarmNotifier.alarmList.isNotEmpty && setAlarmNotifier.getNextAlarmETA() != null)
                  Text(
                    setAlarmNotifier.getNextAlarmETA() ?? '',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: cPrimaryTintColor),
                  ),
                if (setAlarmNotifier.alarmList.isNotEmpty)
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: setAlarmNotifier.alarmList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final switchState = ref.watch(setAlarmNotifier.switchProvider(index));
                        var item = setAlarmNotifier.alarmList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0, right: 20, left: 20),
                          child: InkWell(
                            splashColor: cPrimaryColor,
                            onTap: () {
                              setAlarmNotifier.isEditModeOn = true;
                              ref.read(setAlarmNotifier.pickedTimeProvider.notifier).state = DateTime.parse(item['dateTime']);
                              setAlarmNotifier.selectedRepeatType = item['repeat'];
                              ref.read(setAlarmNotifier.isVibrationOn.notifier).state = item['vibration'];
                              setAlarmNotifier.selectedId = index;
                              // setAlarmNotifier.ringtone = item[index]['ringtone'] == 'assets/marimba.mp3'? 'Default': item[index]['ringtone'];
                              goRouter.push(krSetAlarm);
                            },
                            child: Slidable(
                              endActionPane: ActionPane(
                                extentRatio: 0.2,
                                motion: const ScrollMotion(),
                                children: [
                                  Builder(
                                    builder: (cont) {
                                      return ElevatedButton(
                                        onPressed: () async {
                                          log(index.toString());
                                          // return;
                                          Slidable.of(cont)!.close();
                                          Alarm.stop(item['id']);
                                          setAlarmNotifier.alarmList.removeAt(index);
                                          await SpController().deleteAlarm(index);
                                          setAlarmNotifier.update();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          backgroundColor: Colors.red,
                                          padding: const EdgeInsets.all(10),
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                      );
                                    },
                                  ),
                                  // SlidableAction(
                                  //   // An action can be bigger than the others.
                                  //   onPressed: (context) {},
                                  //   backgroundColor: Color(0xFF7BC043),
                                  //   foregroundColor: Colors.white,
                                  //   icon: Icons.archive,
                                  //   label: 'Archive',
                                  // ),
                                ],
                              ),
                              child: Container(
                                width: width - 20,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    color: cPrimaryTintColor,
                                    boxShadow: [BoxShadow(color: cTextPrimaryColor.withOpacity(.2), blurRadius: 10, offset: Offset(0, 5))]),
                                child: Padding(
                                  padding: const EdgeInsets.all(22.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item['time'],
                                            style: TextStyle(color: item['isAlarmOn'] ? cWhiteColor : cDisabledTextColor, fontSize: 28),
                                          ),
                                          Transform.scale(
                                            scale: .7,
                                            child: CupertinoSwitch(
                                              activeColor: cPinkColor,
                                              thumbColor: cWhiteColor,
                                              trackColor: cPrimaryColor,
                                              value: item['isAlarmOn'],
                                              onChanged: (v) async {
                                                ref.read(setAlarmNotifier.switchProvider(index).notifier).state = v;

                                                if (!ref.read(setAlarmNotifier.switchProvider(index).notifier).state == true) {
                                                  Alarm.stop(item['id']);
                                                  item['isAlarmOn'] = false;
                                                } else {
                                                  item['isAlarmOn'] = true;
                                                  final alarmSettings = AlarmSettings(
                                                    id: item['id'],
                                                    dateTime: setAlarmNotifier.setAlarmTimeAgain(item['dateTime']),
                                                    assetAudioPath: 'assets/marimba.mp3',
                                                    loopAudio: true,
                                                    vibrate: item['vibration'],
                                                    volumeMax: true,
                                                    fadeDuration: 3.0,
                                                    notificationTitle: 'This is the title',
                                                    notificationBody: 'This is the body',
                                                    enableNotificationOnKill: true,
                                                  );
                                                  Alarm.set(alarmSettings: alarmSettings);
                                                }
                                                await SpController().deleteAllData();
                                                for (int i = 0; i < setAlarmNotifier.alarmList.length; i++) {
                                                  await SpController().saveAlarmList(setAlarmNotifier.alarmList[i]);
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      kH16sizedBox,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item['repeat'],
                                            style: TextStyle(color: item['isAlarmOn'] ? cWhiteColor : cDisabledTextColor, fontSize: 16),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                kH40sizedBox,
                kH40sizedBox,
                kH40sizedBox,
                kH40sizedBox,
                kH20sizedBox,
                kH10sizedBox
              ],
            ),
          ),
        ),
      ),
    );
  }
}
