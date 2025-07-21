import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SoundManager with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSoundEnabled = true;

  bool get isSoundEnabled => _isSoundEnabled;

  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    notifyListeners();
  }

  Future<void> playMove() async {
    if (_isSoundEnabled) {
      await _audioPlayer.play(AssetSource('sounds/move.mp3'));
    }
  }

  Future<void> playSubBoardWin() async {
    if (_isSoundEnabled) {
      await _audioPlayer.play(AssetSource('sounds/win_subboard.mp3'));
    }
  }

  Future<void> playBackgroundSound() async {
    if (_isSoundEnabled) {
      await _audioPlayer.play(AssetSource('sounds/backgroundSound.mp3'));
    }
  }

  Future<void> playGameEnd(String? winner) async {
    if (_isSoundEnabled) {
      if (winner == 'Empate') {
        await _audioPlayer.play(AssetSource('sounds/draw.mp3'));
      } else {
        await _audioPlayer.play(AssetSource('sounds/win_game.mp3'));
      }
    }
  }
}
