import 'dart:async';

abstract class LineChartStorageInterface<LineChartData, XType> {
  final StreamController<LineChartData> onLineDataUpdateController = StreamController.broadcast();
  Stream<LineChartData> get _onLineDataUpdateStream => onLineDataUpdateController.stream;
  StreamSubscription<LineChartData> onLineDataUpdateSubscription(void Function(LineChartData data) doSomething) {
    return _onLineDataUpdateStream.listen((data) {
      doSomething(data);
    });
  }

  final StreamController<void> onLineChartXChangeController = StreamController.broadcast();
  Stream<void> get _onLineChartXChangeStream => onLineChartXChangeController.stream;
  StreamSubscription<void> onLineChartXChangeSubscription(void Function() doSomething) {
    return _onLineChartXChangeStream.listen((a) {
      doSomething();
    });
  }
  XType? lineChartX;
  setLineChartX(XType? x) {
    lineChartX = x;
    onLineChartXChangeController.sink.add(null);
  }
}