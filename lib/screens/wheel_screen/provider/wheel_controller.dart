import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../models/prize_item.dart';

class WheelController with ChangeNotifier {
  WheelController() {
    _initializeItems();
  }
  final List<PrizeItem> _defaultItems = [
    PrizeItem(name: 'كحك', count: 2),
    PrizeItem(name: 'بسكوت', count: 5),
    PrizeItem(name: 'شكولاتة', count: 2),
  ];

  Box<dynamic> _getPrizesBox() {
    return Hive.box('prize');
  }

  Future<void> _initializeItems() async {
    List<PrizeItem> itemsList = await loadItems();
    if (itemsList.isEmpty) {
      itemsList = _defaultItems;
      await saveItems(itemsList);
    }
  }

  List<PrizeItem> loadItems() {
    final itemsBox = _getPrizesBox();
    List<PrizeItem> itemsList = itemsBox.values.cast<PrizeItem>().toList();
    return itemsList;
  }

  Future<void> saveItems(List<PrizeItem> items) async {
    final itemsBox = _getPrizesBox();
    for (PrizeItem item in items) {
      await itemsBox.put(item.name, item);
    }
  }

  Future<void> addItem(PrizeItem item) async {
    final itemsBox = _getPrizesBox();
    await itemsBox.put(item.name, item);
    notifyListeners();
  }

  Future<void> updateItemCount(PrizeItem item, int newCount) async {
    item.count = newCount;
    final itemsBox = _getPrizesBox();
    await itemsBox.put(item.name, item);
  }

  Future<void> updateItemName(PrizeItem item, String newName) async {
    final itemsBox = _getPrizesBox();
    await itemsBox.delete(item.name); // Remove the old item from the box
    item.name = newName;
    await itemsBox.put(item.name, item); // Add the updated item to the box
  }

  Future<void> updateItem(PrizeItem oldItem, PrizeItem updatedItem) async {
    final itemsBox = _getPrizesBox();
    await itemsBox.delete(oldItem.name); // Remove the old item from the box
    await itemsBox.put(
        updatedItem.name, updatedItem); // Add the updated item to the box
    notifyListeners();
  }

  PrizeItem getRandomItemBasedOnPercentage(List<PrizeItem> items) {
    int totalCount = items.fold(0, (sum, item) => sum + item.count);

    if (totalCount == 0) {
      throw ArgumentError(
          'The total count of all items must be greater than 0.');
    }

    int randomValue = Random().nextInt(totalCount);
    int currentCount = 0;

    for (PrizeItem item in items) {
      currentCount += item.count;
      if (randomValue < currentCount) {
        item.count--; // Decrease the count of the selected item.
        updateItemCount(item, item.count);

        return item;
      }
    }

    throw StateError(
        'This should never happen. Check the input list of items.');
  }
}
