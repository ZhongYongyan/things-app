import 'package:shared_preferences/shared_preferences.dart';

class StorageConfig {
  static SharedPreferences _storage;

  static Future<SharedPreferences> config() async {
    if (_storage == null) {
      _storage = await SharedPreferences.getInstance();
    }
    return _storage;
  }
}

mixin StorageMixin {
  SharedPreferences get storage {
    return StorageConfig._storage;
  }
}
