

import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final GestureTapCallback? onPressed;
  final double? buttonWidth, prefixIconSize;
  final double? buttonHeight;
  final Color? buttonColor, borderColor, prefixIconColor, suffixIconColor;
  final bool isCircularHead;
  final IconData? prefixIcon, suffixIcon;
  final TextStyle? textStyle;
  final bool? isCustomButton;

  const CustomElevatedButton({
    Key? key,
    this.buttonColor = cPrimaryColor,
    this.borderColor,
    required this.label,
    required this.onPressed,
    this.buttonWidth,
    this.prefixIcon,
    this.buttonHeight,
    this.isCircularHead = false,
    this.textStyle,
    this.prefixIconColor,
    this.suffixIconColor,
    this.suffixIcon,
    this.isCustomButton,
    this.prefixIconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            minimumSize: MaterialStateProperty.all(Size.zero),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: isCircularHead ? BorderRadius.circular(50) : BorderRadius.circular(4),
              side: BorderSide(color: (buttonColor == cWhiteColor) ? (borderColor ?? cPrimaryColor) : cTransparentColor, width: 1),
            )),
            backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return cPlaceHolderColor;
              }
              return buttonColor!;
            }),
            splashFactory: InkRipple.splashFactory,
          ),
          child: SizedBox(
            height: buttonHeight ?? (isDeviceScreenLarge() ? (kButtonHeight) : (kButtonHeight - 4)),
            width: isCustomButton == true ? null : (buttonWidth ?? width * .5),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isCustomButton != true ? 0.0 : 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        prefixIcon!,
                        color: prefixIconColor ?? cWhiteColor,
                        size: prefixIconSize ?? 16,
                      ),
                    ),
                  Text(label.toString(), textAlign: TextAlign.center, style: textStyle),
                  if (suffixIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        suffixIcon!,
                        color: suffixIconColor ?? cWhiteColor,
                        size: screenWiseSize(suffixIcon == Icons.keyboard_arrow_down_rounded ? 20 : 16, 4),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
