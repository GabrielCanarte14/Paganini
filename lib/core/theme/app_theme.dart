import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:paganini_wallet/core/theme/extensions/responsive_size.dart';
import 'package:paganini_wallet/core/constants/colors.dart';

const colorSeed = primaryColor;
const scaffoldBackgroundColor = Color.fromARGB(255, 248, 248, 248);

class AppTheme {
  ThemeData getTheme(BuildContext context) => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: colorSeed,

        ///* Texts
        textTheme: TextTheme(
          titleLarge: GoogleFonts.rubik().copyWith(
            fontSize: 30.rf(context),
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 45, 49),
          ),
          titleMedium: GoogleFonts.rubik().copyWith(
            fontSize: 20.rf(context),
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 45, 49),
          ),
          titleSmall: GoogleFonts.rubik().copyWith(
            fontSize: 15.rf(context),
            color: const Color.fromARGB(255, 0, 45, 49),
          ),
          bodyLarge: GoogleFonts.rubik().copyWith(
            fontSize: 20.rf(context),
            color: const Color.fromARGB(255, 0, 45, 49),
          ),
          bodyMedium: GoogleFonts.rubik().copyWith(
            fontSize: 15.rf(context),
            color: const Color.fromARGB(255, 0, 45, 49),
          ),
          bodySmall: GoogleFonts.rubik().copyWith(
            fontSize: 12.rf(context),
            color: const Color.fromARGB(255, 0, 45, 49),
          ),
        ),

        ///* Scaffold Background Color
        scaffoldBackgroundColor: scaffoldBackgroundColor,

        ///* Buttons
        filledButtonTheme: FilledButtonThemeData(
            style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(GoogleFonts.rubik()
                    .copyWith(fontWeight: FontWeight.w700)))),

        ///* AppBar
        appBarTheme: AppBarTheme(
          color: scaffoldBackgroundColor,
          titleTextStyle: GoogleFonts.rubik().copyWith(
            fontSize: 25.rf(context),
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 45, 49),
          ),

          ///* AppBar Icons
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 0, 45, 49),
          ),
        ),
      );
}
