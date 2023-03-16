import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/game/scoreboard.dart';
import 'package:just_audio/just_audio.dart';
import '../../bluetooth/bluetooth_handler.dart';
import '../../bluetooth/led_display.dart';
import '../../bluetooth/single_target.dart';

class PlayMemory extends StatefulWidget {
  final int maxPreRoundDelayMs;
  final int flashDelayMs;

  const PlayMemory({
    super.key,
    required this.maxPreRoundDelayMs,
    required this.flashDelayMs,
  });

  @override
  State<PlayMemory> createState() => _PlayMemory();
}

class _PlayMemory extends State<PlayMemory> {
  Widget currentView = const Text("loading");

  @override
  void initState() {
    startGameLogic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: currentView,
    );
  }

  AudioPlayer player = AudioPlayer();
  Future<void> startGameLogic() async {
    await LedDisplay().allOff();
    await player.setAsset('assets/audio/startMatch.mp3');
    player.play();
    await countDown();
    clearScores();
    currentView = getScoreBoard();
    setState(() {
      currentView;
    });

    bool perfection = true;
    while (perfection) {
      await Future.delayed(Duration(milliseconds: Random().nextInt(widget.maxPreRoundDelayMs+1))); // add 1 ms in case the user set equal to 0
      List<int> paddleSequence = [];
      for (int i = 0; i < currentRound + 1; i++) {
        int chosenPaddle = Random().nextInt(BlueToothHandler().targetList.length);
        paddleSequence.add(chosenPaddle);
        await LedDisplay().writeOnePaddle(chosenPaddle, [0, 255, 0]); //write the paddle green
        await Future.delayed(Duration(milliseconds: widget.flashDelayMs));
        await LedDisplay().writeOnePaddle(chosenPaddle, [0, 0, 0]);
        await Future.delayed(const Duration(milliseconds: 100)); // needs to turn off for a brief period to distinguish from long on period
      }

      await player.setAsset('assets/audio/GoVoice.mp3');
      player.play();
      await LedDisplay().flashAllTargetsOneLed(0, numBlinks: 1);

      bool continueSubround = true;
      int subRoundNum = 0;
      while (continueSubround) {
        HitResults hitResult = await BlueToothHandler().getHit();
        await player.setAsset('assets/audio/clash.mp3');
        player.play();

        if (paddleSequence[subRoundNum] == hitResult.targetNum) {
          scores[0] += 100 ~/ hitResult.reactionTime;
          hits[0] += 1;
          reactionTimes[0] = hitResult.reactionTime;
        } else {
          perfection = false;
          continueSubround = false;
        }

        currentView = getScoreBoard();
        setState(() {
          currentView;
        });

        if (subRoundNum >= currentRound) {
          continueSubround = false;
        }
        subRoundNum++;
      }
      currentRound++;
      if(perfection){
        await player.setAsset('assets/audio/dingDing.mp3');
        player.play();
        await LedDisplay().flashAllTargetsOneLed(0);
      } else {
        await player.setAsset('assets/audio/buzzer.mp3');
        player.play();
        await LedDisplay().flashAllTargetsOneLed(2);
      }
    }
    await Future.delayed(const Duration(seconds:2)); //Give time for any audio to complete
    await player.setAsset('assets/audio/gameOverVoice.mp3');
    player.play();
    currentRound -= 1;
    currentView = makeScoreBoardAndPlayButton();
    setState(() {
      currentView;
    });
  }

  countDown() async {
    int startVal = 5;
    int delaySeconds = 1;
    for (int i = startVal; i > 0; i--) {
      currentView = Text(
        i.toString(),
        textScaleFactor: 5,
      );
      setState(() {
        currentView;
      });
      await Future.delayed(Duration(seconds: delaySeconds));
    }
  }

  late int currentRound;
  late List<int> hits;
  late List<int> reactionTimes;
  late List<int> scores;
  clearScores() {
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

  Widget makeScoreBoardAndPlayButton() {
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
      child: const Text(
        'Play again',
        textScaleFactor: 1.5,
      ),
    );
  }
}
