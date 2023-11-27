import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:alarm_app_riverpod/const/routes.dart';
import 'package:alarm_app_riverpod/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.watch(homeChangeNotifierProvider);
    final setAlarmNotifier = ref.watch(setAlarmChangeNotifierProvider);
    return Scaffold(
      backgroundColor: cPrimaryColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: () {
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
      body: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kH40sizedBox,
              const Text(
                'Alarms',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cBlueAccent),
              ),
              // kH20sizedBox,
              Expanded(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: setAlarmNotifier.alarmList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var item = setAlarmNotifier.alarmList;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          // height: 100,
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
                                      style: TextStyle(color: cBlueAccent, fontSize: 28),
                                    ),
                                    Transform.scale(
                                      scale: .7,
                                      child: CupertinoSwitch(
                                        activeColor: cPrimaryColor,
                                        thumbColor: cPrimaryTintColor,
                                        value: true,
                                        onChanged: (v) {},
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
                                      style: TextStyle(color: cBlueAccent, fontSize: 16),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
