import 'package:hive_flutter/hive_flutter.dart';


class CacheUtil {
  static Future<void> init() async {
    await Hive.initFlutter();
  }

  static initBox(String key) async {
    if (await isBoxExists(key)) {
      if (!isBoxOpen(key)) {
        await openBox(key);
      }
    }
  }

  static openBox(String key) async {
    await Hive.openBox(key);
  }

  static void save(String key, dynamic value) async {
    await initBox(key);

    final Box myBox = Hive.box(key);
    myBox.add(value);
  }

  static get<T>(String key, T defaultValue) {
    final dynamic value = Hive.box(key);
    if (value != null) {
      return value as T;
    }
    return defaultValue;
  }

  static Future<bool> isBoxExists(String key) async {
    return await Hive.boxExists(key);
  }

  static bool isBoxOpen(String key) {
    return Hive.isBoxOpen(key);
  }

  static void clearCache() {
    Hive.deleteFromDisk();
  }

  static void deleteAt(key) {
    Hive.deleteBoxFromDisk(key);
  }

  static void registerAdapter<T>(TypeAdapter<T> adapter) {
    Hive.registerAdapter<T>(adapter);
  }

  static Future<void> closeHive() async {
    await Hive.close();
  }
}
