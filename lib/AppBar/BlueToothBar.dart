
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/BlueTooth/BlueToothHandler.dart';
import 'package:flutter_app/Pages/Pages.dart';


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
  bool popupHasBeenShown = false;
  BlueToothHandler bth = BlueToothHandler();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(children: [
        Text(widget.title),
      ]),
      actions: <Widget>[
        StreamBuilder<blueStates>(
          stream: bth.stateStream.distinct(),
          initialData: bth.lastState,
          builder: (context, snapshot) {
            blueStates state = snapshot.data ?? blueStates.error;

            if (state == blueStates.turnedOff && !popupHasBeenShown){
              openBlueToothSettingsPopUp(context);
            }

            return IconButton(
              icon: _getIcon(state),
              onPressed: () {
                if (state == blueStates.turnedOff){
                  openBlueToothSettingsPopUp(context);
                }
                else {
                  if (widget.title != BlueToothDevicesPage.routeName){
                    Navigator.pushNamed(
                        context, BlueToothDevicesPage.routeName);
                  }
                }
              },
            );
          }
        ),
      ],
    );
  }

  openBlueToothSettingsPopUp(BuildContext context){
    popupHasBeenShown = true;
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


  Icon _getIcon(blueStates state){
    switch(state){
      case blueStates.error:
        return Icon(Icons.device_unknown, color: Colors.red.shade500,);
      case blueStates.notSupported:
        return Icon(Icons.error, color: Colors.red.shade500,);
      case blueStates.unauthorized:
        return Icon(Icons.app_blocking, color: Colors.red.shade500,);
      case blueStates.turnedOff:
        return Icon(Icons.bluetooth_disabled, color: Colors.red.shade500,);
      case blueStates.notConnected:
        return Icon(Icons.bluetooth, color: Colors.red.shade500,);
      case blueStates.scanning:
        return Icon(Icons.bluetooth_searching, color: Colors.red.shade500,);
      case blueStates.connecting:
        return Icon(Icons.bluetooth_searching, color: Colors.yellow.shade500,);
      case blueStates.connected:
        return Icon(Icons.bluetooth_connected, color: Colors.green.shade500,);
    }
  }
}
