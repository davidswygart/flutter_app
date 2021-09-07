import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ChangeNotifiers/CustomPresetChangeNotifier.dart';
import 'package:provider/provider.dart';

class DeleteRenameDialog extends StatelessWidget{
  final Map settings;
  DeleteRenameDialog({required this.settings});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        //title: Text('Rename Preset'),
        children: <Widget>[
          TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(labelText: settings['title']),
              onSubmitted: (String newName) {rename(context, newName);}),
          ElevatedButton(
            child: Text('Delete "' + settings['title'] + '"',style: TextStyle(fontSize:20)),
            onPressed: () {delete(context);},
            style: ElevatedButton.styleFrom(primary: Colors.red,),
          ),
          ElevatedButton(
            child: const Text('Delete All',style: TextStyle(fontSize:20)),
            onPressed: () {deleteAll(context);},
            style: ElevatedButton.styleFrom(primary: Colors.red,),
          ),
    ]);
  }

  rename(context, newName){
    final cpNotifier = Provider.of<CustomPresetNotifier>(context, listen:false);
    settings['title'] = newName;
    cpNotifier.update(settings);
    Navigator.pop(context);
  }

  delete(context){
    final cpNotifier = Provider.of<CustomPresetNotifier>(context, listen:false);
    cpNotifier.delete(settings);
    Navigator.pop(context);
  }

  deleteAll(context){
    final cpNotifier = Provider.of<CustomPresetNotifier>(context, listen:false);
    cpNotifier.deleteAll();
    Navigator.pop(context);
  }
}