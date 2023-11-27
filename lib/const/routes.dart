import 'package:alarm/alarm.dart';
import 'package:alarm_app_riverpod/views/alarm_ring.dart';
import 'package:alarm_app_riverpod/views/homePage.dart';
import 'package:alarm_app_riverpod/views/set_alarm_page.dart';
import 'package:alarm_app_riverpod/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const krSplashScreen = '/';
const krHomePage = '/home';
const krSetAlarm = '/set-alarm';
const krAlarmRing = '/ring-alarm';

final routes = [
  GoRoute(
    path: krSplashScreen,
    pageBuilder: (context, state) => MaterialPage(child: SplashScreen()),
  ),
  GoRoute(
    path: krHomePage,
    pageBuilder: (context, state) => MaterialPage(child: HomePage()),
  ),
  GoRoute(
    path: krSetAlarm,
    pageBuilder: (context, state) => MaterialPage(child: SetAlarm()),
  ),
  GoRoute(
    path: krAlarmRing,
    pageBuilder: (context, state) {
      AlarmSettings alarmSettings = state.extra as AlarmSettings;
      return MaterialPage(child: ExampleAlarmRingScreen(alarmSettings: alarmSettings));},
  ),
];

final goRouter = GoRouter(
  routes: routes,
);
