import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const kAlarmDetails = 'kAlarmDetails';
const kAlarmList = 'kAlarmList';

class SpController {
  Future<void> saveAlarmDetails(alarmDetails) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(kAlarmDetails, alarmDetails.toString());
  }

  Future<String?> getAlarmDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(kAlarmDetails);
  }

  Future<void> saveAlarmList(alarmList) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<dynamic> previousAlarms = await getAlarmList();
    previousAlarms.add(alarmList);
    String encodeData = json.encode(previousAlarms);
    await preferences.setString(kAlarmList, encodeData);
  }

  Future<dynamic> getAlarmList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? data = preferences.getString(kAlarmList);
    List<dynamic> alarmList = (data == null) ? [] : json.decode(data);
    return alarmList;
  }

  Future<void> deleteAllData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(kAlarmList);
  }

  Future<void> deleteAlarm(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? data = preferences.getString(kAlarmList);
    List alarmList = (data == null) ? [] : json.decode(data);

    // Check if the index is within the range of the list
    if (index >= 0 && index < alarmList.length) {
      // Remove the alarm at the specified index
      alarmList.removeAt(index);
      // Update the state of the alarms in the list
      // for (int i = 0; i < alarmList.length; i++) {
      //   if (i >= index) {
      //     alarmList[i]['id'] = i;
      //   }
      // }

      // Encode the updated list and save it back to SharedPreferences
      String encodeData = json.encode(alarmList);
      await preferences.setString(kAlarmList, encodeData);
    }
  }
}
