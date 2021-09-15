import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:provider/provider.dart';

import 'BlueToothUpdater.dart';

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
  static Map<String, Color> statusColors = {
    'Not connected': Colors.red.shade500,
    'Connecting': Colors.yellow.shade500,
    'Connected': Colors.green.shade500,
  };

  int sillyCounter = 0;



  @override
  Widget build(BuildContext context) {
/*    return Consumer<BlueToothUpdater>(
      builder: (context, bt, child) {
        if (bt.stateMessage.isNotEmpty){
          GFToast.showToast('hi', context, toastDuration: 5,);
          bt.stateMessage = '';
        }*/

        return AppBar(
          title: Column(children: [
            Text(widget.title),
          ]),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              child: GFButton(
                color: statusColors.values.toList()[sillyCounter],     //statusColors[bt.currentState] ??= Colors.grey,
                onPressed: () {advanceExample();},//changeMessage();},
                text: statusColors.keys.toList()[sillyCounter],   //bt.stateMessage,//currentState,
                icon: Icon(Icons.bluetooth),
              ),
            ),
          ],
        );
      //},
    //);
  }

/*  void changeMessage() {
    final btUp = Provider.of<BlueToothUpdater>(context, listen: false);
    btUp.changeMessage();
  }*/

  void advanceExample(){
    setState(() {
      sillyCounter = (sillyCounter+1)%3;
    });

  }

}
