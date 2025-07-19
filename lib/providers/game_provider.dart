import 'package:flutter/material.dart';
import 'package:tic_tac_toe/model/player.dart';
import '../model/player.dart';
import '../model/game_board.dart';

class GameProvider with ChangeNotifier {
  GameBoard _board = GameBoard();
  Player _currentPlayer = Player.x;
  int? _forcedMainRow;
  int? _forcedMainCol;
  bool _gameEnded = false;
  String? _winner;

  GameBoard get board => _board;
  Player get currentPlayer => _currentPlayer;
  int? get forcedMainRow => _forcedMainRow;
  int? get forcedMainCol => _forcedMainCol;
  bool get gameEnded => _gameEnded;
  String? get winner => _winner;

  void makeMove(int mainRow, int mainCol, int subRow, int subCol) {
    // Valida a jogada
    if (_gameEnded ||
        _board.mainBoardCompleted[mainRow][mainCol] ||
        _board.mainBoard[mainRow][mainCol][subRow][subCol] != CellState.empty ||
        (_forcedMainRow != null &&
            _forcedMainCol != null &&
            (mainRow != _forcedMainRow || mainCol != _forcedMainCol))) {
      return; // Jogada inválida
    }

    // Registra a jogada
    _board.mainBoard[mainRow][mainCol][subRow][subCol] = _currentPlayer.cellState;

    // Verifica vitória na matriz secundária
    bool subBoardCompleted = _board.checkSubBoardWin(mainRow, mainCol);

    // Verifica vitória na matriz principal ou empate
    if (subBoardCompleted) {
      if (_board.checkMainBoardWin()) {
        _gameEnded = true;
        if (_board.mainBoardState.any((row) =>
            row.any((cell) =>
                cell != CellState.empty && cell != CellState.neutral))) {
          _winner = _currentPlayer.symbol;
        } else {
          _winner = 'Empate';
        }
      }
    }

    // Define a próxima célula forçada ou permite jogada livre
    if (_board.mainBoardCompleted[subRow][subCol]) {
      _forcedMainRow = null;
      _forcedMainCol = null;
    } else {
      _forcedMainRow = subRow;
      _forcedMainCol = subCol;
    }

    // Alterna o jogador
    _currentPlayer = _currentPlayer == Player.x ? Player.o : Player.x;
    notifyListeners();
  }

  void resetGame() {
    _board = GameBoard();
    _currentPlayer = Player.x;
    _forcedMainRow = null;
    _forcedMainCol = null;
    _gameEnded = false;
    _winner = null;
    notifyListeners();
  }
}