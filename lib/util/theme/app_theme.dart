import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uboyniy_cex/util/util.dart';

class AppTheme {
  TextTheme textTheme() => GoogleFonts.robotoCondensedTextTheme();
  ThemeData get light {
    return ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.seedLight,
      ),
      textTheme: textTheme(),
      brightness: Brightness.dark,
    );
  }

  ThemeData get dark {
    return ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: AppColors.seedDark,
      ),
      textTheme: textTheme(),
      brightness: Brightness.dark,
    );
  }
}

extension ThemContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
}
