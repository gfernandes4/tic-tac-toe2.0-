import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/model/game_board.dart';
import 'package:tic_tac_toe/theme.dart';
import 'package:tic_tac_toe/widgets/dialog_container.dart';
import '../providers/game_provider.dart';
import 'cell_widget.dart';

class BoardWidget extends StatelessWidget {
  final int? forcedMainRow;
  final int? forcedMainCol;
  final double maxSize;
  final bool isTablet;

  const BoardWidget({
    super.key,
    this.forcedMainRow,
    this.forcedMainCol,
    required this.maxSize,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final board = gameProvider.board;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcula o tamanho do tabuleiro
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;
        final size = isTablet
            ? (availableWidth > availableHeight
                ? availableWidth * 0.9
                : availableHeight)
            : (availableWidth < availableHeight
                ? availableWidth
                : availableHeight).clamp(0.0, maxSize);

        return Center(
          child: Container(
            width: size,
            height: size,
            margin: EdgeInsets.all(size * (isTablet ? 0.02 : 0.05)),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: isTablet ? 12.0 : 8.0,
                mainAxisSpacing: isTablet ? 12.0 : 8.0,
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
                            builder: (context) => DialogContainer(
                              mainRow: row,
                              mainCol: col,
                              onClose: () => Navigator.pop(context),
                            ),
                          );
                        },
                  child: Container(
                    decoration: AppTheme.boardCellDecoration.copyWith(
                      border: isForced
                          ? Border.all(
                              color: AppTheme.forcedBorderColor,
                              width: 4.0,
                            )
                          : Border.all(
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey
                                  : Colors.grey[700]!,
                              width: 1.0,
                            ),
                      color: board.mainBoardState[row][col] == CellState.x
                          ? AppTheme.xColor.withOpacity(0.2)
                          : board.mainBoardState[row][col] == CellState.o
                              ? AppTheme.oColor.withOpacity(0.2)
                              : board.mainBoardState[row][col] ==
                                      CellState.neutral
                                  ? AppTheme.neutralColor.withOpacity(0.2)
                                  : Theme.of(context).cardColor,
                    ),
                    child: CellWidget(
                        mainRow: row, mainCol: col, isPreview: true),
                  ).animate(
                    effects: isForced
                        ? [
                            ScaleEffect(
                              begin: const Offset(1.0, 1.0),
                              end: const Offset(1.05, 1.05),
                              duration: 500.ms,
                              curve: Curves.easeInOut,
                            ),
                          ]
                        : [],
                    autoPlay: isForced,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}