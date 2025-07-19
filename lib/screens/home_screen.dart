import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Velha 2.0'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              child: const Text('Novo Jogo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
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
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Fechar'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Instruções'),
            ),
          ],
        ),
      ),
    );
  }
}