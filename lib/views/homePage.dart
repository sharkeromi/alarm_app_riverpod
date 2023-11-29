import 'dart:developer';
import 'package:alarm/alarm.dart';
import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:alarm_app_riverpod/const/routes.dart';
import 'package:alarm_app_riverpod/controllers/sp_controller.dart';
import 'package:alarm_app_riverpod/providers.dart';
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
            goRouter.push(krSetAlarm);
          },
          backgroundColor: cPasteColor,
          child: const Icon(
            Icons.add,
            color: cWhiteColor,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 6.0),
          child: Text(
            'Alarms',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cPrimaryTintColor),
          ),
        ),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (setAlarmNotifier.alarmList.isNotEmpty)
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: setAlarmNotifier.alarmList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final switchState = ref.watch(setAlarmNotifier.switchProvider(index));
                        var item = setAlarmNotifier.alarmList;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            splashColor: cPrimaryColor,
                            onTap: () {},
                            child: Slidable(
                              endActionPane: ActionPane(
                                extentRatio: 0.2,
                                motion: const ScrollMotion(),
                                children: [
                                  Builder(
                                    builder: (cont) {
                                      return ElevatedButton(
                                        onPressed: () async {
                                          Slidable.of(cont)!.close();
                                          Alarm.stop(item[index]['id']);
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
                                            item[index]['time'],
                                            style: TextStyle(color: item[index]['isAlarmOn'] ? cWhiteColor : cDisabledTextColor, fontSize: 28),
                                          ),
                                          Transform.scale(
                                            scale: .7,
                                            child: CupertinoSwitch(
                                              activeColor: cPinkColor,
                                              thumbColor: cWhiteColor,
                                              trackColor: cPrimaryColor,
                                              value: item[index]['isAlarmOn'],
                                              onChanged: (v) {
                                                ref.read(setAlarmNotifier.switchProvider(index).notifier).state = v;

                                                if (!ref.read(setAlarmNotifier.switchProvider(index).notifier).state == true) {
                                                  Alarm.stop(item[index]['id']);
                                                  item[index]['isAlarmOn'] = false;
                                                } else {
                                                  item[index]['isAlarmOn'] = true;
                                                  final alarmSettings = AlarmSettings(
                                                    id: item[index]['id'],
                                                    dateTime: setAlarmNotifier.setAlarmTimeAgain(item[index]['dateTime']),
                                                    assetAudioPath: 'assets/marimba.mp3',
                                                    loopAudio: true,
                                                    vibrate: item[index]['vibration'],
                                                    volumeMax: true,
                                                    fadeDuration: 3.0,
                                                    notificationTitle: 'This is the title',
                                                    notificationBody: 'This is the body',
                                                    enableNotificationOnKill: true,
                                                  );
                                                  Alarm.set(alarmSettings: alarmSettings);
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
                                            item[index]['repeat'],
                                            style: TextStyle(color: item[index]['isAlarmOn'] ? cWhiteColor : cDisabledTextColor, fontSize: 16),
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
