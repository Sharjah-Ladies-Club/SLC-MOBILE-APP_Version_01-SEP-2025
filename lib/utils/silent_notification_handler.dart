import 'dart:async';

class SilentNotificationHandler {
  SilentNotificationHandler._internal();

  static final SilentNotificationHandler _instance =
      SilentNotificationHandler._internal();

  static SilentNotificationHandler get instance => _instance;

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void updateData(Map<String, String> data) async {
    controller.sink.add(data);
  }

  void disposeStream() => controller.close();
}
