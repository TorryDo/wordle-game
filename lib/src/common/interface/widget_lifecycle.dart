abstract class WidgetLifecycle{

  void onInitWidget();

  void onBuildWidget();

  void onPauseWidget();

  void onResumeWidget();

  WidgetLifecycle get lifecycle => this;

}

class DefaultWidgetLifecycle extends WidgetLifecycle{

  @override
  void onInitWidget() {}

  @override
  void onBuildWidget() {}

  @override
  void onPauseWidget() {}

  @override
  void onResumeWidget() {}

}