
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/scoreboard.dart';
import 'package:just_audio/just_audio.dart';

import '../../bluetooth/bluetooth_handler.dart';
import '../../bluetooth/led_display.dart';
import '../../bluetooth/single_target.dart';

class PlaySimoneSays extends StatefulWidget{
  final int numberOfRounds;
  final int maxPreRoundDelayMs;

  const PlaySimoneSays({
    super.key,
    required this.numberOfRounds,
    required this.maxPreRoundDelayMs,
  });


  @override
  State<PlaySimoneSays> createState() => _PlaySimoneSays();
}

class _PlaySimoneSays extends State<PlaySimoneSays>{
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
    await player.setAsset('assets/audio/startMatch.mp3');
    player.play();
    await countDown();
    clearScores();
    currentView = getScoreBoard();
    setState(() {currentView;});
    int numPaddles = BlueToothHandler().targetList.length;
    List<String> colorList = ["green","blue","red"];

    for (currentRound=0; currentRound<widget.numberOfRounds;currentRound++){
      await Future.delayed(Duration(milliseconds: Random().nextInt(widget.maxPreRoundDelayMs+1))); // add 1 ms in case the user set equal to 0
      List<int> colors = List<int>.generate(numPaddles, (i) => i);
      colors.shuffle(); //Index is the paddle, Value is the color
      int correctPaddle = Random().nextInt(numPaddles);
      String correctColor = colorList[colors[correctPaddle]];
      await LedDisplay().writeSingleColorPerPaddle(colors);
      await player.setAsset('assets/audio/$correctColor.mp3');
      await player.play();
      HitResults hitResult = await BlueToothHandler().getHit();
      await LedDisplay().allOff();

      if (hitResult.targetNum == correctPaddle){
        await player.setAsset('assets/audio/dingDing.mp3');
        scores[0] += (10000 / hitResult.reactionTime).round();
        hits[0] += 1;
      } else {
        await player.setAsset('assets/audio/buzzer.mp3');
        scores[0] -= 5000;
      }
      await player.play();

      reactionTimes[0] = hitResult.reactionTime;
      currentView = getScoreBoard();
      setState(() {currentView;});
    }

    await Future.delayed(const Duration(seconds:2)); //Give time for any audio to complete
    await player.setAsset('assets/audio/gameOverVoice.mp3');
    await player.play();

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

  late int currentRound;
  late List<int> hits;
  late List<int> reactionTimes;
  late List<int> scores;
  clearScores(){
    currentRound = 0;
    hits = [0];
    reactionTimes = [0];
    scores = [0];
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