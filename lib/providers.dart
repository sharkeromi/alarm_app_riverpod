import 'package:alarm_app_riverpod/notifiers/set_alarm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final setAlarmChangeNotifierProvider = ChangeNotifierProvider<SetAlarmNotifier>((ref) {
   return SetAlarmNotifier();
 },);