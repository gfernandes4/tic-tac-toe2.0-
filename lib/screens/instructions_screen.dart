import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instruções'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Regras do Jogo da Velha 2.0',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '1. O jogo é jogado em uma matriz 3x3 principal, onde cada célula contém um mini jogo da velha 3x3.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '2. Dois jogadores (X e O) jogam alternadamente. O primeiro jogador escolhe uma célula na matriz principal e uma posição na matriz secundária.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '3. A posição escolhida na matriz secundária determina a célula da matriz principal onde o próximo jogador deve jogar.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '4. Se um jogador completar uma linha, coluna ou diagonal em uma matriz secundária, ele conquista essa célula na matriz principal (marcada com X ou O).',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '5. Se uma matriz secundária ficar cheia sem vencedor, ela é marcada como neutra ("-") e pode ser usada como coringa.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '6. Se a célula da matriz principal indicada já estiver concluída (vencedor ou neutra), o jogador pode escolher qualquer célula não concluída.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '7. O jogo termina quando um jogador conquista 3 células alinhadas (linha, coluna ou diagonal) na matriz principal, ou quando todas as células estão preenchidas sem vencedor (empate).',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}