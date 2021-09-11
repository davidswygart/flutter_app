import 'package:flutter/material.dart';
import 'package:flutter_app/routes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'AppBar/BlueToothUpdater.dart';
import 'Bodies/Dashboard/Dashboard.dart';
import 'Bodies/Presets/CustomPresetChangeNotifier.dart';

const String savedPresets = "CustomPresets";

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<Map>(savedPresets);

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<PresetUpdater>(create: (context) => PresetUpdater()),
          ChangeNotifierProvider<BlueToothUpdater>(create: (context) => BlueToothUpdater()),
        ],
        child: MaterialApp(
          home: DashPage(),
          routes: routes,
        ),
      ),
  );
}