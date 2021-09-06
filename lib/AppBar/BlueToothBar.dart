import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';

class BlueToothBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const BlueToothBar({Key? key, this.title = 'HTT'}) : super(key: key);

  @override
  Size get preferredSize {
    return new Size.fromHeight(50);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title), actions: <Widget>[
      Padding(
        padding: EdgeInsets.all(5),
        child: GFButton(
          onPressed: () {},
          text: "Connected",
          icon: Icon(Icons.bluetooth),
        ),
      )
    ]);
  }
}
