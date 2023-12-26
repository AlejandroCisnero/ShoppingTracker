part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({required this.isDark, required this.themeData});

  final bool isDark;

  final ThemeData themeData;

  ThemeState copyWith({bool? isDark, ThemeData? themeData}) {
    return ThemeState(
      isDark: isDark ?? this.isDark,
      themeData: themeData ?? this.themeData,
    );
  }

  @override
  List<Object> get props => [isDark, themeData];
}
