import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/BlueTooth/BlueToothHandler.dart';

class DebugBle extends StatelessWidget {
  const DebugBle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlueToothHandler bth = BlueToothHandler();
    return Center(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: (){
                BlueToothHandler bth = BlueToothHandler();
                bth.attemptConnect();
              },
              child: Text('Pair')),
          ElevatedButton(
              onPressed: (){
                Navigator.
              },
              child: Text('OFF')),
        ],
      ),
    );
  }
}
