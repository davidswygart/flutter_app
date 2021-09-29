import 'package:flutter/material.dart';
import 'package:flutter_app/Bodies/BlueToothDevices/BlueToothDevices.dart';
import 'package:flutter_app/Bodies/GameMode/GameMode.dart';
import 'package:flutter_app/Bodies/GameSettings/GameSettings.dart';
import '../Bodies/ActiveGame/ActiveGame.dart';
import '../Bodies/Dashboard/Dashboard.dart';

final Map<String, Widget Function(BuildContext)> routes =
    <String, WidgetBuilder>{
  '/Dashboard': (BuildContext context) => DashPage(),
      '/GameModes': (BuildContext context) => GameModePage(),
      GameSettingsPage.routeName: (context) => const GameSettingsPage(),
      '/ActiveGame': (BuildContext context) => ActiveGamePage(),
      BlueToothDevicesPage.routeName: (context) => const BlueToothDevicesPage(),
};
