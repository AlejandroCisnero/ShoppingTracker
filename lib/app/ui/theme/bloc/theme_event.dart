part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class SwitchAppThemeEvent extends ThemeEvent {
  const SwitchAppThemeEvent();
  @override
  List<Object> get props => [];
}
