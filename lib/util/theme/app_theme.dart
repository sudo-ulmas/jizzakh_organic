import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  TextTheme textTheme() => GoogleFonts.robotoCondensedTextTheme();
  ThemeData get light {
    return ThemeData.light(useMaterial3: true).copyWith(
      textTheme: textTheme(),
      brightness: Brightness.dark,
    );
  }

  ThemeData get dark {
    return ThemeData.dark(useMaterial3: true).copyWith(
      textTheme: textTheme(),
      brightness: Brightness.dark,
    );
  }
}

extension ThemContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
}
