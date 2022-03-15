import 'dart:async';

import 'package:wordle_game/src/common/interface/widget_lifecycle.dart';
import 'package:wordle_game/src/ui/game_screen/controller/observable_game_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';
import 'package:wordle_game/src/utils/logger.dart';

class SetupKeyboard with WidgetLifecycle, Logger {
  /// CONVENTION:
  /// - GreenState: RightCharRightPositionState
  /// - YellowState: RightCharWrongPositionState
  /// - BlackState: WrongCharacterState
  ///
  ///

  /// the 'liveData' is required for all function below work properly
  ///
  /// some of the functions below will update some Rx<Data> inside 'liveData'
  final ObservableGameData _liveData;

  SetupKeyboard(this._liveData);

  // lifecycle -----------------------------------------------------------------

  @override
  void onInitState() {
    _observe();
  }

  @override
  void onDisposeState() {
    _removeObserver();
  }

  // public --------------------------------------------------------------------

  void resetKeyboard() {
    for (int i = 0; i < _liveData.keyboardStateList.length; i++) {
      final prevChar = _liveData.keyboardStateList[i].char;
      _liveData.keyboardStateList[i] = InitialCharacterState(prevChar);
    }
  }

  // private -------------------------------------------------------------------

  StreamSubscription? _gameBoardStatesListener;

  void _observe() {
    _gameBoardStatesListener = _liveData.gameBoardStateList.stream.listen((_) {
      _updateKeyBoardButtonsState();
    });
  }

  void _removeObserver() {
    _gameBoardStatesListener?.cancel();
  }

  /// change button's color properly in keyboard
  ///
  /// - first, get blackState List from gameBoard, then change button's color
  /// to black if button's character equals to blackState character
  ///
  /// - second, repeat step 1 but yellowState instead of blackState
  ///
  /// - third, repeat step 1 but greenState instead of blackState
  ///
  /// That way, I can make sure that greenState will have higher priority
  /// than yellowState in priority. blackState does not affects
  void _updateKeyBoardButtonsState() {
    for (var blackState in _getBlackStateListFromGameBoard()) {
      int pos = _findButtonPositionEqualTo(blackState.char);
      _liveData.keyboardStateList[pos] = WrongCharacterState(blackState.char);
    }
    for (var yellowState in _getYellowStateListFromGameBoard()) {
      int pos = _findButtonPositionEqualTo(yellowState.char);
      _liveData.keyboardStateList[pos] =
          RightCharacterWrongPositionState(yellowState.char);
    }

    for (var greenState in _getGreenStateListFromGameBoard()) {
      int pos = _findButtonPositionEqualTo(greenState.char);
      _liveData.keyboardStateList[pos] =
          RightCharacterRightPositionState(greenState.char);
    }
  }

  List<CharacterState> _getGreenStateListFromGameBoard() {
    return _liveData.gameBoardStateList
        .whereType<RightCharacterRightPositionState>()
        .toList();
  }

  List<CharacterState> _getYellowStateListFromGameBoard() {
    return _liveData.gameBoardStateList
        .whereType<RightCharacterWrongPositionState>()
        .toList();
  }

  List<CharacterState> _getBlackStateListFromGameBoard() {
    return _liveData.gameBoardStateList
        .whereType<WrongCharacterState>()
        .toList();
  }

  /// find keyboard button position which equals to specific char
  ///
  /// the return-value will never returns -1,
  /// because 'keyboardCharacters' contains all characters in alphabet
  int _findButtonPositionEqualTo(String char) =>
      _liveData.keyboardStateList.indexWhere((state) => state.char == char);
}
