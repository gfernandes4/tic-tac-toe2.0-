import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/model/player.dart';
import '../providers/game_provider.dart';
import '../widgets/board_widget.dart';
import 'result_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Velha 2.0'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<GameProvider>().resetGame();
            },
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          if (gameProvider.gameEnded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(winner: gameProvider.winner),
                ),
              );
            });
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Vez de ${gameProvider.currentPlayer.symbol}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Center(
                  child: BoardWidget(
                    forcedMainRow: gameProvider.forcedMainRow,
                    forcedMainCol: gameProvider.forcedMainCol,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}