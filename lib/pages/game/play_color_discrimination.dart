import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/scoreboard.dart';
import 'package:just_audio/just_audio.dart';
import '../../bluetooth/bluetooth_handler.dart';
import '../../bluetooth/led_display.dart';
import '../../bluetooth/single_target.dart';

class PlayColorDiscrimination extends StatefulWidget{
  final int maxPreRoundDelayMs;
  final int convergencePercent;
  const PlayColorDiscrimination({
    super.key,
    required this.maxPreRoundDelayMs,
    required this.convergencePercent,
  });


  @override
  State<PlayColorDiscrimination> createState() => _PlayColorDiscrimination();
}

class _PlayColorDiscrimination extends State<PlayColorDiscrimination>{
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

    if (BlueToothHandler().targetList.length<2){throw("error, need at least 2 targets for this game") ;}

    int offFromMid = 127; //how far off are the colors from the midpoint of 128

    bool perfection = true;
    while (perfection){
      await Future.delayed(Duration(milliseconds: Random().nextInt(widget.maxPreRoundDelayMs+1))); // add 1 ms in case the user set equal to 0
      int correctTarget = Random().nextInt(2);
      int wrongTarget = (correctTarget-1).abs();
      await LedDisplay().writeOnePaddle(correctTarget, [128+offFromMid,128-offFromMid,0]);
      await LedDisplay().writeOnePaddle(wrongTarget, [128-offFromMid,128+offFromMid,0]);
      offFromMid -= (offFromMid * widget.convergencePercent ~/ 100) + 1;
      if (offFromMid < 0){offFromMid=0;}

      HitResults hitResult = await BlueToothHandler().getHit();
      await LedDisplay().allOff();

      int points = 10000 ~/ hitResult.reactionTime;
      if (hitResult.targetNum == correctTarget){
        scores[0] += points;
        hits[0] += 1;
        reactionTimes[0] = hitResult.reactionTime;
        await player.setAsset('assets/audio/dingDing.mp3');
        player.play();
        await LedDisplay().flashAllTargetsOneLed(0);
      } else {
        perfection = false;
        scores[0] -= points;
        reactionTimes[0] = hitResult.reactionTime;

        await player.setAsset('assets/audio/buzzer.mp3');
        player.play();
        await LedDisplay().flashAllTargetsOneLed(2);
      }
      currentRound += 1;
      currentView = getScoreBoard();
      setState(() {currentView;});

    }
    await Future.delayed(const Duration(seconds:2)); //Give time for any audio to complete
    await player.setAsset('assets/audio/gameOverVoice.mp3');
    player.play();
    currentRound -= 1;
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
      totalRounds: 0,
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