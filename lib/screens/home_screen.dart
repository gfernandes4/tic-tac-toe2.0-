import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/providers/sound_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_button.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Velha 2.0'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Switch de tema logo abaixo do AppBar
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.light_mode, color: themeProvider.isDarkMode ? Colors.grey : Colors.yellow),
                    Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                    ),
                    Icon(Icons.dark_mode, color: themeProvider.isDarkMode ? Colors.blue : Colors.grey),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Novo Jogo',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Instruções',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Instruções'),
                      content: const Text(
                        'Jogo da Velha 2.0:\n'
                        '- Jogue em uma matriz 3x3, onde cada célula tem um mini jogo da velha.\n'
                        '- O próximo jogador joga na célula correspondente à última jogada do adversário.\n'
                        '- Ganhe uma célula completando uma linha, coluna ou diagonal no mini jogo.\n'
                        '- Ganhe o jogo alinhando 3 células na matriz principal.\n'
                        '- Empate ocorre se todas as células forem preenchidas sem vencedor.',
                      ),
                      actions: [
                        CustomButton(
                          text: 'Fechar',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Consumer<SoundManager>(
                builder: (context, soundManager, child) => CustomButton(
                  text: soundManager.isSoundEnabled
                      ? 'Desativar Som'
                      : 'Ativar Som',
                  onPressed: () {
                    soundManager.toggleSound();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
