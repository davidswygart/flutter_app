import 'package:flutter/material.dart';
import 'package:flutter_app/pages/debug_ble.dart';
import 'package:flutter_app/pages/main_scaffold.dart';

import 'bluetooth/bluetooth_handler.dart';

void main() {
 // await Hive.initFlutter();
 // await Hive.openBox<Preset>(Preset.boxName);
 // await Hive.openBox<User>(User.boxName);
  BlueToothHandler bth = BlueToothHandler();

  runApp(
    MaterialApp(
      //home: DebugBlePage(),
      home: MainScaffold(bodyPage: DebugBlePage()),
    ),
  );
}
