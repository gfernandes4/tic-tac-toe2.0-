import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';
import 'game_screen.dart';

class ResultScreen extends StatelessWidget {
  final String? winner;

  const ResultScreen({super.key, required this.winner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fim de Jogo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              winner == null
                  ? 'Jogo Encerrado!'
                  : winner == 'Empate'
                      ? 'Empate!'
                      : '$winner Venceu!',
              style: Theme.of(context).textTheme.headlineSmall,
            ).animate().fadeIn(duration: AppTheme.animationDuration).scale(),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Novo Jogo',
              onPressed: () {
                context.read<GameProvider>().resetGame();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Voltar ao Menu',
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ).animate().fadeIn(duration: AppTheme.animationDuration * 1.5),
      ),
    );
  }
}