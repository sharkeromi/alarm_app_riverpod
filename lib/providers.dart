import 'package:alarm_app_riverpod/notifiers/set_alarm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final setAlarmChangeNotifierProvider = ChangeNotifierProvider<SetAlarmNotifier>((ref) {
   return SetAlarmNotifier();
 },);

 final splashScreenProvider = FutureProvider<void>((ref) async {
//  await Future.delayed(Duration(seconds: 3));
});
