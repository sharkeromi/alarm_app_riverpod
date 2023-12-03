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
  bool isEditModeOn = false;

  final pickedTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());
  final switchProvider = StateProvider.family<bool, int>((ref, index) => true);
  String pickedTime = '';
  DateTime selectedDateTime = DateTime.now();
  final tempSelectedRepeatType = StateProvider<String>((ref) => '');
  int selectedId = -1;
  final selectedIndex = StateProvider<int>((ref) => -1);
  // final selectedRepeatType = StateProvider<String>((ref) => '');
  String selectedRepeatType = '';
  final isVibrationOn = StateProvider<bool>((ref) => false);
  final firstButtonClicked = StateProvider<bool>((ref) => true);
  final secondButtonClicked = StateProvider<bool>((ref) => false);
  final enableDeleteOption = StateProvider<bool>((ref) => false);
  bool vibration = false;
  String ringtone = 'Default';
  String ringtonePath = '';
  bool isAlarmOn = true;

  void update() {
    notifyListeners();
  }

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      File file = File(result.files.single.path!);
      // Do something with the file
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
    log(selectedDateTime.toString());
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

  void toggleAlarm(index, v) {
    for (int i = 0; i < alarmList.length; i++) {
      if (i == index) {
        alarmList[i]['isAlarmOn'] = v;
      }
    }
    notifyListeners();
  }

  DateTime setAlarmTimeAgain(prevTime) {
    selectedDateTime = DateTime.parse(prevTime);
    if (selectedDateTime.isBefore(DateTime.now())) {
      selectedDateTime = selectedDateTime.add(const Duration(days: 1));
    }
    log(selectedDateTime.toString());
    notifyListeners();
    return selectedDateTime;
  }

  String getDifference(DateTime setAlarm) {
    if (setAlarm.isBefore(DateTime.now())) {
      Duration duration = const Duration(hours: 24) + setAlarm.difference(DateTime.now());
      return '${duration.inHours.abs()} hours ${duration.inMinutes.remainder(60).abs()} minutes';
    } else {
      Duration duration = DateTime.now().difference(setAlarm);
      if (duration.inHours == 0) {
        return '${duration.inMinutes.remainder(60).abs() + 1} minutes';
      } else {
        return '${duration.inHours.abs()} hours ${duration.inMinutes.remainder(60).abs() + 1} minutes';
      }
    }
  }

  void saveAlarm() async {
    alarmList.clear();
    // await SpController().deleteAllData();
    var id = DateTime.now().millisecondsSinceEpoch % 10000;
    Map<String, dynamic> alarmDetails = {
      'id': id,
      "time": pickedTime,
      "dateTime": selectedDateTime.toString(),
      "repeat": selectedRepeatType,
      "vibration": vibration,
      "ringtone": ringtonePath != '' ? ringtonePath : 'assets/marimba.mp3',
      "isAlarmOn": true
    };
    String encodedMap = json.encode(alarmDetails);
    await SpController().saveAlarmDetails(encodedMap);
    await SpController().saveAlarmList(alarmDetails);
    alarmList = await SpController().getAlarmList();
    log(alarmList.toString());
    goRouter.pop();
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: selectedDateTime,
      assetAudioPath: ringtonePath != '' ? ringtonePath : 'assets/marimba.mp3',
      loopAudio: true,
      vibrate: vibration,
      volumeMax: true,
      fadeDuration: 3.0,
      notificationTitle: 'This is the title',
      notificationBody: 'This is the body',
      enableNotificationOnKill: false,
    );
    Alarm.set(alarmSettings: alarmSettings);
  }

  void editAlarm(id) async {
    for (int i = 0; i < alarmList.length; i++) {
      if (i == id) {
        alarmList[i]['time'] = pickedTime;
        alarmList[i]['dateTime'] = selectedDateTime.toString();
        alarmList[i]['repeat'] = selectedRepeatType;
        alarmList[i]['vibration'] = vibration;
        alarmList[i]['ringtone'] = ringtonePath != '' ? ringtonePath : 'assets/marimba.mp3';
        alarmList[i]['isAlarmOn'] = true;
        await SpController().deleteAllData();
        for (int i = 0; i < alarmList.length; i++) {
          await SpController().saveAlarmList(alarmList[i]);
        }
        alarmList.clear();
        alarmList = await SpController().getAlarmList();
        goRouter.pop();
        final alarmSettings = AlarmSettings(
          id: alarmList[i]['id'],
          dateTime: selectedDateTime,
          assetAudioPath: ringtonePath != '' ? ringtonePath : 'assets/marimba.mp3',
          loopAudio: true,
          vibrate: vibration,
          volumeMax: true,
          fadeDuration: 3.0,
          notificationTitle: 'This is the title',
          notificationBody: 'This is the body',
          enableNotificationOnKill: false,
        );
        Alarm.set(alarmSettings: alarmSettings);
      }
    }
  }

  String? getNextAlarmETA() {
    Duration minDiff = const Duration(days: 365);
    for (int i = 0; i < alarmList.length; i++) {
      if (alarmList[i]['isAlarmOn']) {
        DateTime dt1 = DateTime.parse(alarmList[i]['dateTime']);
        Duration diff = dt1.difference(DateTime.now());
        if (minDiff.inSeconds > diff.inSeconds) {
          minDiff = diff;
          log('text: ${minDiff.inMinutes}');
        }
      }
    }
    if (minDiff.inDays.abs() == 0 && minDiff.inHours.remainder(24).abs() != 0) {
      return 'Next alarm in ${minDiff.inHours.remainder(24).abs()} hours ${minDiff.inMinutes.remainder(60).abs()} minutes';
    } else if (minDiff.inDays.abs() == 0 && minDiff.inHours.remainder(24).abs() == 0) {
      return 'Next alarm in ${minDiff.inMinutes.remainder(60).abs() + 1} minutes';
    } else if (minDiff.inDays.abs() == 365) {
      log('yes');
      return null;
    } else {
      return 'Next alarm in ${minDiff.inDays.abs()} day ${minDiff.inHours.remainder(24).abs()} hours ${minDiff.inMinutes.remainder(60).abs()} minutes';
    }
  }

  double startingAngle() {
    double startingAngle = 0.0;
    Duration minDiff = const Duration(minutes: 720);
    for (int i = 0; i < alarmList.length; i++) {
      if (alarmList[i]['isAlarmOn']) {
        DateTime dt1 = DateTime.parse(alarmList[i]['dateTime']);
        Duration diff = dt1.difference(DateTime.now());
        if (minDiff.inMinutes > diff.inMinutes) {
          minDiff = diff;
        }
        if (minDiff.inMinutes <= 720) {
          DateTime alarmTime = DateTime.parse(alarmList[i]['dateTime']);
          String formattedTime = DateFormat('hh:mm').format(alarmTime);
          List<String> parts = formattedTime.split(":");
          int hours = int.parse(parts[0]);
          int minutes = int.parse(parts[1]);
          double decimalTime = hours + minutes / 60;
          startingAngle = 360 - ((720 - (decimalTime * 60)) / 2);
          // log(startingAngle.toString());
        } else {
          startingAngle = 0;
        }
      }
    }
    return startingAngle;
  }

  double setPercent() {
    Duration minDiff = const Duration(minutes: 720);
    double percent = 0;
    for (int i = 0; i < alarmList.length; i++) {
      if (alarmList[i]['isAlarmOn']) {
        DateTime dt1 = DateTime.parse(alarmList[i]['dateTime']);
        Duration diff = dt1.difference(DateTime.now());
        log(diff.inMinutes.toString());
        if (minDiff.inMinutes > diff.inMinutes) {
          minDiff = diff;
        }
        if (minDiff.inMinutes < 720) {
          percent = ((minDiff.inMinutes + 1) / 720);
          // log(minDiff.inMinutes.toString());
          // log(percent.toString());
        } else {
          percent = 0;
        }
      } else {
        percent = 0;
      }
    }
    return percent;
  }
}
