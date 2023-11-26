import 'package:alarm_app_riverpod/views/homePage.dart';
import 'package:alarm_app_riverpod/views/set_alarm_page.dart';
import 'package:alarm_app_riverpod/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const krSplashScreen = '/';
const krHomePage = '/home';
const krSetAlarm = '/set-alarm';

final routes = [
  GoRoute(
  path: krSplashScreen,
  pageBuilder: (context, state) =>  MaterialPage(child: SplashScreen()),
 ),
 GoRoute(
  path: krHomePage,
  pageBuilder: (context, state) => const MaterialPage(child:  HomePage()),
 ),
 GoRoute(
  path: krSetAlarm,
  pageBuilder: (context, state) => MaterialPage(child: SetAlarm()),
 ),
];

final goRouter = GoRouter(
 routes: routes,
);