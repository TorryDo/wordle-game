import 'dart:developer';

import 'package:wordle_game/src/utils/constants.dart';

class Logger {
  String? _tag;
  bool? _isDebugEnabled;

  String get tag {
    _tag ??= _getDefaultTag();
    return _tag!;
  }

  set tag(String str) {
    _tag = str;
  }

  bool get isDebugEnabled {
    if (_isDebugEnabled == null) debugEnabled = Constants.IS_DEBUG_ANABLED;
    return _isDebugEnabled!;
  }

  set debugEnabled(bool enabled) {
    _isDebugEnabled = enabled;
  }

  void d(String message) {
    log("<> D-$tag: $message");
  }

  void e(String message) {
    log("<> E-$tag: $message");
  }

  String _getDefaultTag() => runtimeType.toString();
}
