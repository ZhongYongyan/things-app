import 'dart:math';

import 'package:app/base/util/LoggingUtils.dart';
import 'package:app/base/util/StorageUtils.dart';

enum AlertType { error, warning, success, info }

class Alert {
  Alert(this.type, this.message);

  final AlertType type;
  final String message;
}

class AppState with StorageMixin, LoggingMixin {
  String clientId = '';
  String errorMessage = '';

  AppState() {
    this.clientId = storage.get('app.clientId');
    if (this.clientId == null || this.clientId.isEmpty) {
      this.clientId = _uuid(32);
      storage.setString('app.clientId', this.clientId);
    }
  }
}

String _uuid(int len) {
  String alphabet =
      'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM0123456789';
  String left = '';
  for (var i = 0; i < len; i++) {
    left = left + alphabet[Random().nextInt(alphabet.length)];
  }
  return left;
}
