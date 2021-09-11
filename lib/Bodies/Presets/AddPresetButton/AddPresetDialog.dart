import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/Bodies/Presets/CustomPresetChangeNotifier.dart';
import 'package:provider/provider.dart';

class AddPresetDialog extends StatelessWidget {
  final Map settings;
  AddPresetDialog({required this.settings});

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
    final cpNotifier = Provider.of<PresetUpdater>(context, listen:false);
    settings['title'] = name;
    cpNotifier.add(settings);
    Navigator.pop(context);
  }
}