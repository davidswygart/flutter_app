import 'package:flutter/material.dart';
import 'package:flutter_app/pages/debug_ble.dart';
import 'package:flutter_app/pages/home_page.dart';

void main() {
 // await Hive.initFlutter();
 // await Hive.openBox<Preset>(Preset.boxName);
 // await Hive.openBox<User>(User.boxName);
  runApp(
    MaterialApp(
      home: const HomePage(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
      )
    ),
  );
}

