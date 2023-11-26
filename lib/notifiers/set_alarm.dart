import 'dart:convert';
import 'dart:developer';
import 'dart:io';
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
    pickedTime = DateFormat('HH:mm:ss').format(time);
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
    Map<String, dynamic> alarmDetails = {"time": pickedTime, "repeat": selectedRepeatType, "vibration": vibration, "ringtone": ringtonePath};
    // alarmList.add(alarmDetails);
    String encodedMap = json.encode(alarmDetails);
    await SpController().saveAlarmDetails(encodedMap);
    await SpController().saveAlarmList(alarmDetails);
    alarmList = await SpController().getAlarmList();
    log(alarmList.toString());
  }
}
