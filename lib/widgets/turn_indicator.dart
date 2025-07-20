import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tic_tac_toe/model/player.dart';
import '../theme.dart';

class TurnIndicator extends StatelessWidget {
  final Player currentPlayer;

  const TurnIndicator({super.key, required this.currentPlayer});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Vez de ${currentPlayer.symbol}',
          style: Theme.of(context).textTheme.headlineSmall,
        ).animate().fadeIn(duration: AppTheme.animationDuration).scale(),
        const SizedBox(width: 10),
        Icon(
          currentPlayer.symbol == 'X' ? Icons.close : Icons.circle_outlined,
          color: currentPlayer.symbol == 'X' ? AppTheme.xColor : AppTheme.oColor,
        ).animate().shake(duration: const Duration(milliseconds: 1000)),
      ],
    );
  }
}