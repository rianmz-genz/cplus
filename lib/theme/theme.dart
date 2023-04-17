import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeCustom {
  ThemeCustom._();
  static ThemeMode themeLight = ThemeMode.light;

  static ThemeData light = FlexThemeData.light(
    colors: FlexSchemeColor(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      error: AppColors.error,
    ),
    background: AppColors.background,
    appBarStyle: FlexAppBarStyle.material,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      blendOnColors: false,
      textButtonRadius: 14.0,
      elevatedButtonRadius: 14.0,
      outlinedButtonRadius: 14.0,
      unselectedToggleIsColored: true,
      appBarBackgroundSchemeColor: SchemeColor.background,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    // To use the playground font, add GoogleFonts package and uncomment
    fontFamily: FontFamily.poppins,
  );
}

class FontFamily {
  FontFamily._();
  static String? poppins = GoogleFonts.poppins().fontFamily;
  static String? font2 = GoogleFonts.nunito().fontFamily;
}

class FontSize {
  FontSize._();
  static double bigTitle1 = 22;
  static double bigTitle2 = 20;
  static double title = 16;
  static double smallTitle = 14;
  static double subtitle = 12;
  static double body = 12;
  static double caption = 10;
}

class AppColors {
  AppColors._();
  static Color transparent = Colors.transparent;
  static Color background = const Color(0xffFBFBFB);
  static Color primary = const Color(0xffFF731D);
  static Color secondary = const Color(0xffFFF7E9);
  static Color tertiary = const Color(0xff5F9DF7);
  static Color quartieary = const Color(0xff1746A2);
  static Color appBarColor1 = const Color(0xffFBFBFB);
  static Color appBarColor2 = const Color(0xffE6CCB2);
  static Color error = const Color(0xffb00020);
  static Color success = const Color(0xff4caf50);
  static Color warning = const Color(0xffff9800);
  static Color info = const Color(0xff2196f3);
  static Color textBlack = const Color(0xff000000);
  static Color textBlackSec = const Color(0xff000000).withOpacity(0.5);
  static Color textWhite = const Color(0xffffffff);
  static Color textWhiteSec = const Color.fromARGB(255, 204, 204, 204);
  static Color textColor = const Color(0xff210F04);
  static Color textColorSec = const Color(0xff210F04).withOpacity(0.5);
  static Color button = const Color(0xff9C6644);
  static Color card1 = const Color(0xffEFEEEE);
  static Color card2 = const Color(0xffFBFBFB);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color beige = Color(0xFFA8A878);
  static const Color black = Color(0xFF303943);
  static const Color blue = Color(0xFF429BED);
  static const Color darkBlue = Color.fromARGB(255, 0, 57, 243);
  static const Color brown = Color(0xFFB1736C);
  static const Color darkBrown = Color(0xD0795548);
  static const Color darkGrey = Color(0xFF303943);
  static Color darkGreyOp = const Color(0xFF303943).withOpacity(0.2);
  static const Color grey = Color(0x64303943);
  static const Color indigo = Color(0xFF6C79DB);
  static const Color lightBlue = Color(0xFF7AC7FF);
  static const Color lightBrown = Color(0xFFCA8179);
  static const Color whiteGrey = Color(0xFFFDFDFD);
  static const Color lightCyan = Color(0xFF98D8D8);
  static const Color lightGreen = Color(0xFF78C850);
  static const Color lighterGrey = Color(0xFFF4F5F4);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color lightPink = Color(0xFFEE99AC);
  static const Color lightPurple = Color(0xFF9F5BBA);
  static const Color lightRed = Color(0xFFFB6C6C);
  static const Color lightTeal = Color(0xFF48D0B0);
  static const Color lightYellow = Color(0xFFFFCE4B);
  static const Color lilac = Color(0xFFA890F0);
  static const Color pink = Color(0xFFF85888);
  static const Color purple = Color(0xFF7C538C);
  static const Color red = Color(0xFFFA6555);
  static const Color teal = Color(0xFF4FC1A6);
  static const Color yellow = Color(0xFFF6C747);
  static const Color orange = Color(0xFFE67E22);
  static const Color semiGrey = Color(0xFFbababa);
  static Color semiGreyOp = const Color(0xFFbababa).withOpacity(0.5);
  static const Color violet = Color(0xD07038F8);
}
