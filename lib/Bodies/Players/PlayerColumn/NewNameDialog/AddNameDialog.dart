import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNameDialog extends StatelessWidget {
  final Function addName;
  final int playerNum;
  AddNameDialog({required this.addName, required this.playerNum});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(children: <Widget>[
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
