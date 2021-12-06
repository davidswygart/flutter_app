import 'package:flutter/material.dart';
import 'package:flutter_app/Bodies/GameMode/CompetitionSettings.dart';
import 'package:flutter_app/Bodies/Users/UserData.dart';
import 'package:flutter_app/Pages/routes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'BlueTooth/BlueToothHandler.dart';
import 'Pages/Pages.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<Preset>(Preset.boxName);
  await Hive.openBox<User>(User.boxName);
  BlueToothHandler bth = BlueToothHandler();
  bth.startStateHandler();

  runApp(
    MaterialApp(
      home: DashPage(),
      routes: routes,
    ),
  );
}
