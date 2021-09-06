import 'package:flutter/material.dart';
import 'package:flutter_app/routes.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'Bodies/Dashboard/Dashboard.dart';
import 'ChangeNotifyers/CustomPresetChangeNotifyer.dart';

const String savedPresets = "CustomPresets";

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<Map>(savedPresets);

  runApp(
      ChangeNotifierProvider(
          create: (context) => CustomPresetNotifier(),
          child: MaterialApp(
            home: DashPage(),
            routes: routes,
          )
      )
  );
}


