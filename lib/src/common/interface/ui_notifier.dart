abstract class UINotifier {
  void showSnackBar({String? label, String? content}) {}
  void showToast({String? message}){}
}

class UINotifierReceiver {
  UINotifier? uiNotifier;

  void registerUINotifier(UINotifier uiNotifier) {
    this.uiNotifier = uiNotifier;
  }
}
