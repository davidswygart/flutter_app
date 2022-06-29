import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/BlueTooth/BlueToothHandler.dart';
import 'package:flutter_blue/flutter_blue.dart';

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
              onPressed: () async {
                FlutterBlue fb = FlutterBlue.instance;
                bool isScan = await fb.isScanning.first;
                debugPrint("BluetoothHandler: Is scanning " + isScan.toString());

              },
              child: Text('OFF')),
        ],
      ),
    );
  }
}
