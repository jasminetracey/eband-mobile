import 'package:eband/screens/components/rounded_button.dart';
import 'package:eband/utils/app_colors.dart';
import 'package:eband/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Function leftOnPressed;
  final String leftText;
  final String rightText;
  final Function rightOnPressed;

  const CustomDialog({
    Key key,
    @required this.title,
    @required this.leftOnPressed,
    @required this.leftText,
    @required this.rightText,
    @required this.rightOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: AppColors.primaryColor,
      title: Text(
        title,
        style: AppTextStyles.headingTextWhite,
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RoundedButton(
              color: AppColors.whiteColor,
              textColor: AppColors.primaryColor,
              text: leftText,
              onPressed: leftOnPressed,
            ),
            RoundedButton(
              color: AppColors.whiteColor,
              textColor: AppColors.primaryColor,
              text: rightText,
              onPressed: rightOnPressed,
            ),
          ],
        )
      ],
    );
  }
}
