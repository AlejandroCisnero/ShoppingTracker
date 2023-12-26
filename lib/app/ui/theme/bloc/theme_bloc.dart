import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shopping_tracker/app/ui/theme/shopping_themes.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(
          ThemeState(
            isDark: true,
            themeData: appThemeData[AppThemeMode.dark]!,
          ),
        ) {
    on<SwitchAppThemeEvent>(onSwitchAppThemeEvent);
  }

  void onSwitchAppThemeEvent(ThemeEvent event, Emitter<ThemeState> emit) {
    final isDark = !state.isDark;

    emit(
      state.copyWith(
        isDark: !state.isDark,
        themeData: isDark
            ? appThemeData[AppThemeMode.dark]
            : appThemeData[AppThemeMode.light],
      ),
    );
  }
}
