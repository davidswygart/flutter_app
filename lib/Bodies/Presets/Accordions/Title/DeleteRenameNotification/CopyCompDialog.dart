import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bodies/Presets/AddPresetButton/AddPresetDialog.dart';
import 'package:flutter_app/ChangeNotifiers/CustomPresetChangeNotifier.dart';
import 'package:provider/provider.dart';

class CopyCompDialog extends StatelessWidget{
  final Map settings;
  CopyCompDialog({required this.settings});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      //title: Text('Rename Preset'),
        children: <Widget>[
          ElevatedButton(
            child: Text('Copy "' + settings['title'] + '" as custom preset',
                style: TextStyle(fontSize:20)),
            onPressed: () {delete(context);},
            style: ElevatedButton.styleFrom(primary: Colors.green,),
          ),
        ]);
  }

  delete(context){
    final cpNotifier = Provider.of<CustomPresetNotifier>(context, listen:false);
    cpNotifier.delete(settings);
    Navigator.pop(context);
    showNewPresetDialog(context);
  }

  showNewPresetDialog(context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Map copy = {...settings};
          return AddPresetDialog(settings: copy);}
    );
  }
}