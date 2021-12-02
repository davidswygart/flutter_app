import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/Pages.dart';

class AddNewPresetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Text(
          '+',
          style: TextStyle(
            fontSize: 30,
            color: Colors.green,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white10,
        ),
        onPressed: () {
          Navigator.pushNamed(context, GameSettingsPage.routeName);
        });
  }
}
