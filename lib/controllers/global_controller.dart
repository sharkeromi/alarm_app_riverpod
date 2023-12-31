import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:alarm_app_riverpod/widgets/custom_icon_button.dart';
import 'package:alarm_app_riverpod/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

class GlobalController {
  void commonBottomSheet({
    required context,
    required Widget content,
    required onPressCloseButton,
    required onPressRightButton,
    required String rightText,
    required TextStyle rightTextStyle,
    required String title,
    required bool isRightButtonShow,
    double? bottomSheetHeight,
  }) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)), color: cWhiteColor),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).viewInsets.bottom > 0.0 ? height * .9 : bottomSheetHeight ?? height * .5,
              constraints: BoxConstraints(minHeight: bottomSheetHeight ?? height * .5, maxHeight: height * .9),
              child: Column(
                children: [
                  kH4sizedBox,
                  Container(
                    decoration: BoxDecoration(
                      color: cOutLineColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    height: 5,
                    width: width * .1,
                  ),
                  kH40sizedBox,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: content,
                      ),
                    ),
                  ),
                  kH4sizedBox,
                ],
              ),
            ),
            Positioned(
              top: 12,
              left: 5,
              child: CustomIconButton(
                onPress: onPressCloseButton,
                icon: Icons.cancel_rounded,
                iconColor: cIconColor,
                size: 24,
              ),
            ),
            Positioned(
              top: 20,
              child: Text(
                title,
                style: const TextStyle(color: cTextPrimaryColor, fontSize: 18),
              ),
            ),
            if (isRightButtonShow)
              Positioned(
                top: 20,
                right: 10,
                child: CustomTextButton(
                  onPressed: onPressRightButton,
                  text: rightText,
                  textStyle: rightTextStyle,
                ),
              ),
          ],
        );
      },
    );
  }

  // void getStoragePermission() async {
  //   PermissionStatus status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     status = await Permission.storage.request();
  //   }
  //   if (status.isGranted) {
  //     // Access the external storage
  //     log('Storage ok');
  //   } else {
  //     log('Storage not ok');
  //     // Handle the case where the permission is not granted
  //   }
  // }

  // void getManageStoragePermission() async {
  //   PermissionStatus status = await Permission.manageExternalStorage.status;
  //   if (!status.isGranted) {
  //     status = await Permission.manageExternalStorage.request();
  //   }

  //   if (status.isGranted) {
  //     // Access the external storage
  //     log('External Storage ok');
  //   } else {
  //     // Handle the case where the permission is not granted
  //     log('External Storage not ok');
  //   }
  // }
}
