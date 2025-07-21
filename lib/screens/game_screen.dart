import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/model/player.dart';
import 'package:tic_tac_toe/providers/sound_provider.dart';
import '../providers/game_provider.dart';
import '../widgets/board_widget.dart';
import 'result_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final shouldReset = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reiniciar Jogo'),
                  content:
                      const Text('Tem certeza que deseja reiniciar o jogo?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Reiniciar'),
                    ),
                  ],
                ),
              );
              if (shouldReset == true) {
                context.read<GameProvider>().resetGame();
              }
            },
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          if (gameProvider.gameEnded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<SoundManager>().playGameEnd(gameProvider.winner);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ResultScreen(winner: gameProvider.winner),
                ),
              );
            });
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = MediaQuery.of(context).size.width > 600;
              final maxHeight = constraints.maxHeight *
                  (isTablet ? 0.9 : 0.8); // Mais espaço em tablets

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Vez de ${gameProvider.currentPlayer.symbol}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ).animate().fadeIn(duration: 500.ms).scale(),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: BoardWidget(
                        forcedMainRow: gameProvider.forcedMainRow,
                        forcedMainCol: gameProvider.forcedMainCol,
                        maxSize: maxHeight,
                        isTablet: isTablet,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
