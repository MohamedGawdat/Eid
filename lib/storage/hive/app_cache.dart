import 'package:hive_flutter/adapters.dart';

import '../../models/prize_item.dart';
import 'cache_util.dart';

class AppCache {
  static initCache() async {
    await CacheUtil.init();
    await registerAdaptersAndOpenBoxesForPrizes();
  }

  static Future<void> registerAdaptersAndOpenBoxesForPrizes() async {
    await registerPrizeAdapter();
    await openBox('prize');
  }

  static registerPrizeAdapter() {
    CacheUtil.registerAdapter<PrizeItem>(PrizeItemAdapter());
  }

  static openBox(key) async {
    await CacheUtil.openBox(key);
  }

  static void clearCache() {
    CacheUtil.clearCache();
  }

  static void clearPrizesData() {
    CacheUtil.deleteAt('prize');
  }

  isBoxExist(key) async {
    bool isBoxExist = await CacheUtil.isBoxExists(key);
    return isBoxExist;
  }

  isBoxOpened(key) {
    bool isBoxOpened = CacheUtil.isBoxOpen(key);
    return isBoxOpened;
  }

  deleteBox(key) {
    CacheUtil.deleteAt(key);
  }
}
