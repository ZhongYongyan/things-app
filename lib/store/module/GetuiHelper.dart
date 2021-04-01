import 'package:app/base/util/LoggingUtils.dart';
import 'package:getuiflut/getuiflut.dart';

GetuiHelper getuiHelper = GetuiHelper();

class GetuiHelper with LoggingMixin {
  EventHandler _onReceiveClientId;

  onReceiveClientId(EventHandler handler) {
    _onReceiveClientId = handler;
    if (cid != null && cid.isNotEmpty) {
      handler(cid);
    }
  }

  String cid;
  String id;

  void create() {
    Getuiflut().addEventHandler(
      onReceiveClientId: (String message) async {
        log.info("flutter onReceiveClientId+++++++++++++++++++++++: $message");
        cid = message; // 注册收到 cid 的回调
        _onReceiveClientId(cid);
      },
      onRegisterDeviceToken: (String message) async {
        log.info(
            "flutter onRegisterDeviceToken+++++++++++++++++++++++: $message");
        cid = message; // 注册收到 cid 的回调
      },
    );
  }
}
