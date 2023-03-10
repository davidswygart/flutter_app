
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/scoreboard.dart';
import 'package:just_audio/just_audio.dart';

import '../../bluetooth/bluetooth_handler.dart';
import '../../bluetooth/led_display.dart';
import '../../bluetooth/single_target.dart';

class PlayMovingTarget extends StatefulWidget{
  final int numberOfRounds;
  final int maxPreRoundDelayMs;
  final int pauseMillis;

  const PlayMovingTarget({
    super.key,
    required this.numberOfRounds,
    required this.maxPreRoundDelayMs,
    required this.pauseMillis,
  });

  @override
  State<PlayMovingTarget> createState() => _PlayMovingTarget();
}

class _PlayMovingTarget extends State<PlayMovingTarget>{
  Widget currentView = const Text("loading");


  @override
  void initState() {
    startGameLogic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: currentView,);
  }

  AudioPlayer player = AudioPlayer();
  Future<void> startGameLogic() async {
    await LedDisplay().allOff();
    await countDown();
    clearScores();
    currentView = getScoreBoard();
    setState(() {currentView;});


    for (currentRound=0; currentRound<widget.numberOfRounds;currentRound++){
      await Future.delayed(Duration(milliseconds: Random().nextInt(widget.maxPreRoundDelayMs+1))); // add 1 ms in case the user set equal to 0
      List<int> colors = List<int>.generate(numPlayers, (i) => i);
      colors.shuffle(); //Index is the paddle, Value is the color

      bool hitDetected = false;
      int numCycled = 1;
      Future(() async {
        while(!hitDetected){
          colors.add(colors[0]); // add the first color to the end
          colors.removeAt(0); // remove the first color
          await LedDisplay().writeSingleColorPerPaddle(colors);
          await Future.delayed(Duration(milliseconds: widget.pauseMillis));
          numCycled++;
        }
      });
      HitResults hitResult = await BlueToothHandler().getHit();
      hitDetected = true;

      int winner = colors[hitResult.targetNum];
      int points = (100 / numCycled).round();

      scores[winner] += points;
      hits[winner] += 1;
      reactionTimes[winner] = hitResult.reactionTime;
      currentView = getScoreBoard();
      setState(() {currentView;});

      await Future.delayed(const Duration(milliseconds: 100));
      await LedDisplay().flashAllTargetsOneLed(winner);
      await LedDisplay().allOff(); // I waited to turn it off until now in case the moving loop is still running
    }
    currentRound -= 1; //subtract round by 1 for display purposes
    currentView = makeScoreBoardAndPlayButton();
    setState(() {currentView;});
  }

  countDown() async {
    int startVal = 5;
    int delaySeconds = 1;
    for (int i=startVal; i>0; i--){
      currentView = Text(i.toString(), textScaleFactor: 5,);
      setState(() {currentView;});
      await Future.delayed(Duration(seconds: delaySeconds));
    }
  }

  late int numPlayers;
  late int currentRound;
  late List<int> hits;
  late List<int> reactionTimes;
  late List<int> scores;
  clearScores(){
    numPlayers = BlueToothHandler().targetList.length;
    currentRound = 0;
    hits = List.filled(numPlayers, 0, growable: false);
    reactionTimes = List.filled(numPlayers, 0, growable: false);
    scores = List.filled(numPlayers, 0, growable: false);
  }

  ScoreBoard getScoreBoard() {
    return ScoreBoard(
      totalRounds: widget.numberOfRounds,
      currentRound: currentRound,
      hits: hits,
      reactionTimes: reactionTimes,
      scores: scores,
    );
  }

  Widget makeScoreBoardAndPlayButton(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getScoreBoard(),
          makePlayAgainButton(),
        ],
    );
  }

  makePlayAgainButton() {
    return ElevatedButton(
      onPressed: () {
        startGameLogic();
      },
      child: const Text('Play again', textScaleFactor: 1.5,),
    );
  }
}