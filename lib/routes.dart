import 'package:flutter/cupertino.dart';
import 'Bodies/Presets/Presets.dart';

final Map<String, Widget Function(BuildContext)> routes =  <String, WidgetBuilder>{
  '/GameModes': (BuildContext context) => PresetPage(),
};