import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_tracker/app/ui/theme/bloc/theme_bloc.dart';
import 'package:shopping_tracker/l10n/l10n.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Route<void> route() {
    return CupertinoPageRoute(
      builder: (context) => const SettingsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(l10n.settingsAppBarTitle),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Column(
          children: [
            BlocSelector<ThemeBloc, ThemeState, bool>(
              selector: (state) {
                return state.isDark;
              },
              builder: (context, isDark) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedCrossFade(
                      firstChild: const Icon(Icons.light_mode),
                      secondChild: const Icon(Icons.dark_mode),
                      crossFadeState: isDark
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 500),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      l10n.darkModeOption,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Expanded(child: SizedBox.shrink()),
                    CupertinoSwitch(
                      value: isDark,
                      onChanged: (value) {
                        context.read<ThemeBloc>().add(
                              const SwitchAppThemeEvent(),
                            );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
