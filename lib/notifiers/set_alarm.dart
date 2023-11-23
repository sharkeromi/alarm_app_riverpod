import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

class SetAlarmNotifier extends ChangeNotifier {
  List repeatType = ['Once', 'Daily', 'Sat to Wed', 'Custom'];
  List weekDays = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  List<String> selectedDays = [];

  final pickedTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());
  final tempSelectedRepeatType = StateProvider<String>((ref) => '');
  final selectedRepeatType = StateProvider<String>((ref) => '');
  final isVibrationOn = StateProvider<bool>((ref) => false);
  String ringtone = '';

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      File file = File(result.files.single.path!);
      // Do something with the file
      log(file.uri.toString());
      log(file.path.toString());
      var nameFilter = file.path.toString().split('file_picker/');
      ringtone = nameFilter.last;
      log(ringtone);
    } else {
      log('Failed');
      // User canceled the picker
    }
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
}
