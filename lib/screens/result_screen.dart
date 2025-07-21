import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';
import 'game_screen.dart';

// Convertendo para StatefulWidget para gerenciar o ConfettiController
class ResultScreen extends StatefulWidget {
  final String? winner;

  const ResultScreen({super.key, required this.winner});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    // Reproduz os confetes apenas se houver um vencedor (não empate e não nulo)
    if (widget.winner != null && widget.winner != 'Empate') {
      _confettiController.play();
      // Opcional: Tocar um som de vitória
      // context.read<SoundManager>().playWinSound(); // Você precisaria implementar playWinSound() no SoundManager
    } else if (widget.winner == 'Empate') {
      // Opcional: Tocar um som de empate
      // context.read<SoundManager>().playDrawSound(); // Você precisaria implementar playDrawSound() no SoundManager
    }
  }

  @override
  void dispose() {
    _confettiController.dispose(); // Libera os recursos do controlador de confetes
    super.dispose();
  }

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
        title: const Text('Fim de Jogo'),
      ),
      body: Stack( // Usamos Stack para sobrepor os confetes sobre o conteúdo
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.winner == null
                        ? 'Jogo Encerrado!'
                        : widget.winner == 'Empate'
                            ? 'Empate!'
                            : '${widget.winner} Venceu!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                      .animate()
                      .fadeIn(duration: AppTheme.animationDuration)
                      .scale()
                      // Adicionando efeito de tremer. Ajuste 'hz' e 'amount' para o nível de vibração.
                      .shake(
                        hz: 2, // Frequência da vibração (quantas vezes treme)
                        duration: const Duration(milliseconds: 500), // Duração do efeito
                        offset: Offset(5, 0), // Deslocamento horizontal (tremer mais para os lados)
                      ),
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
          ),
          // Widget de Confetes - Posicionado no topo da Stack para aparecer sobre todo o conteúdo
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive, // Confetes explodem para todas as direções
              shouldLoop: false, // Não repete a animação
              colors: const [ // Cores dos confetes
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
              //createParticlePath: (size) {
                // Opcional: Você pode criar um caminho de partícula personalizado aqui
                // Por exemplo, para ter partículas em forma de estrela ou coração
                //return Path.fromRect(Rect.fromLTWH(0, 0, 10, 10)); // Partículas quadradas simples
          //    },
            ),
          ),
        ],
      ),
    );
  }
}
