import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm_app_riverpod/const/routes.dart';
import 'package:alarm_app_riverpod/controllers/sp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class SetAlarmNotifier extends ChangeNotifier {
  List repeatType = ['Once', 'Daily', 'Sat to Wed', 'Custom'];
  List weekDays = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  List<String> selectedDays = [];
  List<dynamic> alarmList = [];

  final pickedTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());
  String pickedTime = '';
  DateTime selectedDateTime = DateTime.now();
  final tempSelectedRepeatType = StateProvider<String>((ref) => '');
  // final selectedRepeatType = StateProvider<String>((ref) => '');
  String selectedRepeatType = '';
  final isVibrationOn = StateProvider<bool>((ref) => false);
  bool vibration = false;
  String ringtone = '';
  String ringtonePath = '';

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      File file = File(result.files.single.path!);
      // Do something with the file
      log(file.uri.toString());
      log(file.path.toString());
      ringtonePath = file.path.toString();
      var nameFilter = file.path.toString().split('file_picker/');
      ringtone = nameFilter.last;
      log(ringtone);
    } else {
      log('Failed');
      // User canceled the picker
    }
    notifyListeners();
  }

  void pickTime(time) {
    selectedDateTime = time;
    if (selectedDateTime.isBefore(DateTime.now())) {
      selectedDateTime = selectedDateTime.add(const Duration(days: 1));
    }
    pickedTime = DateFormat('HH:mm a').format(time);
    notifyListeners();
  }

  void setVibrationStatus(vibrationSwitch) {
    vibration = vibrationSwitch;
    notifyListeners();
  }

  void setRepeatStatus(status) {
    selectedRepeatType = status;
    notifyListeners();
  }

  void addDay(String day) {
    selectedDays.add(day);
    notifyListeners();
  }

  void removeDay(String day) {
    selectedDays.remove(day);
    notifyListeners();
  }

  String getDifference(DateTime setAlarm) {
    if (setAlarm.isBefore(DateTime.now())) {
      Duration duration = const Duration(hours: 24) + setAlarm.difference(DateTime.now());
      return '${duration.inHours.abs()} hours ${duration.inMinutes.remainder(60).abs()} minutes';
    } else {
      Duration duration = DateTime.now().difference(setAlarm);
      return '${duration.inHours.abs()} hours ${duration.inMinutes.remainder(60).abs()} minutes';
    }
  }

  void saveAlarm() async {
    alarmList.clear();
    // await SpController().deleteAllData();
      Map<String, dynamic> alarmDetails = {
        "time": pickedTime,
        "dateTime": selectedDateTime.toString(),
        "repeat": selectedRepeatType,
        "vibration": vibration,
        "ringtone": ringtonePath
      };
      String encodedMap = json.encode(alarmDetails);
      await SpController().saveAlarmDetails(encodedMap);
      await SpController().saveAlarmList(alarmDetails);
      alarmList = await SpController().getAlarmList();
      log(alarmList.toString());
      goRouter.pop();
      final alarmSettings = AlarmSettings(
        id: alarmList.length - 1,
        dateTime: selectedDateTime,
        assetAudioPath: 'assets/marimba.mp3',
        loopAudio: true,
        vibrate: vibration,
        volumeMax: true,
        fadeDuration: 3.0,
        notificationTitle: 'This is the title',
        notificationBody: 'This is the body',
        enableNotificationOnKill: true,
      );
      Alarm.set(alarmSettings: alarmSettings);
  }
}
