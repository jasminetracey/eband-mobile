import 'package:flutter/material.dart';

const double kBorderRadius = 8;

const kSafeArea = EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0);

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

Widget verticalSpaceTiny(BuildContext context) => SizedBox(
      height: screenHeight(context) * 0.01,
    );

Widget verticalSpaceSmall(BuildContext context) => SizedBox(
      height: screenHeight(context) * 0.02,
    );

Widget verticalSpaceMedium(BuildContext context) => SizedBox(
      height: screenHeight(context) * 0.04,
    );

Widget verticalSpaceLarge(BuildContext context) => SizedBox(
      height: screenHeight(context) * 0.1,
    );

Widget verticalSpaceMassive(BuildContext context) => SizedBox(
      height: screenHeight(context) * 0.32,
    );
