abstract class WidgetLifecycle{

  void onInitState(){}

  void onDidChangeDependencies(){}

  void onBuildState(){}

  void onDidUpdateWidget(){}

  void onSetState(){}

  void onDisposeState(){}

  WidgetLifecycle get lifecycle => this;

}
