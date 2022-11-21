import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/bluetooth/bluetooth_handler.dart';

import '../Game/game.dart';

class DebugBlePage extends StatefulWidget {
  DebugBlePage({Key? key}) : super(key: key);

  @override
  State<DebugBlePage> createState() => _DebugBlePage();
}

class _DebugBlePage extends State<DebugBlePage> {
  BlueToothHandler bth = BlueToothHandler();
  Game game = Game();
  final ValueNotifier<int> _notifierNumTargets = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {

    String connectMessage = "connect: # connected = ${bth.targetList.length}";
    Widget connectButton = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: connect button pressed');
        bth.addTarget();
      },
      child: ValueListenableBuilder<int>(
        builder: (BuildContext context, int value, Widget? child) {
          return Text("connect: # connected = ${bth.targetList.length}");},
        valueListenable: _notifierNumTargets,
      ),
    );

    Widget ledRandButton = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: rand button pressed');
        bth.randomColors();
      },
      child: const Text("LED rand intensity"),
    );


    Widget playGameButton = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: Play game button pressed');
        game.start();
      },
      child: const Text("Play a game"),
    );

    Widget paddleNumberButton = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: paddle number button pressed');
        bth.showPaddleNumber();
      },
      child: const Text("Show paddle #"),
    );


    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          connectButton,
          ledRandButton,
          paddleNumberButton,
          playGameButton,
        ],
      ),
    );
  }
}
