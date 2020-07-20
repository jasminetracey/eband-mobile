import 'package:eband/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle headingText = TextStyle(
    color: AppColors.textColor,
    fontWeight: FontWeight.w600,
    fontSize: 22,
  );

  static const TextStyle headingTextPrimary = TextStyle(
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w600,
    fontSize: 22,
  );

  static const TextStyle headingTextWhite = TextStyle(
    color: AppColors.whiteColor,
    fontWeight: FontWeight.w600,
    fontSize: 22,
  );

  static const TextStyle subheadingText = TextStyle(
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
    fontSize: 16,
    letterSpacing: 0.15,
  );

  static const TextStyle subheadingTextPrimary = TextStyle(
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    fontSize: 16,
    letterSpacing: 0.15,
  );

  static const TextStyle subheadingTextWhite = TextStyle(
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
    fontSize: 16,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyTextWhite = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 14,
  );

  static const TextStyle bodyTextPrimary = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 14,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: AppColors.textColor,
  );
}
