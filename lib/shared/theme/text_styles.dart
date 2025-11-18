import 'package:flutter/material.dart';
import 'package:book_library_app/shared/config/dimens.dart';
import 'package:book_library_app/shared/theme/app_colors.dart';

class AppTextStyles {
  static const String fontFamily = 'OpenSans';

  // 🔹 SemiBold
  static final TextStyle openSansSemiBold16 = TextStyle(
    fontSize: Dimens.font_16,
    fontWeight: FontWeight.w500,
    fontFamily: fontFamily,
    color: AppColors.colorPrimary,
  );

  // 🔹 Regular
  static const TextStyle openSansRegular10w300 = TextStyle(
    fontSize: Dimens.font_10,
    fontWeight: FontWeight.w300,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansRegular12w300 = TextStyle(
    fontSize: Dimens.font_12,
    fontWeight: FontWeight.w300,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansRegular14w400 = TextStyle(
    fontSize: Dimens.font_14,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansRegular12 = TextStyle(
    fontSize: Dimens.font_12,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansRegular14 = TextStyle(
    fontSize: Dimens.font_14,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansRegular16 = TextStyle(
    fontSize: Dimens.font_16,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansRegular18 = TextStyle(
    fontSize: Dimens.font_18,
    fontFamily: fontFamily,
  );

  // 🔹 Bold
  static const TextStyle openSansBold12 = TextStyle(
    fontSize: Dimens.font_12,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansBold13 = TextStyle(
    fontSize: 13.0, // No Dimens.font_13 defined
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansBold14 = TextStyle(
    fontSize: Dimens.font_14,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansBold16 = TextStyle(
    fontSize: Dimens.font_16,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansBold18 = TextStyle(
    fontSize: Dimens.font_18,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansBold20 = TextStyle(
    fontSize: Dimens.font_20,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansBold24 = TextStyle(
    fontSize: Dimens.font_24,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansBold32 = TextStyle(
    fontSize: Dimens.font_32,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansBold40 = TextStyle(
    fontSize: Dimens.font_40,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
  );

  static const TextStyle openSansBold44 = TextStyle(
    fontSize: 44.0, // No Dimens.font_44 defined
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
  );
}