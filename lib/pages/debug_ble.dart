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

    Widget playShootYourColor = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: Play game button pressed');
        game.startShootYourColor();
      },
      child: const Text("Play a game"),
    );

    Widget playColorDisc = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: Color Discrimination game button pressed');
        game.startColorDiscrimination();
      },
      child: const Text("Play Color Discrimination"),
    );

    Widget playMemory = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: Memory game button pressed');
        game.startMemorySequence();
      },
      child: const Text("Play Color Discrimination"),
    );

    Widget playGoNoGo = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: Memory game button pressed');
        game.startGoNoGo();
      },
      child: const Text("Play Go / No-go"),
    );

    addTargetAndUpdate() async {
      debugPrint('debug_ble: connect button pressed');
      await bth.addTarget();
      setState(() {});
    }

    Widget connectButton = ElevatedButton(
      onPressed: () {
        addTargetAndUpdate();
      },
      child: Text("connect: # connected = ${bth.targetList.length.toString()}"),
    );

    Widget ledRandButton = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: rand button pressed');
        ledDisplay.randomColors();
      },
      child: const Text("Show paddle #"),
    );

    Widget toggleLedButton = ElevatedButton(
        onPressed: () {
      debugPrint('debug_ble: toggle LED button pressed');
      ledDisplay.toggleIntensity();
    },
      child: const Text("toggle LED intensity"),
    );

    Widget paddleNumberButton = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: paddle number button pressed');
        ledDisplay.cycleLeds();
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

    title(String str) {
      return Center(
          child: Text(str,
              textScaleFactor: 1.5,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )));
    }

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

    return Scaffold(
      body: StreamBuilder(
        stream: game.streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              connectButton,
              const Divider(),
              toggleLedButton,
              const Divider(),
              paddleNumberButton,
              const Divider(),
              playGoNoGo,
              playMemory,
              playShootYourColor,
              playColorDisc,
              title("hits"),
              resultsDisplay(game.correctHits),
              title("score"),
              resultsDisplay(game.score),
              const Divider(),
              forceUpdateButton,
            ],
          );
        },
      ),
    );
  }
}
