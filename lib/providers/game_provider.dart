import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/model/player.dart';
import '../model/game_board.dart';

class GameProvider with ChangeNotifier {
  GameBoard _board = GameBoard();
  Player _currentPlayer = Player.x;
  int? _forcedMainRow;
  int? _forcedMainCol;
  bool _gameEnded = false;
  String? _winner;
  bool _isVsAI = false;
  String _difficulty = 'Fácil';
  late AIPlayer _aiPlayer;

  GameBoard get board => _board;
  Player get currentPlayer => _currentPlayer;
  int? get forcedMainRow => _forcedMainRow;
  int? get forcedMainCol => _forcedMainCol;
  bool get gameEnded => _gameEnded;
  String? get winner => _winner;
  bool get isVsAI => _isVsAI;
  String get difficulty => _difficulty;

  GameProvider() {
    _aiPlayer = AIPlayer(this);
  }

  void setGameMode(bool vsAI, {String difficulty = 'Fácil'}) {
    _isVsAI = vsAI;
    _difficulty = difficulty;
    if (_isVsAI && _currentPlayer == Player.o) {
      _makeAIMove();
    }
    notifyListeners();
  }

  void makeMove(int mainRow, int mainCol, int subRow, int subCol) {
    if (_gameEnded ||
        _board.mainBoardCompleted[mainRow][mainCol] ||
        _board.mainBoard[mainRow][mainCol][subRow][subCol] != CellState.empty ||
        (_forcedMainRow != null &&
            _forcedMainCol != null &&
            (mainRow != _forcedMainRow || mainCol != _forcedMainCol))) {
      return;
    }

    _board.mainBoard[mainRow][mainCol][subRow][subCol] = _currentPlayer.cellState;

    bool subBoardCompleted = _board.checkSubBoardWin(mainRow, mainCol);

    if (subBoardCompleted) {
      if (_board.checkMainBoardWin()) {
        _gameEnded = true;
        _winner = _board.mainBoardState.any((row) =>
                row.any((cell) => cell != CellState.empty && cell != CellState.neutral))
            ? _currentPlayer.symbol
            : 'Empate';
      }
    }

    if (_board.mainBoardCompleted[subRow][subCol]) {
      _forcedMainRow = null;
      _forcedMainCol = null;
    } else {
      _forcedMainRow = subRow;
      _forcedMainCol = subCol;
    }

    _currentPlayer = _currentPlayer == Player.x ? Player.o : Player.x;

    if (_isVsAI && !_gameEnded && _currentPlayer == Player.o) {
      _makeAIMove();
    }

    notifyListeners();
  }

  void _makeAIMove() {
    Timer(const Duration(milliseconds: 1000), () {
      final move = _aiPlayer.getBestMove(_difficulty);
      if (move != null) {
        makeMove(move['mainRow']!, move['mainCol']!, move['subRow']!, move['subCol']!);
      }
    });
  }

  void resetGame() {
    _board = GameBoard();
    _currentPlayer = Player.x;
    _forcedMainRow = null;
    _forcedMainCol = null;
    _gameEnded = false;
    _winner = null;
    if (_isVsAI && _currentPlayer == Player.o) {
      _makeAIMove();
    }
    notifyListeners();
  }
}

class AIPlayer {
  final GameProvider _gameProvider;
  final Random _random = Random();

  AIPlayer(this._gameProvider);

