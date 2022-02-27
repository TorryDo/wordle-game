class ListNotifier<T> {
  List<T> _list = [];

  Function(List<T>)? _job;

  bool _isCalledFirstTime = false;

  void listenFirstTimeCall() {
    if (_job != null) _job!(_list);
  }

  set value(List<T> list) {
    _list = list;

    if (!_isCalledFirstTime) listenFirstTimeCall();
    _isCalledFirstTime = true;

    _notify();
  }

  List<T> get value => _list;

  void _notify() {}

  void observe(Function(List<T>) func) {
    _job = func;
  }
}
