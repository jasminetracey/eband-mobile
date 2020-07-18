import 'package:eband/utils/app_colors.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final Function onPressed;
  final String text;
  final EdgeInsetsGeometry padding;

  const RoundedButton({
    Key key,
    this.color = AppColors.primaryColor,
    this.textColor = AppColors.whiteColor,
    @required this.onPressed,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color,
      onPressed: onPressed,
      padding: padding,
      child: Text(
        text,
        style: Theme.of(context).textTheme.button.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: textColor,
            ),
      ),
    );
  }
}
