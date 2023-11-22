import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.onPress,
    required this.icon,
    this.iconColor,
    this.size,
    this.hasBorder = true,
  }) : super(key: key);

  final Function()? onPress;
  final IconData? icon;
  final Color? iconColor;
  final double? size;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: TextButton(
        onPressed: onPress,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          splashFactory: InkSplash.splashFactory,
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            const SizedBox(
              height: 36,
              width: 36,
            ),
            Icon(
              icon,
              size: size ?? 28,
              color: iconColor ?? cIconColor,
            ),
          ],
        ),
      ),
    );
  }
}
