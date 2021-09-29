import 'package:flutter/material.dart';
import 'package:flutter_app/Bodies/GameMode/CompetitionSettings.dart';
import 'package:flutter_app/NavigationDrawer/routes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'BlueTooth/BlueServices.dart';
import 'Bodies/Dashboard/Dashboard.dart';

const String savedPresets = "CustomPresets";

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<PresetTemplate>(savedPresets);
  BlueServices.initialize();

  runApp(
    MaterialApp(
      home: DashPage(),
      routes: routes,
    ),
  );
}
