import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../CompetitionSettings.dart';
import 'AddPresetDialog.dart';

class AddNewPresetButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Text('+',
          style: TextStyle(
            fontSize: 30,
            color: Colors.green,
          ),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.white10,),
        onPressed: () {showNewPresetDialog(context);}
        );
  }

  showNewPresetDialog(context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Map copy = {...preset_ShootOff};
          return AddPresetDialog(settings: copy);}
        );
  }
}
