import 'package:flutter/material.dart';
import 'package:flutter_app/pages/debug_ble.dart';
import 'package:flutter_app/pages/main_scaffold.dart';

void main() {
 // await Hive.initFlutter();
 // await Hive.openBox<Preset>(Preset.boxName);
 // await Hive.openBox<User>(User.boxName);

  runApp(
    MaterialApp(
      home: MainScaffold(bodyPage: DebugBlePage()),
    ),
  );
}
