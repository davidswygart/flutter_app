import 'package:flutter/material.dart';
import 'Pages/Pages.dart';

void main() async {
  runApp(
    MaterialApp(
      home: DashPage(),
      routes: {
        DashPage.routeName: (BuildContext context) => DashPage(),
        GameModePage.routeName: (BuildContext context) => GameModePage(),
        GameSettingsPage.routeName: (context) => const GameSettingsPage(),
        ActiveGamePage.routeName: (BuildContext context) => ActiveGamePage(),
        BlueToothDevicesPage.routeName: (context) => const BlueToothDevicesPage(),
        UsersPage.routeName: (context) => const UsersPage(),
        PlayersPage.routeName: (context) => PlayersPage(),
        DebugBlePage.routeName: (context) => DebugBlePage(),
      },
    ),
  );
}
