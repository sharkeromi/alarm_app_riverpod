import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetAlarmNotifier extends ChangeNotifier {

 List repeatType = ['Once', 'Daily', 'Sat to Wed', 'Custom'];

  final pickedTimeProvider = StateProvider<DateTime>(
    (ref) {
      return DateTime.now();
    },
  );
  
  final tempSelectedRepeatType= StateProvider<String>(
    (ref) {
      return '';
    },
  );


  String getDifference(DateTime setAlarm) {
    if (setAlarm.isBefore(DateTime.now())) {
      Duration duration = Duration(hours: 24) + setAlarm.difference(DateTime.now());
      return '${duration.inHours.abs()} hours ${duration.inMinutes.remainder(60).abs()} minutes';
    } else {
      Duration duration = DateTime.now().difference(setAlarm);
      return '${duration.inHours.abs()} hours ${duration.inMinutes.remainder(60).abs()} minutes';
    }
  }
}
