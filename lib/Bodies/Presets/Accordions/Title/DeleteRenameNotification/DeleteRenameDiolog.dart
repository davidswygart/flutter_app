import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ChangeNotifyers/CustomPresetChangeNotifyer.dart';
import 'package:provider/provider.dart';

class DeleteRenameDialog extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        //title: Text('Rename Preset'),
        children: <Widget>[
          TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(labelText: 'Rename'),
              onSubmitted: (String newName) {rename(context, newName);}),
          ElevatedButton(
            child: const Text('Delete',style: TextStyle(fontSize:20)),
            onPressed: () {},
            style: ElevatedButton.styleFrom(primary: Colors.red,),

          ),
    ]);
  }

  rename(context, newName){
    final cpNotifier = Provider.of<CustomPresetNotifier>(context, listen:false);
    cpNotifier.deleteAll();
    Navigator.pop(context);
  }
}