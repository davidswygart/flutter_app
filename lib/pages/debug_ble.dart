import 'package:flutter/material.dart';
import 'package:flutter_app/bluetooth/characteristics/led_display.dart';
import 'package:flutter_app/bluetooth/bluetooth_handler.dart';
import 'package:flutter_app/bluetooth/single_target.dart';

import '../game/game.dart';

class DebugBlePage extends StatefulWidget {
  DebugBlePage({Key? key}) : super(key: key);

  @override
  State<DebugBlePage> createState() => _DebugBlePage();
}

class _DebugBlePage extends State<DebugBlePage> {
  final BlueToothHandler bth = BlueToothHandler();
  final Game game = Game();
  LedDisplay ledDisplay = LedDisplay();
  final ValueNotifier<List<SingleTarget>> _notifierTargets =
      ValueNotifier<List<SingleTarget>>(BlueToothHandler().targetList);
  int testNum = 0;

  @override
  Widget build(BuildContext context) {

    title(String str) {
      return Center(
          child: Text(str,
              textScaleFactor: 1.5,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )));
    }

    Widget playGameButton = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: Play game button pressed');
        game.start();
      },
      child: const Text("Play a game"),
    );

    Widget connectButton = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: connect button pressed');
        bth.addTarget();
      },
      child: Text("connect: # connected = ${bth.targetList.length.toString()}"),
    );

    coloredText(int val, Color color) {
      return Text(
        val.toString(),
        textScaleFactor: 1.5,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    resultsDisplay(resList) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            coloredText(resList[0], Colors.red),
            coloredText(resList[1], Colors.green),
          ],
        ),
      );
    }

    Widget ledRandButton = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: rand button pressed');
        ledDisplay.randomColors();
      },
      child: const Text("LED rand intensity"),
    );

    Widget paddleNumberButton = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: paddle number button pressed');
        ledDisplay.showPaddleNumber();
      },
      child: const Text("Show paddle #"),
    );

    Widget forceUpdateButton = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: force update button pressed');
        setState(() {});
      },
      child: const Text("force update"),
    );

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
          const Divider(),
          forceUpdateButton,
        ],
      ),
    );
  }
}
