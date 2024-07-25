
import 'package:flutter/material.dart';

class AppColors {
  static const Color dark0 = Color(0xFF1d1d1d);
  static const Color dark1 = Color(0xFF19212e);
  static const Color dark2 = Color(0xFF1f2534);
  static const Color dark3 = Color(0xFF262d3d);
  static const Color dark4 = Color(0xFF2f3748);
  static const Color charcoalGrey = Color(0xFF36404e);
  static const Color charcoalGrey2 = Color(0xff404c56);
  static const Color slate = Color(0xff444e63);
  static const Color grayishBrown = Color(0xFF515151);
  static const Color pine = Color(0xff2f4830);
  static const Color darkSage = Color(0xff446346);
  static const Color lightSage = Color(0xffd7f2c3);
  static const Color washedOutGreen = Color(0xffc3ef9e);
  static const Color coolGray = Color(0xff9ea9b2);
  static const Color coolGray2 = Color(0xFFb2bdc6);
  static const Color primaryAccent = Color(0xff6bae33);
  static const Color primaryAccentLight = Color(0xff7dc144);
  static const Color secondaryAccent = Color(0xff447ac1);
  static const Color orange = Color(0xffff7335);
  static const Color sandyYellow = Color(0xffedcc1f);
  static const Color darkRed = Color(0xffef1a1a);
  static const Color blueishWhite = Color(0xfff5f9fc);
  static const Color white = Color(0xffffffff);
  static const Color paleGray = Color(0xffF9FBFF);

  static const Color loadingIndicator = Color(0xFFffffff);
  static const Color brightIcon = Color(0xFFffffff);
  static const Color darkIcon = Color(0xff2a2828);
  static const Color secondaryText = Color(0xFF242a30);
  static const Color error = Color(0xffe21717);
  static const Color errorLite = Color(0xffeee5e5);
  static const Color bottomNavBarMainButton = Color(0xFF1d61a5);
  static const Color sos = Color(0xffff0000);
  static const Color pttIdle = Color(0xFFff6c00);
  static const Color pttTransmitting = Color(0xFFff0d0d);
  static const Color pttReceiving = Color(0xFF7dc144);
  static const Color overlayBarrier = Color.fromRGBO(0, 0, 0, .6);
  static const Color alertnessFailed = Color(0xFFff5a04);
  static const Color shiftSummaryIconColor = Color(0x800D64F5);
  static const Color selectedItemIconColor = Color(0x80032A6C);
  static const Color mapMarkerPath = Colors.blue;
  static const Color qrScannerRect = Color(0xFFffc000);
  static const Color graphBorder = Color(0xffbfbfbf);
  static const Color textFieldFill = Color(0xfff1f1f1);

  /// New colors.
  static const Color mainColor = Color(0xFF092B4C);
  static const Color secondColor = Color(0xFFAF2763);
  static const Color disabledBtn = Color(0x77785fe5);
  static const Color darkGray = Color(0xff5a5c60);
  static const Color black = Color(0xff333333);
  static const Color blackBlack = Color(0xff000000);
  static const Color gray = Color(0xff828282);
  static const Color lightGray = Color(0xffbdbdbd);
  static const Color superLightGray = Color(0xffd9d9d9);
  static const Color bgLayout = Color(0xffeef5fb);
  static const Color bgSuperLightGray = Color(0xffF6FAFF);
  static const Color green = Color(0xff467c5d);
  static const Color lightGreen = Color(0xffe1ecf8);
  static const Color red = Color(0xffF18070);
  static const Color violet = Color(0xffdd16bf);
  static const Color workWhite = Color(0xffffffff);
  static const Color shadowBottomMenu = Color(0xff818fa3);
  static const Color secondButton = Color(0xffb99285);
  static const Color bgMenu = Color(0xffebf7fd);
}

class AppStyles {
  static const regularBodyDarkText = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.black);
  static const regularDarkText15 = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.black);
  static const regularDarkText16 = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.black);
  static const regularHeading17 = TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: AppColors.black);
  static const regularHeading18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.black);
  static const boldHeading18 = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black);
  static const boldHeading20 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.black);
  static const boldHeading22 = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.black);
  static const regular20 = TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: AppColors.black);
  static const boldHeading26 = TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.black);
  static const boldBigHeading = TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.black);
  static const regularBigHeading = TextStyle(fontSize: 32, fontWeight: FontWeight.w500, color: AppColors.black);

  static const regularBodyGreyText12 = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey);
  static const regularBodyGreyText14 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey);
  static const boldGreyText16 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey);
  static const regularGreyText16 = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey);
  static const boldGreyHeading18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey);
  static const regularGrey18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey);
  static const boldGreyHeading22 = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey);

  static const regularBodyWhiteText = TextStyle(fontSize: 8, fontWeight: FontWeight.w400, color: Colors.white);
  static const regularWhiteText = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white);
  static const regularWhiteHeading = TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white);
  static const regularWhiteHeading20 = TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white);
  static const boldWhiteHeading = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white);
  static const regularBlueHeading20 = TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.mainColor);


  static const regularBodyMainText14 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.mainColor);
  static const regularBodyBoldMainText14 =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.mainColor);
  static const regularBodyMainText = TextStyle(fontSize: 8, fontWeight: FontWeight.w400, color: AppColors.mainColor);
  static const regularMainText16 = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.mainColor);
  static const boldMainText16 = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.mainColor);
  static const regularMainHeading18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: AppColors.mainColor);
  static const boldMainHeading18 = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.mainColor);
  static const boldMainHeading22 = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.mainColor);
  static const boldMainHeading24 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.mainColor);
}
