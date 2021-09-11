import 'package:flutter/cupertino.dart';
import 'Bodies/ActiveGame/ActiveGame.dart';
import 'Bodies/Dashboard/Dashboard.dart';
import 'Bodies/Players/Players.dart';
import 'Bodies/Presets/Presets.dart';

final Map<String, Widget Function(BuildContext)> routes =  <String, WidgetBuilder>{
  '/Dashboard': (BuildContext context) => DashPage(),
  '/GameModes': (BuildContext context) => PresetPage(),
  '/Players': (BuildContext context) => PlayersPage(),
  '/ActiveGame': (BuildContext context) => ActiveGamePage(),
};