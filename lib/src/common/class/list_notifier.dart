class ListNotifier<T> {
  List<T> _list = [];

  Function(List<T>)? _job;

  bool _isCalledFirstTime = false;

  void listenFirstTimeCall() {
    if (!_isCalledFirstTime) {
      if (_job != null) _job!(_list);
    }
    _isCalledFirstTime = true;
  }

  void _notify() {
    if (_job != null) _job!(_list);
  }

  void observe(Function(List<T>) func) {
    _job = func;
  }

  // getter and setter ---------------------------------------------------------

  set value(List<T> list) {
    _list = list;

    listenFirstTimeCall();

    _notify();
  }

  List<T> get value => _list;
}
