extension Repeat on Function(int i) {
  void repeat(int count) {
    for (int i = 0; i < count; i++) {
      this(i);
    }
  }

  void loop(int from, int to) {
    if (from > to) {
      _reverseLoop(from, to);
      return;
    }
    for (int i = from; i < to; i++) {
      this(i);
    }
  }

  void _reverseLoop(int from, int to) {
    for (int i = from; i > to; i--) {
      this(i);
    }
  }
}

extension ReplaceChar on String {
  String replaceCharAt(int index, String newChar) {
    return substring(0, index) + newChar + substring(index + 1);
  }

}

extension ListStringToWord on List<String>{
  String toWord(){
    var result = '';
    for(var c in this){
      result += c;
    }
    return result;
  }

}
