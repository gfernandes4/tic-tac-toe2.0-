import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/model/game_board.dart';
import 'package:tic_tac_toe/providers/sound_provider.dart';
import '../providers/game_provider.dart';
import '../theme.dart';
import 'error_message.dart';

class CellWidget extends StatelessWidget {
  final int mainRow;
  final int mainCol;
  final bool isPreview;

  const CellWidget({
    super.key,
    required this.mainRow,
    required this.mainCol,
    this.isPreview = false,
  });

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final subBoard = gameProvider.board.mainBoard[mainRow][mainCol];
    final isCompleted = gameProvider.board.mainBoardCompleted[mainRow][mainCol];

    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              int row = index ~/ 3;
              int col = index % 3;
              final cellState = subBoard[row][col];

              return GestureDetector(
                onTap: isPreview || isCompleted || cellState != CellState.empty
                    ? null
                    : () {
                        if (gameProvider.forcedMainRow != null &&
                            gameProvider.forcedMainCol != null &&
                            (gameProvider.forcedMainRow != mainRow ||
                                gameProvider.forcedMainCol != mainCol)) {
                          showDialog(
                            context: context,
                            builder: (context) => ErrorMessage(
                              message: 'Jogada inválida! Jogue na célula destacada.',
                            ),
                          );
                          context.read<SoundManager>().playMove();
                          return;
                        }
                        context.read<GameProvider>().makeMove(mainRow, mainCol, row, col);
                        context.read<SoundManager>().playMove();
                        if (gameProvider.board.mainBoardCompleted[mainRow][mainCol]) {
                          context.read<SoundManager>().playSubBoardWin();
                        }
                        if (!isPreview) {
                          Navigator.pop(context);
                        }
                      },
                child: Container(
                  decoration: AppTheme.cellDecoration.copyWith(
                    color: cellState == CellState.x
                        ? AppTheme.xColor.withOpacity(0.5)
                        : cellState == CellState.o
                            ? AppTheme.oColor.withOpacity(0.5)
                            : Theme.of(context).cardColor,
                  ),
                  child: Center(
                    child: Text(
                      cellState == CellState.x
                          ? 'X'
                          : cellState == CellState.o
                              ? 'O'
                              : cellState == CellState.neutral
                                  ? '-'
                                  : '',
                      style: TextStyle(
                        fontSize: isPreview ? 14 : 24,
                        fontWeight: FontWeight.bold,
                        color: cellState == CellState.x
                            ? AppTheme.xColor
                            : cellState == CellState.o
                                ? AppTheme.oColor
                                : AppTheme.neutralColor,
                      ),
                    ),
                  ),
                ).animate().scale(
                      duration: cellState != CellState.empty ? AppTheme.animationDuration : Duration.zero,
                      curve: Curves.easeOut,
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}