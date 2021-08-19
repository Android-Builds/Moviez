import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  accentColor: Colors.red[300],
  textTheme: GoogleFonts.montserratTextTheme(
    ThemeData.light().textTheme,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    color: Colors.white,
    iconTheme: iconTheme,
    textTheme: GoogleFonts.montserratTextTheme(
      ThemeData.light().textTheme,
    ),
  ),
  tabBarTheme: TabBarTheme(
    labelStyle: GoogleFonts.montserrat(),
    labelColor: Colors.red[300],
    unselectedLabelColor: Colors.black,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: Colors.red.shade300,
        width: 2.0,
      ),
    ),
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  cardColor: Colors.grey[900],
  accentColor: Colors.red[300],
  backgroundColor: Colors.grey[900],
  visualDensity: VisualDensity.adaptivePlatformDensity,
  canvasColor: Colors.black,
  textTheme: GoogleFonts.montserratTextTheme(
    ThemeData.dark().textTheme,
  ),
  scaffoldBackgroundColor: Colors.black,
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.grey[900],
  ),
  appBarTheme: AppBarTheme(
    color: Colors.black,
    textTheme: GoogleFonts.montserratTextTheme(
      ThemeData.dark().textTheme,
    ),
    iconTheme: iconTheme,
  ),
  tabBarTheme: TabBarTheme(
    labelStyle: GoogleFonts.montserrat(),
    labelColor: Colors.red[300],
    unselectedLabelColor: Colors.white,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: Colors.red.shade300,
        width: 2.0,
      ),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(color: Colors.black),
  dialogBackgroundColor: Colors.black,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey[900],
    actionTextColor: Colors.red[300],
    contentTextStyle: TextStyle(
      color: Colors.white,
    ),
  ),
);

IconThemeData iconTheme = IconThemeData(color: Colors.red[300]);
