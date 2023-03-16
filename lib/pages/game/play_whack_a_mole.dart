import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/scoreboard.dart';
import 'package:just_audio/just_audio.dart';
import '../../bluetooth/bluetooth_handler.dart';
import '../../bluetooth/led_display.dart';
import '../../bluetooth/single_target.dart';

class PlayWhackAMole extends StatefulWidget{
  final int gameTimeLimitSeconds;
  final int maxPreRoundDelayMs;
  final int percentGo;
  final int timeoutMs;
  const PlayWhackAMole({
    super.key,
    required this.gameTimeLimitSeconds,
    required this.maxPreRoundDelayMs,
    required this.percentGo,
    required this.timeoutMs,
  });


  @override
  State<PlayWhackAMole> createState() => _PlayWhackAMole();
}

class _PlayWhackAMole extends State<PlayWhackAMole>{
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


  Future<void> startGameLogic() async {
    AudioPlayer localPlayer = AudioPlayer();
    await LedDisplay().allOff();
    await localPlayer.setAsset('assets/audio/startMatch.mp3');
    localPlayer.play();
    await countDown();
    clearScores();
    currentView = getScoreBoard();
    setState(() {
      currentView;
    });

    Future.delayed(Duration(seconds: widget.gameTimeLimitSeconds), () {
      endGame();
    });

    for (int i = 0; i < BlueToothHandler().targetList.length; i++) {
      handlePaddle(BlueToothHandler().targetList[i]);
    }
  }

  Future<void> endGame() async {
    continueGame = false;
    await Future.delayed(Duration(milliseconds:widget.timeoutMs + 3000)); //Give time for loops to complete
    AudioPlayer localPlayer = AudioPlayer();
    await localPlayer.setAsset('assets/audio/gameOverVoice.mp3');
    localPlayer.play();
    currentView = makeScoreBoardAndPlayButton();
    setState(() {currentView;});
  }


  Future<void> handlePaddle(SingleTarget target) async {
    AudioPlayer localPlayer = AudioPlayer();
    while (continueGame){
      await Future.delayed(Duration(milliseconds: Random().nextInt(widget.maxPreRoundDelayMs+1))); // add 1 ms in case the user set equal to 0

      bool shouldGo = Random().nextInt(100) < widget.percentGo;

      if (shouldGo){
        await target.writeLED([255,0,0]); // green
      } else {
        if (Random().nextBool()){
          await target.writeLED([0,255,0]); // blue
        } else {
          await target.writeLED([0,0,255]); // red
        }
      }

      Future<HitResults> hR = target.getHit(0);
      Future<HitResults?> timeout = Future.delayed(Duration(milliseconds: widget.timeoutMs), (){return null;});
      HitResults? hitResult = await Future.any([hR, timeout]);
      await target.writeLED([0,0,0]); // Turn the target back off


      if (shouldGo & (hitResult != null)) { // correct go
        debugPrint("game: correct go");
        scores[0] += widget.timeoutMs - hitResult!.reactionTime;
        hits[0] += 1;
        reactionTimes[0] = hitResult.reactionTime;
        await localPlayer.setAsset('assets/audio/dingDing.mp3');
      }
      else if (!shouldGo & (hitResult == null)){
        debugPrint("game: correct no go");
        scores[0] += (widget.timeoutMs*.05).toInt(); //add 5% of max round score for correct no go
        await localPlayer.setAsset('assets/audio/dingDing.mp3');
      }
      else if (shouldGo & (hitResult == null)){
        debugPrint("game: incorrect no go");
        scores[0] -= (widget.timeoutMs*.05).toInt();//subtract 5% of max round score for missed go
        await localPlayer.setAsset('assets/audio/buzzer.mp3');
      }
      else if (!shouldGo & (hitResult != null)){
        debugPrint("game: incorrect go");
        scores[0] -= widget.timeoutMs; //Subtract max score for killing innocents
        await localPlayer.setAsset('assets/audio/buzzer.mp3');
      }
      currentView = getScoreBoard();
      setState(() {currentView;});
      await localPlayer.play();
    }
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

  List<int> hits = [0];
  List<int> reactionTimes = [0];
  List<int> scores =[0];
  bool continueGame = true;
  clearScores(){
    hits = [0];
    reactionTimes = [0];
    scores = [0];
    continueGame = true;
  }

  ScoreBoard getScoreBoard() {
    return ScoreBoard(
      totalRounds: 0,
      currentRound: 0,
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