import 'dart:developer';
import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:alarm_app_riverpod/const/routes.dart';

import 'package:alarm_app_riverpod/providers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setAlarmNotifier = ref.watch(setAlarmChangeNotifierProvider);

    log('hello: ${setAlarmNotifier.alarmList}');
    return Scaffold(
      backgroundColor: cPrimaryColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => SetAlarm(),
            //   ),
            // );
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cPrimaryTintColor),
              ),
              kH20sizedBox,
              ListView.builder(
                  // physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: setAlarmNotifier.alarmList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 70,
                      width: width - 20,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: cRedAccentColor),
                    );
                  }),
              Text('asdasd')
            ],
          ),
        ),
      ),
    );
  }
}
