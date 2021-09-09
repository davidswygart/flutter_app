import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bodies/Presets/CompetitionSettings.dart';
import 'package:flutter_app/ChangeNotifiers/CustomPresetChangeNotifier.dart';
import 'package:provider/provider.dart';

class AddNameDialog extends StatelessWidget {
  Function addName;
  int playerNum;
  AddNameDialog({required this.addName, required this.playerNum});


  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        children: <Widget>[
          TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(labelText: 'Add Name'),
              onSubmitted: (String newName) {
                addName(newName, playerNum);
                Navigator.pop(context);
                },
              )
        ]);
  }
}