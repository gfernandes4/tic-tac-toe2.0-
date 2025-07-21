//cria a estrutura do appBar
import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextStyle titleTextStyle;
  final List<Widget> actions;

  const CustomAppBar(
      {super.key, required this.title, required this.titleTextStyle, required this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      titleTextStyle: titleTextStyle,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      actions: [
        IconButton(
          icon: Icon(
            context.watch<ThemeProvider>().isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () {
            context
                .read<ThemeProvider>()
                .toggleTheme(!context.watch<ThemeProvider>().isDarkMode);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
