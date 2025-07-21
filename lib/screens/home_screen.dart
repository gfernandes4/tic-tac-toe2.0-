import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/providers/game_provider.dart';
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
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        title: const Text('Jogo da Velha 2.0'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) => Row(
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Consumer<SoundManager>(
            builder: (context, soundManager, child) => IconButton(
              icon: Icon(
                soundManager.isSoundEnabled ? Icons.volume_up : Icons.volume_off,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                soundManager.toggleSound();
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'Jogador vs Jogador',
                      onPressed: () {
                        context.read<GameProvider>().setGameMode(false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GameScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Jogador vs IA',
                      onPressed: () {
                        _showDifficultyDialog(context);
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolha a Dificuldade'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Fácil'),
              onTap: () {
                context.read<GameProvider>().setGameMode(true, difficulty: 'Fácil');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Médio'),
              onTap: () {
                context.read<GameProvider>().setGameMode(true, difficulty: 'Médio');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Difícil'),
              onTap: () {
                context.read<GameProvider>().setGameMode(true, difficulty: 'Difícil');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}