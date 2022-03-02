abstract class WidgetLifecycle{

  void onInitState(){}

  void onDidChangeDependencies(){}

  void onBuildState(){}

  void onDidUpdateWidget(){}

  void onSetState(){}

  void onDispose(){}

  WidgetLifecycle get lifecycle => this;

}
