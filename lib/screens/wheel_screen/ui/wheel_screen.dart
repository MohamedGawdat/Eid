import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:provider/provider.dart';
import '../../../models/prize_item.dart';
import '../../dashboard_screen/ui/prizes_dashboard.dart';
import '../provider/wheel_controller.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({Key? key}) : super(key: key);

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  StreamController<int> controller = StreamController<int>();
  bool inProgress = false;
  String congText = '💝 عيدكم مبارك 💝';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WheelController(),
      child: Consumer<WheelController>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(congText),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                              value: value,
                              child: const PrizesDashBoardScreen()),
                        ));
                  },
                  icon: const Icon(Icons.settings))
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bk_image.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: InkWell(
              onTap: () {
                onPressed(value);
              },
              child: value.loadItems().isNotEmpty
                  ? FortuneWheel(
                      duration: const Duration(seconds: 2),
                      physics: CircularPanPhysics(
                        duration: const Duration(seconds: 1),
                        curve: Curves.ease,
                      ),
                      onFling: () {
                        onPressed(value);
                      },
                      selected: controller.stream,
                      items: value
                          .loadItems()
                          .map((e) => FortuneItem(child: Text(e.name)))
                          .toList())
                  : const SizedBox(),
            ),
          ),
          // body: ,
        ),
      ),
    );
  }

  onPressed(provider) {
    if (!inProgress) {
      PrizeItem randomItem =
          provider.getRandomItemBasedOnPercentage(provider.loadItems());
      int wheelIndex = provider
          .loadItems()
          .indexWhere((element) => element.name == randomItem.name);
      controller.add(wheelIndex);
      Timer(const Duration(seconds: 2), () {
        onItemSelected(randomItem.name);
        inProgress = false;
      });
      inProgress = true;
    }
  }

  onItemSelected(String prize) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xffDECFB3),
          title: Container(
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(18)),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                congText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),
              ),
            )),
          ),
          content: Center(
              child: Text(
            'مبروك كسبت ${prize}',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 35,
            ),
            textAlign: TextAlign.center,
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('شكراً'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
