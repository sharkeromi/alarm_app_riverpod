import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:alarm_app_riverpod/global_controller.dart';
import 'package:alarm_app_riverpod/providers.dart';
import 'package:alarm_app_riverpod/widgets/custom_list_tile.dart';
import 'package:alarm_app_riverpod/widgets/custom_radio_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetAlarm extends ConsumerWidget {
  SetAlarm({super.key});
  final GlobalController globalController = GlobalController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final pickedTime = ref.watch(pickedTimeProvider);
    final setAlarmNotifier = ref.watch(setAlarmChangeNotifierProvider);
    return Scaffold(
      backgroundColor: cWhiteColor,
      appBar: AppBar(
        elevation: 0,
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: cWhiteColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            size: 28,
            color: cTextPrimaryColor,
          ),
        ),
        title: const Text(
          'Set alarm',
          style: TextStyle(fontSize: 20, color: cTextPrimaryColor),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.done, size: 28, color: cTextPrimaryColor),
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    mode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: (v) {
                      ref.read(setAlarmNotifier.pickedTimeProvider.notifier).state = v;
                      setAlarmNotifier.getDifference(v);
                    }),
              ),
              Text(
                '${setAlarmNotifier.getDifference(ref.watch(setAlarmNotifier.pickedTimeProvider))} remaining',
                style: const TextStyle(fontSize: 16, color: cPrimaryColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                // height: 180,
                decoration: BoxDecoration(
                  color: cPrimaryTintColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: cTextPrimaryColor.withOpacity(.2), offset: const Offset(3, 3), blurRadius: 20),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      LinkUpTextRow(
                        prefixText: 'Repeat',
                        suffixText: ref.watch(setAlarmNotifier.selectedRepeatType),
                        onPressed: () {
                          if (ref.read(setAlarmNotifier.selectedRepeatType.notifier).state != '') {
                            ref.read(setAlarmNotifier.tempSelectedRepeatType.notifier).state = ref.read(setAlarmNotifier.selectedRepeatType.notifier).state;
                          }
                          globalController.commonBottomSheet(
                              context: context,
                              content: const RepeatBottomSheetContent(),
                              onPressCloseButton: () {
                                Navigator.pop(context);
                              },
                              onPressRightButton: () {
                                Navigator.pop(context);
                                if (ref.read(setAlarmNotifier.tempSelectedRepeatType.notifier).state == 'Custom') {
                                  globalController.commonBottomSheet(
                                      context: context,
                                      content: const CustomRepeatTypeBottomSheetContent(),
                                      onPressCloseButton: () {
                                        Navigator.pop(context);
                                      },
                                      onPressRightButton: () {},
                                      rightText: 'Done',
                                      rightTextStyle: const TextStyle(color: cPrimaryColor, fontSize: 16),
                                      title: 'Select custom days',
                                      isRightButtonShow: true);
                                }
                                ref.read(setAlarmNotifier.selectedRepeatType.notifier).state = ref.read(setAlarmNotifier.tempSelectedRepeatType.notifier).state;
                              },
                              rightText: 'Done',
                              rightTextStyle: const TextStyle(color: cPrimaryColor, fontSize: 16),
                              title: 'Repeat type',
                              isRightButtonShow: true);
                        },
                      ),
                      kH12sizedBox,
                      LinkUpTextRow(
                        prefixText: 'Vibration',
                        trailing: Transform.scale(
                          scale: .7,
                          child: CupertinoSwitch(
                            activeColor: cPrimaryColor,
                            thumbColor: cPrimaryTintColor,
                            value: ref.watch(setAlarmNotifier.isVibrationOn),
                            onChanged: (v) {
                              ref.read(setAlarmNotifier.isVibrationOn.notifier).state = v;
                            },
                          ),
                        ),
                      ),
                      kH12sizedBox,
                      LinkUpTextRow(
                        prefixText: 'Ringtone',
                        onPressed: () {
                          setAlarmNotifier.selectFile();
                        },
                        suffixText: setAlarmNotifier.ringtone,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LinkUpTextRow extends StatelessWidget {
  const LinkUpTextRow({super.key, required this.prefixText, this.suffixText, this.onPressed, this.trailing});
  final String prefixText;
  final String? suffixText;
  final VoidCallback? onPressed;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$prefixText ',
                style: const TextStyle(color: cTextPrimaryColor, fontSize: 16),
              ),
            ),
            if (trailing == null)
              SizedBox(
                width: 150,
                child: Text(
                  suffixText ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: cTextSecondaryColor, fontSize: 14),
                ),
              ),
            if (trailing == null)
              const Icon(
                Icons.navigate_next_rounded,
                color: cIconColor,
              ),
            if (trailing != null) trailing!
          ],
        ),
      ),
    );
  }
}

