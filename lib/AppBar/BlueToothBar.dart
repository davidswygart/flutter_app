import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';

class BlueToothBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  const BlueToothBar({Key? key, this.title = 'HTT'}) : super(key: key);

  @override
  Size get preferredSize {
    return new Size.fromHeight(50);
  }

  @override
  State<StatefulWidget> createState() {
    return _BlueToothBar();
  }
}

class _BlueToothBar extends State<BlueToothBar>{
  static const List<String> possibleStates = [
    'Disconnected',
    'Pending',
    'Connected',
  ];
  static const List<MaterialColor> possibleColors = [
    Colors.red,
    Colors.yellow,
    Colors.green
  ];

  String currentState = possibleStates[0];
  MaterialColor currentColor = possibleColors[0];

  int sillyCounter = 0;


  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(widget.title), actions: <Widget>[
      Container(
        padding: EdgeInsets.all(5),
        child: GFButton(
          //focusColor: currentColor,
          //splashColor: currentColor,
          //highlightColor: currentColor,
          color: currentColor,
          onPressed: () {
            sillyCounter = (sillyCounter+1) % 3;
            setState(() {
              currentColor = possibleColors[sillyCounter];
              currentState = possibleStates[sillyCounter];
            });
            },
          text: currentState,
          icon: Icon(Icons.bluetooth),
        ),
      )
    ]);
  }
}
