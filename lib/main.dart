import 'package:eid/screens/wheel_screen/ui/wheel_screen.dart';
import 'package:eid/storage/hive/app_cache.dart';
import 'package:flutter/material.dart';

void main() async {
  await AppCache.initCache();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const WheelScreen(),
    );
  }
}
