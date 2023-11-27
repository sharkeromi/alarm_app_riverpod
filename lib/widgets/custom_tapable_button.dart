import 'package:alarm_app_riverpod/const/colors.dart';
import 'package:flutter/material.dart';

class TapAbleButtonContainer extends StatelessWidget {
  const TapAbleButtonContainer({
    Key? key,
    required this.firstText,
    required this.secondText,
    required this.firstButtonOnPressed,
    required this.secondButtonOnPressed,
    required this.firstButtonClicked,
  }) : super(key: key);

  final VoidCallback? firstButtonOnPressed, secondButtonOnPressed;
  final String firstText, secondText;
  final bool firstButtonClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
                  onPressed: firstButtonOnPressed,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    splashFactory: InkSplash.splashFactory,
                  ),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: firstButtonClicked ? cWhiteColor : cBackgroundNeutralColor2,
                    ),
                    child: Center(
                      child: Text(
                        firstText.toString(),
                        style: TextStyle(color: firstButtonClicked ? cTextPrimaryColor : cTextSecondaryColor, fontSize: 14),
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
                  onPressed: secondButtonOnPressed,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    splashFactory: InkSplash.splashFactory,
                  ),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: !firstButtonClicked ? cWhiteColor : cBackgroundNeutralColor2,
                    ),
                    child: Center(
                      child: Text(
                        secondText.toString(),
                        style: TextStyle(color: !firstButtonClicked ? cTextPrimaryColor : cTextSecondaryColor, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
