extension Repeat on Function(int i) {
  void repeat(int count) {
    for (int _ = 0; _ < count; _++) {
      this(_);
    }
  }
}
