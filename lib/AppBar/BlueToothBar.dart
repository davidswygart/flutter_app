
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/BlueTooth/BlueServices.dart';

import '../BlueTooth/PossibleStates.dart';


class BlueToothBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  BlueToothBar({Key? key, this.title = 'HTT'}) : super(key: key);


  @override
  Size get preferredSize {
    return new Size.fromHeight(50);
  }

  @override
  State<StatefulWidget> createState() {
    return _BlueToothBar();
  }
}

class _BlueToothBar extends State<BlueToothBar> {
  final Map<String,Icon> btIcons = {
    ConnectionStates.notSupported: Icon(
      Icons.error,
      color: Colors.red.shade500,
    ),
    ConnectionStates.blueToothDisabled: Icon(
      Icons.bluetooth_disabled,
      color: Colors.red.shade500,
    ),
    ConnectionStates.notConnected: Icon(
      Icons.bluetooth,
      color: Colors.red.shade500,
    ),
    ConnectionStates.connecting: Icon(
      Icons.bluetooth_searching,
      color: Colors.yellow.shade500,
    ),
    ConnectionStates.connected: Icon(
      Icons.bluetooth_connected,
      color: Colors.green.shade400,
    ),
  };
  bool settingsNotOpen = true;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(children: [
        Text(widget.title),
      ]),
      actions: <Widget>[
        StreamBuilder<String>(
          stream: BlueServices.getStateStream(),
          initialData: ConnectionStates.notSupported,
          builder: (context, snapshot) {
            if (snapshot.data == ConnectionStates.blueToothDisabled && settingsNotOpen) {
              settingsNotOpen = false;
              openBlueToothSettings(context);
            }

            return IconButton(
              icon: btIcons[snapshot.data] ?? Icon(Icons.error),
              onPressed: () {
/*                if (btUp.connectionState == ConnectionStates.blueToothDisabled){
                  openBlueToothSettings(context);
                }*/
              }
            );
          }
        ),
      ],
    );
  }

  openBlueToothSettings(BuildContext context){
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Turn on bluetooth in your phone settings'),
            content: Row(
              children: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {Navigator.of(context).pop();},
                ),
                TextButton(
                  child: Text('Settings'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    AppSettings.openBluetoothSettings();
                    },
                ),
              ],
            ),
          );
        },
      );
    });
  }
}