  Map<String, int>? getBestMove(String difficulty) {
    final board = _gameProvider._board;
    final currentPlayer = _gameProvider._currentPlayer;
    int? forcedMainRow = _gameProvider._forcedMainRow;
    int? forcedMainCol = _gameProvider._forcedMainCol;

    if (difficulty == 'Fácil') {
      List<Map<String, int>> possibleMoves = [];
      for (int mainRow = 0; mainRow < 3; mainRow++) {
        for (int mainCol = 0; mainCol < 3; mainCol++) {
          if (!board.mainBoardCompleted[mainRow][mainCol] &&
              (forcedMainRow == null || (mainRow == forcedMainRow && mainCol == forcedMainCol))) {
            for (int subRow = 0; subRow < 3; subRow++) {
              for (int subCol = 0; subCol < 3; subCol++) {
                if (board.mainBoard[mainRow][mainCol][subRow][subCol] == CellState.empty) {
                  possibleMoves.add({
                    'mainRow': mainRow,
                    'mainCol': mainCol,
                    'subRow': subRow,
                    'subCol': subCol
                  });
                }
              }
            }
          }
        }
      }
      return possibleMoves.isNotEmpty ? possibleMoves[_random.nextInt(possibleMoves.length)] : null;
    }

    int depth = calculateDepth(difficulty);
    int alpha = -10000;
    int beta = 10000;

    int bestScore = -10000;
    Map<String, int>? bestMove;

    List<Map<String, int>> moves = getOrderedMoves(board, forcedMainRow, forcedMainCol);

    for (var move in moves) {
      int mainRow = move['mainRow']!;
      int mainCol = move['mainCol']!;
      int subRow = move['subRow']!;
      int subCol = move['subCol']!;
      
      board.mainBoard[mainRow][mainCol][subRow][subCol] = currentPlayer.cellState;
      bool subBoardCompleted = board.checkSubBoardWin(mainRow, mainCol);
      int score = minimax(depth - 1, false, board, currentPlayer, alpha, beta, subRow, subCol);
      board.mainBoard[mainRow][mainCol][subRow][subCol] = CellState.empty;
      if (subBoardCompleted) {
        board.mainBoardState[mainRow][mainCol] = CellState.empty;
        board.mainBoardCompleted[mainRow][mainCol] = false;
      }

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
      alpha = max(alpha, score);
      if (beta <= alpha) break;
    }
    return bestMove;
  }

  List<Map<String, int>> getOrderedMoves(GameBoard board, int? forcedMainRow, int? forcedMainCol) {
    List<Map<String, int>> moves = [];
    List<List<int>> priorityOrder = [
      [1, 1], [0, 0], [0, 2], [2, 0], [2, 2], [0, 1], [1, 0], [1, 2], [2, 1]
    ];

    for (var pos in priorityOrder) {
      int mainRow = pos[0];
      int mainCol = pos[1];
      if (!board.mainBoardCompleted[mainRow][mainCol] &&
          (forcedMainRow == null || (mainRow == forcedMainRow && mainCol == forcedMainCol))) {
        for (int subRow = 0; subRow < 3; subRow++) {
          for (int subCol = 0; subCol < 3; subCol++) {
            if (board.mainBoard[mainRow][mainCol][subRow][subCol] == CellState.empty) {
              moves.add({
                'mainRow': mainRow,
                'mainCol': mainCol,
                'subRow': subRow,
                'subCol': subCol
              });
            }
          }
        }
      }
    }
    return moves;
  }

  int calculateDepth(String difficulty) {
    switch (difficulty) {
      case 'Fácil':
        return 0;
      case 'Médio':
        return 6;
      case 'Difícil':
        return 10;
      default:
        return 0;
    }
  }

