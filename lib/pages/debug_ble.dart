import 'package:flutter/material.dart';
import 'package:flutter_app/bluetooth/characteristics/led_display.dart';
import 'package:flutter_app/bluetooth/bluetooth_handler.dart';

import '../game/game.dart';

class DebugBlePage extends StatefulWidget {
  const DebugBlePage({Key? key}) : super(key: key);

  @override
  State<DebugBlePage> createState() => _DebugBlePage();
}

class _DebugBlePage extends State<DebugBlePage> {
  final BlueToothHandler bth = BlueToothHandler();
  final Game game = Game();
  LedDisplay ledDisplay = LedDisplay();

  @override
  Widget build(BuildContext context) {

    Widget playShootYourColor = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: play shoot your color button pressed');
        game.startShootYourColor();
      },
      child: const Text("Play shoot your color"),
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
      child: const Text("Play sequential memory"),
    );

    Widget playGoNoGo = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: GoNoGo game button pressed');
        game.startGoNoGo();
      },
      child: const Text("Play Go / No-go"),
    );

    Widget playMovingTargets = ElevatedButton(
      onPressed: () {
        debugPrint('debug_ble: play moving target button pressed');
        game.startMovingTargets();
      },
      child: const Text("Play Moving targets"),
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

    List<Text> coloredTextList(scoreList) {
      List<Color> colorOrder = [Colors.red.shade800, Colors.green.shade800, Colors.blue.shade800, Colors.black];
      List<Text> textList = [];
      for (int i =0 ; i < scoreList.length; i++) {
        debugPrint(scoreList[i].toString());
        textList.add( Text(
          scoreList[i].toString(),
          textScaleFactor: 1.5,
          style: TextStyle(
            color: colorOrder[i],
            fontWeight: FontWeight.bold,
          ),
        )
        );
      }
      return textList;
    }

    resultsDisplay(resList) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: coloredTextList(resList),
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
              playColorDisc,
              playMemory,
              playShootYourColor,
              playMovingTargets,
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
