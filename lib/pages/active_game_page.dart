import 'package:flutter/material.dart';
import 'package:flutter_app/bluetooth/led_display.dart';
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

    title(String str) {
      return Center(
          child: Text(str,
              textScaleFactor: 1.5,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )));
    }

    List<Text> coloredTextList(scoreList) {
      List<Color> colorOrder = [
        Colors.green.shade800,
        Colors.blue.shade800,
        Colors.red.shade800,
      ];
      List<Text> textList = [];
      for (int i = 0; i < scoreList.length; i++) {
        debugPrint(scoreList[i].toString());
        textList.add(Text(
          scoreList[i].toString(),
          textScaleFactor: 1.5,
          style: TextStyle(
            color: colorOrder[i],
            fontWeight: FontWeight.bold,
          ),
        ));
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
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                title("Round: ${game.rNum+1}/ ${game.numRounds}"),
                title("hits"),
                resultsDisplay(game.correctHits),
                title("reaction time (ms)"),
                resultsDisplay(game.reactionTimeArray),
                title("score"),
                resultsDisplay(game.score),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ResultsDisplay extends StatelessWidget {



  @override
  Widget build(BuildContext context) {



    return Column(
      children: [

      ],

    );

  }

}
