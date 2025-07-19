enum CellState { empty, x, o, neutral }

class GameBoard {
  // Matriz principal 3x3, onde cada célula contém uma matriz secundária 3x3
  List<List<List<List<CellState>>>> mainBoard;
  // Estado da matriz principal (quem conquistou cada célula)
  List<List<CellState>> mainBoardState;
  // Indica se a célula da matriz principal está concluída
  List<List<bool>> mainBoardCompleted;

  GameBoard()
      : mainBoard = List.generate(
          3,
          (_) => List.generate(
            3,
            (_) => List.generate(
              3,
              (_) => List.generate(3, (_) => CellState.empty),
            ),
          ),
        ),
        mainBoardState = List.generate(3, (_) => List.generate(3, (_) => CellState.empty)),
        mainBoardCompleted = List.generate(3, (_) => List.generate(3, (_) => false));

  // Verifica se uma matriz secundária foi ganha
  bool checkSubBoardWin(int mainRow, int mainCol) {
    // Obtém a matriz secundária
    List<List<CellState>> board = mainBoard[mainRow][mainCol];
    
    // Checa linhas
    for (int i = 0; i < 3; i++) {
      if (board[i][0] != CellState.empty &&
          board[i][0] == board[i][1] &&
          board[i][1] == board[i][2]) {
        mainBoardState[mainRow][mainCol] = board[i][0];
        mainBoardCompleted[mainRow][mainCol] = true;
        return true;
      }
    }

    // Checa colunas
    for (int j = 0; j < 3; j++) {
      if (board[0][j] != CellState.empty &&
          board[0][j] == board[1][j] &&
          board[1][j] == board[2][j]) {
        mainBoardState[mainRow][mainCol] = board[0][j];
        mainBoardCompleted[mainRow][mainCol] = true;
        return true;
      }
    }

    // Checa diagonais
    if (board[0][0] != CellState.empty &&
        board[0][0] == board[1][1] &&
        board[1][1] == board[2][2]) {
      mainBoardState[mainRow][mainCol] = board[0][0];
      mainBoardCompleted[mainRow][mainCol] = true;
      return true;
    }
    if (board[0][2] != CellState.empty &&
        board[0][2] == board[1][1] &&
        board[1][1] == board[2][0]) {
      mainBoardState[mainRow][mainCol] = board[0][2];
      mainBoardCompleted[mainRow][mainCol] = true;
      return true;
    }

    // Checa empate
    bool isFull = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == CellState.empty) {
          isFull = false;
          break;
        }
      }
      if (!isFull) break; // Sai do loop externo se já encontrou uma célula vazia
    }
    if (isFull) {
      mainBoardState[mainRow][mainCol] = CellState.neutral;
      mainBoardCompleted[mainRow][mainCol] = true;
      return true;
    }

    return false;
  }

  // Verifica se há vitória na matriz principal
  bool checkMainBoardWin() {
    // Checa linhas
    for (int i = 0; i < 3; i++) {
      if (mainBoardState[i][0] != CellState.empty &&
          mainBoardState[i][0] != CellState.neutral &&
          mainBoardState[i][0] == mainBoardState[i][1] &&
          mainBoardState[i][1] == mainBoardState[i][2]) {
        return true;
      }
    }

    // Checa colunas
    for (int j = 0; j < 3; j++) {
      if (mainBoardState[0][j] != CellState.empty &&
          mainBoardState[0][j] != CellState.neutral &&
          mainBoardState[0][j] == mainBoardState[1][j] &&
          mainBoardState[1][j] == mainBoardState[2][j]) {
        return true;
      }
    }

    // Checa diagonais
    if (mainBoardState[0][0] != CellState.empty &&
        mainBoardState[0][0] != CellState.neutral &&
        mainBoardState[0][0] == mainBoardState[1][1] &&
        mainBoardState[1][1] == mainBoardState[2][2]) {
      return true;
    }
    if (mainBoardState[0][2] != CellState.empty &&
        mainBoardState[0][2] != CellState.neutral &&
        mainBoardState[0][2] == mainBoardState[1][1] &&
        mainBoardState[1][1] == mainBoardState[2][0]) {
      return true;
    }

    // Checa empate na matriz principal
    bool allCompleted = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (!mainBoardCompleted[i][j]) {
          allCompleted = false;
          break;
        }
      }
      if (!allCompleted) break;
    }
    return allCompleted;
  }
}