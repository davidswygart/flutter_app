import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../main.dart';
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
        builder: (BuildContext context) {return AddPresetDialog();}
        );
  }
}
