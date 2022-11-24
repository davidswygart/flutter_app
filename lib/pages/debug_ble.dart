import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/bluetooth/characteristics/led_display.dart';
import 'package:flutter_app/bluetooth/bluetooth_handler.dart';

import '../Game/game.dart';

class DebugBlePage extends StatefulWidget {
  DebugBlePage({Key? key}) : super(key: key);

  @override
  State<DebugBlePage> createState() => _DebugBlePage();
}

class _DebugBlePage extends State<DebugBlePage> {
  BlueToothHandler bth = BlueToothHandler();
  LedDisplay ledDisplay = LedDisplay();
  final ValueNotifier<int> _notifierNumTargets = ValueNotifier<int>(0);
  Game game = Game();


  @override
  Widget build(BuildContext context) {

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
        ledDisplay.randomColors();
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
        ledDisplay.showPaddleNumber();
      },
      child: const Text("Show paddle #"),
    );

    title(String str){
      return Center(
          child: Text( str,
              textScaleFactor: 1.5,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )));
    }

    resultsDisplay(resList) {
      return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(resList[0].toString(),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 1.5,
              ),
              Text(resList[1].toString(),
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 1.5,
              ),
            ],
          )
      );
    }

      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            connectButton,
            const Divider(),
            ledRandButton,
            const Divider(),
            paddleNumberButton,
            const Divider(),
            playGameButton,
            title("hits"),
            resultsDisplay(game.correctHits),
            title("score"),
            resultsDisplay(game.score),
          ],
        ),
      );
    }
  }
