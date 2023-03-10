
import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/scoreboard.dart';
import 'package:just_audio/just_audio.dart';

import '../../bluetooth/bluetooth_handler.dart';
import '../../bluetooth/led_display.dart';
import '../../bluetooth/single_target.dart';

class PlayGoNoGo extends StatefulWidget{
  final int numberOfRounds;
  final int maxPreRoundDelayMs;
  final int percentGo;
  final int timeoutMs;
  const PlayGoNoGo({
    super.key,
    required this.numberOfRounds,
    required this.maxPreRoundDelayMs,
    required this.percentGo,
    required this.timeoutMs,
  });


  @override
  State<PlayGoNoGo> createState() => _PlayGoNoGo();
}

class _PlayGoNoGo extends State<PlayGoNoGo>{
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

    while (currentRound < widget.numberOfRounds){
      await Future.delayed(Duration(milliseconds: Random().nextInt(widget.maxPreRoundDelayMs+1))); // add 1 ms in case the user set equal to 0
      bool shouldGo = Random().nextInt(100) < widget.percentGo;

      if (shouldGo){
        await LedDisplay().writeOnePaddle(0, [255,0,0]); // green on paddle #1
      } else {
        if (Random().nextBool()){
          await LedDisplay().writeOnePaddle(0, [0,255,0]); // blue on paddle #1
        } else {
          await LedDisplay().writeOnePaddle(0, [0,0,255]); // red on paddle #1
        }
      }

      Future<HitResults> hR = BlueToothHandler().getHit();
      Future<HitResults?> timeout = Future.delayed(Duration(milliseconds: widget.timeoutMs), (){return null;});
      HitResults? hitResult = await Future.any([hR, timeout]);
      await LedDisplay().writeOnePaddle(0, [0,0,0]); // Turn the target back off

      if (shouldGo & (hitResult != null)) { // correct go
        debugPrint("game: correct go");
        scores[0] += widget.timeoutMs - hitResult!.reactionTime;
        hits[0] += 1;
        reactionTimes[0] = hitResult.reactionTime;
        await player.setAsset('assets/audio/dingDing.mp3');
      }
      else if (!shouldGo & (hitResult == null)){
        debugPrint("game: correct no go");
        scores[0] += (widget.timeoutMs*.05).toInt(); //add 5% of max round score for correct no go
        await player.setAsset('assets/audio/dingDing.mp3');
      }
      else if (shouldGo & (hitResult == null)){
        debugPrint("game: incorrect no go");
        scores[0] -= (widget.timeoutMs*.05).toInt();//subtract 5% of max round score for missed go
        await player.setAsset('assets/audio/buzzer.mp3');
      }
      else if (!shouldGo & (hitResult != null)){
        debugPrint("game: incorrect go");
        scores[0] -= widget.timeoutMs; //Subtract max score for killing innocents
        await player.setAsset('assets/audio/owOw.mp3');
      }
      currentView = getScoreBoard();
      setState(() {currentView;});
      player.play();

      if (shouldGo){currentRound++;}
    }
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

  int currentRound = 0;
  List<int> hits = [0];
  List<int> reactionTimes = [0];
  List<int> scores =[0];
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