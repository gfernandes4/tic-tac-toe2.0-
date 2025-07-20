import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/providers/sound_provider.dart';
import 'package:tic_tac_toe/providers/theme_provider.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameProvider()),
        ChangeNotifierProvider(create: (context) => SoundManager()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Jogo da Velha 2.0',
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: themeProvider.themeMode,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
