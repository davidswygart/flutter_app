import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/scaffold_wrapper.dart';

import 'bluetooth/bluetooth_handler.dart';

void main() {
 // await Hive.initFlutter();
 // await Hive.openBox<Preset>(Preset.boxName);
 // await Hive.openBox<User>(User.boxName);
  runApp(
    MaterialApp(
      home: const ScaffoldWrapper(bodyPage: HomePage()),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
      )
    ),
  );
}