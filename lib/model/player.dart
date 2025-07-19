import 'package:tic_tac_toe/model/game_board.dart';

enum Player { x, o }

extension PlayerExtension on Player {
  String get symbol => this == Player.x ? 'X' : 'O';
  CellState get cellState => this == Player.x ? CellState.x : CellState.o;
}