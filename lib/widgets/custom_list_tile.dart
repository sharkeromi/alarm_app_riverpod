import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    this.title,
    this.subtitle,
    this.onPressed,
    this.leading,
    this.trailing,
    this.itemColor = cWhiteColor,
    this.borderColor,
    this.padding,
    this.spacing = 5,
    this.alignLeadingWithTitle = false,
    this.titleTextStyle,
    this.subTitleTextStyle,
  }) : super(key: key);

  final dynamic title, subtitle;
  final Function()? onPressed;
  final dynamic leading, trailing;
  final Color itemColor;
  final Color? borderColor;
  final bool alignLeadingWithTitle;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final TextStyle? titleTextStyle;
  final TextStyle? subTitleTextStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 45),
      decoration: BoxDecoration(
        color: itemColor,
        border: Border.all(color: borderColor ?? itemColor),
        borderRadius: BorderRadius.circular(8),
      ),
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            splashFactory: InkSplash.splashFactory,
          ),
          onPressed: onPressed,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: alignLeadingWithTitle ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                if (leading != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: leading!,
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: cTextPrimaryColor, fontSize: 14),
                      )
                    ],
                  ),
                ),
                if (trailing != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: trailing!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
