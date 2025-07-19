import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/model/game_board.dart';
import '../providers/game_provider.dart';

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
      child: GridView.builder(
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Jogada inválida! Jogue na célula destacada.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    gameProvider.makeMove(mainRow, mainCol, row, col);
                    if (!isPreview) {
                      Navigator.pop(context); // Fecha o dialog após a jogada
                    }
                  },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: cellState == CellState.x
                    ? Colors.blue.withOpacity(0.5)
                    : cellState == CellState.o
                        ? Colors.red.withOpacity(0.5)
                        : null,
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
                        ? Colors.blue
                        : cellState == CellState.o
                            ? Colors.red
                            : Colors.grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}