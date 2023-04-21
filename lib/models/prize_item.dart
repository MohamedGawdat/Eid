import 'package:hive/hive.dart';
part 'prize_item.g.dart';

@HiveType(typeId: 0)
class PrizeItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int count;

  PrizeItem({required this.name, required this.count});
}
