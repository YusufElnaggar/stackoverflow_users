import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'constants/colors_constants.dart';

ThemeData theme() {
  return ThemeData(
    primaryColor: kPrimaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimaryColor,
      primary: kPrimaryColor,
    ),
    useMaterial3: true,
    indicatorColor: kPrimaryColor,
    scaffoldBackgroundColor: const Color(0xFFF6F6F6),
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    elevatedButtonTheme: elevatedButtonTheme(),
    outlinedButtonTheme: outlinedButtonTheme(),
    textButtonTheme: textButtonTheme(),
    dropdownMenuTheme: dropdownMenuThemeData(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
    ),
    textSelectionTheme:
        const TextSelectionThemeData(cursorColor: kPrimaryColor),
    dialogTheme: _dialogTheme(),
  );
}

DialogTheme _dialogTheme() {
  return DialogTheme(
    surfaceTintColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

DropdownMenuThemeData dropdownMenuThemeData() {
  return DropdownMenuThemeData(
    inputDecorationTheme: inputDecorationTheme(),
    menuStyle: const MenuStyle(),
  );
}

ElevatedButtonThemeData elevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: const MaterialStatePropertyAll(Colors.black),
      foregroundColor: const MaterialStatePropertyAll(Colors.white),
      elevation: const MaterialStatePropertyAll(0),
      minimumSize: MaterialStatePropertyAll(Size(90.w, 50)),
      textStyle: const MaterialStatePropertyAll(TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 17,
      )),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    ),
  );
}

OutlinedButtonThemeData outlinedButtonTheme() {
  return OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
      foregroundColor: const MaterialStatePropertyAll(Colors.white),
      side: const MaterialStatePropertyAll(
        BorderSide(
          color: Colors.white,
          width: 1,
        ),
      ),
      elevation: const MaterialStatePropertyAll(0),
      minimumSize: MaterialStatePropertyAll(Size(90.w, 50)),
      textStyle: const MaterialStatePropertyAll(TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 17,
      )),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    ),
  );
}

TextButtonThemeData textButtonTheme() {
  return TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
      foregroundColor: const MaterialStatePropertyAll(Colors.black),
      elevation: const MaterialStatePropertyAll(0),
      minimumSize: MaterialStatePropertyAll(Size(90.w, 50)),
      textStyle: const MaterialStatePropertyAll(
        TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
          color: Colors.black,
        ),
      ),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    ),
  );
}

InputDecorationTheme inputDecorationTheme() {
  UnderlineInputBorder focusedOutlineInputBorder = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
      width: 1,
    ),
  );

  UnderlineInputBorder border = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
      width: 1,
    ),
  );

  return InputDecorationTheme(
    fillColor: Colors.transparent,
    focusColor: Colors.black,
    hintStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    labelStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    enabledBorder: border,
    focusedBorder: focusedOutlineInputBorder,
    border: border,
    filled: true,
  );
}

TextTheme textTheme() {
  return const TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
    ),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );
}