class RepeatBottomSheetContent extends ConsumerWidget {
  const RepeatBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setAlarmNotifier = ref.watch(setAlarmChangeNotifierProvider);
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: setAlarmNotifier.repeatType.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CustomListTile(
                itemColor: ref.watch(setAlarmNotifier.tempSelectedRepeatType) == setAlarmNotifier.repeatType[index] ? cPrimaryTintColor : cWhiteColor,
                onPressed: () {
                  ref.read(setAlarmNotifier.tempSelectedRepeatType.notifier).state = setAlarmNotifier.repeatType[index];
                },
                borderColor: ref.watch(setAlarmNotifier.tempSelectedRepeatType) == setAlarmNotifier.repeatType[index] ? cPrimaryColor : cOutLineColor,
                title: setAlarmNotifier.repeatType[index],
                trailing: CustomRadioButton(
                  isSelected: ref.watch(setAlarmNotifier.tempSelectedRepeatType) == setAlarmNotifier.repeatType[index] ? true : false,
                  onChanged: () {
                    ref.read(setAlarmNotifier.tempSelectedRepeatType.notifier).state = setAlarmNotifier.repeatType[index];
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CustomRepeatTypeBottomSheetContent extends ConsumerWidget {
  const CustomRepeatTypeBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setAlarmNotifier = ref.watch(setAlarmChangeNotifierProvider);
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: setAlarmNotifier.weekDays.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CustomListTile(
                title: setAlarmNotifier.weekDays[index],
                itemColor: setAlarmNotifier.selectedDays.contains(setAlarmNotifier.weekDays[index]) ? cPrimaryTintColor : cWhiteColor,
                borderColor: setAlarmNotifier.selectedDays.contains(setAlarmNotifier.weekDays[index]) ? cPrimaryColor : cOutLineColor,
                onPressed: () {
                  if (setAlarmNotifier.selectedDays.contains(setAlarmNotifier.weekDays[index])) {
                    setAlarmNotifier.removeDay(setAlarmNotifier.weekDays[index]);
                  } else {
                    setAlarmNotifier.addDay(setAlarmNotifier.weekDays[index]);
                  }
                },
                trailing: CustomRadioButton(
                  isSelected: setAlarmNotifier.selectedDays.contains(setAlarmNotifier.weekDays[index]) ? true : false,
                  onChanged: () {
                    //ref.read(setAlarmNotifier.tempSelectedRepeatType.notifier).state = setAlarmNotifier.weekDays[index];
                    if (setAlarmNotifier.selectedDays.contains(setAlarmNotifier.weekDays[index])) {
                      setAlarmNotifier.removeDay(setAlarmNotifier.weekDays[index]);
                    } else {
                      setAlarmNotifier.addDay(setAlarmNotifier.weekDays[index]);
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// class SelectRingtoneBottomSheetContent extends ConsumerWidget {
//   const SelectRingtoneBottomSheetContent({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final setAlarmNotifier = ref.watch(setAlarmChangeNotifierProvider);
//     return Column(
//       children: [
//         ListView.builder(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: setAlarmNotifier.songs.length,
//           itemBuilder: (BuildContext context, int index) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 8),
//               child: CustomListTile(
//                 itemColor: ref.watch(setAlarmNotifier.tempSelectedRepeatType) == setAlarmNotifier.repeatType[index] ? cPrimaryTintColor : cWhiteColor,
//                 onPressed: () {
//                   ref.read(setAlarmNotifier.tempSelectedRepeatType.notifier).state = setAlarmNotifier.repeatType[index];
//                 },
//                 borderColor: ref.watch(setAlarmNotifier.tempSelectedRepeatType) == setAlarmNotifier.repeatType[index] ? cPrimaryColor : cOutLineColor,
//                 title: setAlarmNotifier.songs[index].path.split('/').last,
//                 trailing: CustomRadioButton(
//                   isSelected: ref.watch(setAlarmNotifier.tempSelectedRepeatType) == setAlarmNotifier.repeatType[index] ? true : false,
//                   onChanged: () {
//                     ref.read(setAlarmNotifier.tempSelectedRepeatType.notifier).state = setAlarmNotifier.repeatType[index];
//                   },
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
