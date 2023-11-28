import 'package:alarm/alarm.dart';
import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:alarm_app_riverpod/const/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(showDebugLogs: true);
  runApp(const ProviderScope(child: MyApp()));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    heightWidthKeyboardValue(context);
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: cPrimaryColor),
        // brightness: Brightness.light,
        useMaterial3: false,
      ),
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   /* dark theme settings */
      // ),
      // themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
    );
  }
}
