import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:alarm_app_riverpod/const/routes.dart';
import 'package:alarm_app_riverpod/controllers/global_controller.dart';
import 'package:alarm_app_riverpod/providers.dart';
import 'package:alarm_app_riverpod/widgets/custom_button.dart';
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: InkWell(
          onTap: () {
            // Navigator.pop(context);
            goRouter.pop();
          },
          child: Icon(
            Icons.close,
            size: 28,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          'Set alarm',
          style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: true,
      ),
      floatingActionButton: CustomElevatedButton(
        buttonColor: cPrimaryTintColor,
        textStyle: TextStyle(color: cWhiteColor, fontSize: 16, fontWeight: FontWeight.bold),
        isCircularHead: true,
        label: 'Save',
        onPressed: () {
          if (setAlarmNotifier.isEditModeOn) {
            setAlarmNotifier.editAlarm(setAlarmNotifier.selectedId);
          } else {
            setAlarmNotifier.saveAlarm();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // kH10sizedBox,
              Container(
                height: 40,
                width: width - 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: cBackgroundNeutralColor2,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: TextButton(
                            onPressed: () {
                              ref.read(setAlarmNotifier.firstButtonClicked.notifier).state = true;
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              splashFactory: InkSplash.splashFactory,
                            ),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ref.watch(setAlarmNotifier.firstButtonClicked) ? cPrimaryTintColor : cBackgroundNeutralColor2,
                              ),
                              child: Center(
                                child: Text(
                                  '12H Fromat ',
                                  style: TextStyle(color: ref.watch(setAlarmNotifier.firstButtonClicked) ? cWhiteColor : cTextSecondaryColor, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: TextButton(
                            onPressed: () {
                              ref.read(setAlarmNotifier.firstButtonClicked.notifier).state = false;
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              splashFactory: InkSplash.splashFactory,
                            ),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: !ref.watch(setAlarmNotifier.firstButtonClicked) ? cPrimaryTintColor : cBackgroundNeutralColor2,
                              ),
                              child: Center(
                                child: Text(
                                  '24H Fromat',
                                  style: TextStyle(color: !ref.watch(setAlarmNotifier.firstButtonClicked) ? cWhiteColor : cTextSecondaryColor, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                    initialDateTime: ref.watch(setAlarmNotifier.pickedTimeProvider),
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: !ref.watch(setAlarmNotifier.firstButtonClicked),
                    onDateTimeChanged: (v) {
                      ref.read(setAlarmNotifier.pickedTimeProvider.notifier).state = v;
                      setAlarmNotifier.pickTime(v);
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
                        suffixText: setAlarmNotifier.selectedRepeatType,
                        onPressed: () {
                          if (setAlarmNotifier.selectedRepeatType != '') {
                            ref.read(setAlarmNotifier.tempSelectedRepeatType.notifier).state = setAlarmNotifier.selectedRepeatType;
                          }
                          globalController.commonBottomSheet(
                              context: context,
                              content: const RepeatBottomSheetContent(),
                              onPressCloseButton: () {
                                Navigator.pop(context);
                                // goRouter.go(krHomePage);
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
                                // setAlarmNotifier.selectedRepeatType = ref.read(setAlarmNotifier.tempSelectedRepeatType.notifier).state;
                                setAlarmNotifier.setRepeatStatus(ref.read(setAlarmNotifier.tempSelectedRepeatType.notifier).state);
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
                            activeColor: cPinkColor,
                            thumbColor: cWhiteColor,
                            trackColor: cPrimaryColor,
                            value: ref.watch(setAlarmNotifier.isVibrationOn),
                            onChanged: (v) {
                              ref.read(setAlarmNotifier.isVibrationOn.notifier).state = v;
                              setAlarmNotifier.setVibrationStatus(v);
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
                style: const TextStyle(color: cWhiteColor, fontSize: 16),
              ),
            ),
            if (trailing == null)
              SizedBox(
                width: 150,
                child: Text(
                  suffixText ?? '',
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: cWhiteColor, fontSize: 14),
                ),
              ),
            if (trailing == null)
              const Icon(
                Icons.navigate_next_rounded,
                color: cWhiteColor,
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
