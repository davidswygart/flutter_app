
import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/scoreboard.dart';
import 'package:just_audio/just_audio.dart';

import '../../bluetooth/bluetooth_handler.dart';
import '../../bluetooth/led_display.dart';
import '../../bluetooth/single_target.dart';

class PlayShootYourColor extends StatefulWidget{
  final int numberOfRounds;
  final int maxPreRoundDelayMs;

  const PlayShootYourColor({
    super.key,
    required this.numberOfRounds,
    required this.maxPreRoundDelayMs,
  });


  @override
  State<PlayShootYourColor> createState() => _PlayShootYourColor();
}

class _PlayShootYourColor extends State<PlayShootYourColor>{
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
      await LedDisplay().writeSingleColorPerPaddle(colors);
      HitResults hitResult = await BlueToothHandler().getHit();
      await LedDisplay().allOff();

      int winner = colors[hitResult.targetNum];
      await LedDisplay().flashAllTargetsOneLed(winner);

      scores[winner] += (100000 / hitResult.reactionTime).round();
      hits[winner] += 1;
      reactionTimes[winner] = hitResult.reactionTime;

      currentView = getScoreBoard();
      setState(() {currentView;});
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