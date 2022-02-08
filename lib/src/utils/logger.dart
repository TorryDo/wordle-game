import 'dart:developer';

class Logger{

  String _tag = 'unNamed tag';
  bool _isDebugEnabled = false;

  Logger setTag(String tag){
    _tag = tag;

    return this;
  }

  Logger setDebugEnabled(bool isDebugEnabled){
    _isDebugEnabled = isDebugEnabled;
    return this;
  }

  void d(String message){
    log("<> D-$_tag: $message");
  }

  void e(String message){
    log("<> E-$_tag: $message");
  }

}