import 'package:flutter/material.dart';

class GameModel extends ChangeNotifier {
  // Matriz principal: cada célula contém uma matriz secundária 3x3
  List<List<List<String?>>> mainBoard = List.generate(
    3,
    (_) => List.generate(3, (_) => List.filled(9, null)),
  );
  // Estado da matriz principal: null (não concluída), 'X', 'O', ou 'neutra'
  List<List<String?>> mainBoardStatus = List.generate(
    3,
    (_) => List.filled(3, null),
  );
  String currentPlayer = 'X';
  String? forcedMainCell; // Célula obrigatória na matriz principal
  bool gameEnded = false;
  String? winner;

  // Faz uma jogada
  void makeMove(int mainRow, int mainCol, int subRow, int subCol) {
    if (gameEnded || mainBoard[mainRow][mainCol][subRow * 3 + subCol] != null) {
      return; // Jogada inválida
    }

    // Verifica se a célula da matriz principal é válida
    if (forcedMainCell != null) {
      var forcedRow = int.parse(forcedMainCell!.split(',')[0]);
      var forcedCol = int.parse(forcedMainCell!.split(',')[1]);
      if (mainRow != forcedRow || mainCol != forcedCol) {
        // Verifica se a célula está concluída e permite jogada livre
        if (mainBoardStatus[forcedRow][forcedCol] != null) {
          if (mainBoardStatus[mainRow][mainCol] != null) return;
        } else {
          return;
        }
      }
    } else if (mainBoardStatus[mainRow][mainCol] != null) {
      return; // Célula já concluída
    }

    // Marca a jogada
    mainBoard[mainRow][mainCol][subRow * 3 + subCol] = currentPlayer;
    notifyListeners();

    // Verifica vitória na matriz secundária
    if (_checkSubBoardWin(mainRow, mainCol)) {
      mainBoardStatus[mainRow][mainCol] = currentPlayer;
    } else if (_isSubBoardFull(mainRow, mainCol)) {
      mainBoardStatus[mainRow][mainCol] = 'neutra';
    }

    // Verifica vitória na matriz principal
    if (_checkMainBoardWin()) {
      gameEnded = true;
      winner = currentPlayer;
      notifyListeners();
      return;
    }

    // Verifica empate na matriz principal
    if (_isMainBoardFull()) {
      gameEnded = true;
      winner = null; // Empate
      notifyListeners();
      return;
    }

    // Define a próxima célula obrigatória
    forcedMainCell = '$subRow,$subCol';
    if (mainBoardStatus[subRow][subCol] != null) {
      forcedMainCell = null; // Jogada livre
    }

    // Alterna jogador
    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    notifyListeners();
  }

  // Verifica vitória na matriz secundária
  bool _checkSubBoardWin(int mainRow, int mainCol) {
    var board = mainBoard[mainRow][mainCol];
    // Linhas
    for (int i = 0; i < 3; i++) {
      if (board[i * 3] != null &&
          board[i * 3] == board[i * 3 + 1] &&
          board[i * 3 + 1] == board[i * 3 + 2]) {
        return true;
      }
    }
    // Colunas
    for (int i = 0; i < 3; i++) {
      if (board[i] != null &&
          board[i] == board[i + 3] &&
          board[i + 3] == board[i + 6]) {
        return true;
      }
    }
    // Diagonais
    if (board[0] != null && board[0] == board[4] && board[4] == board[8]) {
      return true;
    }
    if (board[2] != null && board[2] == board[4] && board[4] == board[6]) {
      return true;
    }
    return false;
  }

  // Verifica se a matriz secundária está cheia
  bool _isSubBoardFull(int mainRow, int mainCol) {
    return mainBoard[mainRow][mainCol].every((cell) => cell != null);
  }

  // Verifica vitória na matriz principal
  bool _checkMainBoardWin() {
    // Linhas
    for (int i = 0; i < 3; i++) {
      if (mainBoardStatus[i][0] != null &&
          mainBoardStatus[i][0] != 'neutra' &&
          mainBoardStatus[i][0] == mainBoardStatus[i][1] &&
          mainBoardStatus[i][1] == mainBoardStatus[i][2]) {
        return true;
      }
    }
    // Colunas
    for (int i = 0; i < 3; i++) {
      if (mainBoardStatus[0][i] != null &&
          mainBoardStatus[0][i] != 'neutra' &&
          mainBoardStatus[0][i] == mainBoardStatus[1][i] &&
          mainBoardStatus[1][i] == mainBoardStatus[2][i]) {
        return true;
      }
    }
    // Diagonais
    if (mainBoardStatus[0][0] != null &&
        mainBoardStatus[0][0] != 'neutra' &&
        mainBoardStatus[0][0] == mainBoardStatus[1][1] &&
        mainBoardStatus[1][1] == mainBoardStatus[2][2]) {
      return true;
    }
    if (mainBoardStatus[0][2] != null &&
        mainBoardStatus[0][2] != 'neutra' &&
        mainBoardStatus[0][2] == mainBoardStatus[1][1] &&
        mainBoardStatus[1][1] == mainBoardStatus[2][0]) {
      return true;
    }
    return false;
  }

  // Verifica se a matriz principal está cheia
  bool _isMainBoardFull() {
    return mainBoardStatus.every((row) => row.every((cell) => cell != null));
  }

  // Reinicia o jogo
  void resetGame() {
    mainBoard = List.generate(
      3,
      (_) => List.generate(3, (_) => List.filled(9, null)),
    );
    mainBoardStatus = List.generate(3, (_) => List.filled(3, null));
    currentPlayer = 'X';
    forcedMainCell = null;
    gameEnded = false;
    winner = null;
    notifyListeners();
  }
}