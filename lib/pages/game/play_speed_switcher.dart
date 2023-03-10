
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/scoreboard.dart';
import 'package:just_audio/just_audio.dart';

import '../../bluetooth/bluetooth_handler.dart';
import '../../bluetooth/led_display.dart';
import '../../bluetooth/single_target.dart';

class PlaySpeedSwitcher extends StatefulWidget{
  final int numberOfRounds;
  final int maxPreRoundDelayMs;
  final int speedDecreasePercent;

  const PlaySpeedSwitcher({
    super.key,
    required this.numberOfRounds,
    required this.maxPreRoundDelayMs,
    required this.speedDecreasePercent,
  });


  @override
  State<PlaySpeedSwitcher> createState() => _PlaySpeedSwitcher();
}

class _PlaySpeedSwitcher extends State<PlaySpeedSwitcher>{
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

    for (currentRound=0; currentRound<widget.numberOfRounds;currentRound++){
      await Future.delayed(Duration(milliseconds: Random().nextInt(widget.maxPreRoundDelayMs+1))); // add 1 ms in case the user set equal to 0
      List<int> ledArray = [0,1,2]; // Index RGBW
      ledArray.shuffle();
      bool hitDetected = false;
      int currentArrayIndex = 0;
      int currentLed = 0;
      int delay = 100; // delay starts at 100 ms

      Future(() async {
        while(!hitDetected){
          currentLed = ledArray[currentArrayIndex];
          await LedDisplay().writeOnePaddleOneColor(0, currentLed); // Only write the first target
          currentArrayIndex++;
          if (currentArrayIndex == ledArray.length){currentArrayIndex = 0;} // restart at beginning of array
          await Future.delayed(Duration(milliseconds: delay));
          delay += (delay * widget.speedDecreasePercent / 100).round(); //increase delay by certain proportion
        }
      });

      HitResults hitResult = await BlueToothHandler().getHit();
      hitDetected = true;
      await player.setAsset('assets/audio/dingDing.mp3');
      player.play();

      scores[currentLed] += (100000 / delay).round();
      hits[currentLed] += 1;
      reactionTimes[currentLed] = hitResult.reactionTime;
      await LedDisplay().flashAllTargetsOneLed(currentLed);
      currentView = getScoreBoard();
      setState(() {currentView;});
    }
    int winningPlayer = 0;
    for (int i=0; i<scores.length;i++) {
      if (scores[i] > scores[winningPlayer]) {winningPlayer = i;}
    }
    List<String> audioClips = ["GreenWins", "BlueWins", "RedWins"];
    await player.setAsset('assets/audio/${audioClips[winningPlayer]}.mp3');
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

  int currentRound = 0;
  List<int> hits = [0,0,0];
  List<int> reactionTimes = [0,0,0];
  List<int> scores =[0,0,0];
  clearScores(){
    currentRound = 0;
    hits = [0,0,0];
    reactionTimes = [0,0,0];
    scores = [0,0,0];
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