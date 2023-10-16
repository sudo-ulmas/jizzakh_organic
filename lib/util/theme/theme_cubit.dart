import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void switchThemes() =>
      emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);

  @override
  ThemeMode fromJson(Map<String, dynamic> json) =>
      (json['value'] as String) == 'dark' ? ThemeMode.dark : ThemeMode.light;

  @override
  Map<String, String> toJson(ThemeMode state) => {'value': state.name};
}
