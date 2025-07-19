import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/model/game_board.dart';
import '../providers/game_provider.dart';
import 'cell_widget.dart';

class BoardWidget extends StatelessWidget {
  final int? forcedMainRow;
  final int? forcedMainCol;

  const BoardWidget({
    super.key,
    this.forcedMainRow,
    this.forcedMainCol,
  });

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final board = gameProvider.board;

    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            int row = index ~/ 3;
            int col = index % 3;
            bool isForced = forcedMainRow == row && forcedMainCol == col;

            return GestureDetector(
              onTap: board.mainBoardCompleted[row][col]
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Matriz ${row + 1}x${col + 1}',
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                CellWidget(mainRow: row, mainCol: col),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Fechar'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isForced ? Colors.yellow : Colors.grey,
                    width: isForced ? 4.0 : 2.0,
                  ),
                  color: board.mainBoardState[row][col] == CellState.x
                      ? Colors.blue.withOpacity(0.2)
                      : board.mainBoardState[row][col] == CellState.o
                          ? Colors.red.withOpacity(0.2)
                          : board.mainBoardState[row][col] == CellState.neutral
                              ? Colors.grey.withOpacity(0.2)
                              : null,
                ),
                child: CellWidget(mainRow: row, mainCol: col, isPreview: true),
              ),
            );
          },
        ),
      ),
    );
  }
}