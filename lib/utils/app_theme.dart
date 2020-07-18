import 'package:eband/utils/app_colors.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: AppColors.primaryColor,
    accentColor: AppColors.primaryColor,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      actionsIconTheme: IconThemeData(color: Colors.black87),
      iconTheme: IconThemeData(color: Colors.black87),
      color: AppColors.whiteColor,
      brightness: Brightness.light,
      elevation: 0,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme,
    ).apply(
      bodyColor: Colors.black87,
      fontSizeFactor: 1.05,
    ),
    primaryTextTheme: GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme,
    ),
    accentTextTheme: GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme,
    ).apply(bodyColor: Colors.green),

    // Page Transition
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,

    //button
    buttonTheme: ButtonThemeData(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      // shape: const StadiumBorder(),
      buttonColor: AppColors.whiteColor,
      textTheme: ButtonTextTheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor),
        // borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor),
        // borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 16,
      ),
    ),

    //dialog
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
    ),
  );
}
