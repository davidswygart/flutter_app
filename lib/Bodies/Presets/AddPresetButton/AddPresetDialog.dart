import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bodies/Presets/CompetitionSettings.dart';
import 'package:flutter_app/ChangeNotifyers/CustomPresetChangeNotifyer.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class AddPresetDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        children: <Widget>[
          TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(labelText: 'Preset Name'),
              onSubmitted: (String newName) {addPreset(context, newName);})
        ]);
  }

  addPreset(context, name) {
    final cpNotifier = Provider.of<CustomPresetNotifier>(context, listen:false);
    Map copy = {...preset_DisapearingLights};
    copy['title'] = name;
    cpNotifier.add(copy);
    Navigator.pop(context);
  }
}