  int minimax(int depth, bool isMaximizing, GameBoard board, Player currentPlayer, int alpha, int beta, int nextMainRow, int nextMainCol) {
    if (depth == 0 || board.checkMainBoardWin()) {
      return evaluateBoard(board, currentPlayer);
    }

    if (isMaximizing) {
      int bestScore = -10000;
      List<Map<String, int>> moves = getOrderedMoves(board, nextMainRow, nextMainCol);
      for (var move in moves) {
        int mainRow = move['mainRow']!;
        int mainCol = move['mainCol']!;
        int subRow = move['subRow']!;
        int subCol = move['subCol']!;
        
        board.mainBoard[mainRow][mainCol][subRow][subCol] = currentPlayer.cellState;
        bool subBoardCompleted = board.checkSubBoardWin(mainRow, mainCol);
        int score = minimax(depth - 1, false, board, currentPlayer == Player.x ? Player.o : Player.x, alpha, beta, subRow, subCol);
        board.mainBoard[mainRow][mainCol][subRow][subCol] = CellState.empty;
        if (subBoardCompleted) {
          board.mainBoardState[mainRow][mainCol] = CellState.empty;
          board.mainBoardCompleted[mainRow][mainCol] = false;
        }
        
        bestScore = max(bestScore, score);
        alpha = max(alpha, score);
        if (beta <= alpha) break;
      }
      return bestScore;
    } else {
      int bestScore = 10000;
      List<Map<String, int>> moves = getOrderedMoves(board, nextMainRow, nextMainCol);
      for (var move in moves) {
        int mainRow = move['mainRow']!;
        int mainCol = move['mainCol']!;
        int subRow = move['subRow']!;
        int subCol = move['subCol']!;
        
        board.mainBoard[mainRow][mainCol][subRow][subCol] = currentPlayer == Player.x ? CellState.o : CellState.x;
        bool subBoardCompleted = board.checkSubBoardWin(mainRow, mainCol);
        int score = minimax(depth - 1, true, board, currentPlayer == Player.x ? Player.o : Player.x, alpha, beta, subRow, subCol);
        board.mainBoard[mainRow][mainCol][subRow][subCol] = CellState.empty;
        if (subBoardCompleted) {
          board.mainBoardState[mainRow][mainCol] = CellState.empty;
          board.mainBoardCompleted[mainRow][mainCol] = false;
        }
        
        bestScore = min(bestScore, score);
        beta = min(beta, score);
        if (beta <= alpha) break;
      }
      return bestScore;
    }
  }

  int evaluateBoard(GameBoard board, Player currentPlayer) {
    if (board.checkMainBoardWin()) {
      bool aiWins = board.mainBoardState.any((row) =>
          row.any((cell) => cell == CellState.o && cell != CellState.neutral));
      return aiWins ? 1000 : -1000;
    }

    int score = 0;

    score += evaluateMatrix(board.mainBoardState, CellState.o) * 100;
    score -= evaluateMatrix(board.mainBoardState, CellState.x) * 100;

    for (int mainRow = 0; mainRow < 3; mainRow++) {
      for (int mainCol = 0; mainCol < 3; mainCol++) {
        if (!board.mainBoardCompleted[mainRow][mainCol]) {
          int subScoreO = evaluateMatrix(board.mainBoard[mainRow][mainCol], CellState.o);
          int subScoreX = evaluateMatrix(board.mainBoard[mainRow][mainCol], CellState.x);
          score += subScoreO * 10;
          score -= subScoreX * 10;
          if (mainRow == 1 && mainCol == 1) {
            score += subScoreO * 5;
            score -= subScoreX * 5;
          }
        }
      }
    }

    return score;
  }

  int evaluateMatrix(List<List<CellState>> matrix, CellState player) {
    int score = 0;

    for (int row = 0; row < 3; row++) {
      score += evaluateLine(matrix[row], player);
    }

    for (int col = 0; col < 3; col++) {
      List<CellState> column = [matrix[0][col], matrix[1][col], matrix[2][col]];
      score += evaluateLine(column, player);
    }

    List<CellState> diag1 = [matrix[0][0], matrix[1][1], matrix[2][2]];
    List<CellState> diag2 = [matrix[0][2], matrix[1][1], matrix[2][0]];
    score += evaluateLine(diag1, player);
    score += evaluateLine(diag2, player);

    return score;
  }

  int evaluateLine(List<CellState> line, CellState player) {
    int playerCount = line.where((cell) => cell == player).length;
    int emptyCount = line.where((cell) => cell == CellState.empty).length;
    CellState opponent = player == CellState.o ? CellState.x : CellState.o;
    int opponentCount = line.where((cell) => cell == opponent).length;

    if (playerCount == 3) return 100;
    if (opponentCount == 2 && emptyCount == 1) return -50;
    if (playerCount == 2 && emptyCount == 1) return 20;
    if (playerCount == 1 && emptyCount == 2) return 5;
    return 0;
  }
}