import 'package:eid/models/prize_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../wheel_screen/provider/wheel_controller.dart';

class PrizesDashBoardScreen extends StatelessWidget {
  const PrizesDashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WheelController>(
        builder: (context, provider, child) => Scaffold(
              appBar: AppBar(
                title: Text('لوحة التحكم'),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) =>
                          _ItemPrize(item: provider.loadItems()[index]),
                      itemCount: provider.loadItems().length,
                    ),
                  ),
                  const _ItemPrize()
                ],
              ),
            ));
  }
}

class _ItemPrize extends StatefulWidget {
  final PrizeItem? item;
  const _ItemPrize({Key? key, this.item}) : super(key: key);

  @override
  State<_ItemPrize> createState() => _ItemPrizeState();
}

class _ItemPrizeState extends State<_ItemPrize> {
  TextEditingController nameController = TextEditingController();
  TextEditingController countController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.item != null) {
      countController =
          TextEditingController(text: widget.item!.count.toString());
      nameController =
          TextEditingController(text: widget.item!.name.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: Key(nameController.text),
      children: [
        Flexible(
          child: TextField(
            controller: nameController,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Flexible(
          child: TextField(
            controller: countController,
          ),
        ),
        IconButton(
            onPressed: () {
              int newCount = int.parse(countController.text);
              if (widget.item != null) {
                _update(
                  item: widget.item,
                  name: nameController.text,
                  count: newCount,
                );
              } else {
                _add(
                  name: nameController.text,
                  count: newCount,
                );
              }
            },
            icon: const Icon(Icons.done))
      ],
    );
  }

  _update({required item, required String name, required int count}) {
    Provider.of<WheelController>(context, listen: false)
        .updateItem(item, PrizeItem(count: count, name: name));
  }

  _add({required String name, required int count}) {
    Provider.of<WheelController>(context, listen: false)
        .addItem(PrizeItem(count: count, name: name));
    nameController.clear();
    countController.clear();
  }
}
