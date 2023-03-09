
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../bluetooth/bluetooth_handler.dart';
import '../bluetooth/led_display.dart';
import '../bluetooth/single_target.dart';

class GameGoNoGo{
  int numberOfRounds;
  double maxPreRoundDelaySeconds;
  int percentGo;

  GameGoNoGo({
    this.numberOfRounds = 5,
    this.maxPreRoundDelaySeconds = 3.0,
    this.percentGo = 80,

});

  LedDisplay leds = LedDisplay();
  BlueToothHandler bth = BlueToothHandler();
  Random rng = Random();
  final StreamController<int> streamController = StreamController(); //this is just as a dirty way to force screen rebuilding
  

  // This number needs to be updated before starting a game
  List<int> score =[0];
  List<int> correctHits = [0];
  List<int> reactionTimeArray = [0];
  List<List<int>> offArray = [[0,0,0]]; // array of zeros for all paddles that is often used to turn them all off
  int rNum = 0; // current round number

  preGameUpdate(int numPlayers) async {
    score = List.filled(numPlayers, 0, growable: false); // fill with zeros
    correctHits = List.filled(numPlayers, 0, growable: false); // fill with zeros
    reactionTimeArray = List.filled(numPlayers, 0, growable: false); // fill with zeros
    offArray = leds.genUniformColorArray(val:0);
    await leds.writeLEDs(offArray);
    rNum = 0;
    streamController.add(rNum);
    await Future.delayed(const Duration(milliseconds: 3000));

  }

  Future<void> startGoNoGo() async {
    await preGameUpdate(1); // 1 players using 1 paddle
    int goPercent = 80;

    int numRounds = 4;

    AudioPlayer player = AudioPlayer();
    debugPrint("game: numRounds = $numRounds");

    while (rNum < numRounds){
      await Future.delayed(Duration(milliseconds: rng.nextInt(4000)));

      int rand100 = rng.nextInt(100);
      bool shouldGo = rand100 < goPercent;

      if (shouldGo){
        await leds.writeOnePaddle(0, [255,0,0]); // green on paddle #1
      } else {
        if (rng.nextBool()){
          await leds.writeOnePaddle(0, [0,255,0]); // blue on paddle #1
        } else {
          await leds.writeOnePaddle(0, [0,0,255]); // red on paddle #1
        }
      }

      debugPrint("game: Waiting for hit");
      Future<HitResults> hR = bth.getHit();
      int timeoutMs = 4000;
      Future<HitResults?> timeout = Future.delayed(Duration(milliseconds: timeoutMs), (){return null;});

      HitResults? hitResult = await Future.any([hR, timeout]);
      debugPrint("game: hit detected or timeout reached");
      await leds.writeOnePaddle(0, [0,0,0]); // Turn the target back off
      debugPrint("game: paddle turned back off");


      if (shouldGo & (hitResult != null)) { // correct go
        debugPrint("game: correct go");
        score[0] += timeoutMs - hitResult!.reactionTime;
        correctHits[0] += 1;
        reactionTimeArray[0] = hitResult.reactionTime;
        await player.setAsset('assets/audio/dingDing.mp3');
      }
      else if (!shouldGo & (hitResult == null)){
        debugPrint("game: correct no go");
        await player.setAsset('assets/audio/dingDing.mp3');
      } else if (shouldGo & (hitResult == null)){
        debugPrint("game: incorrect no go");
        score[0] -= timeoutMs;
        await player.setAsset('assets/audio/buzzer.mp3');
      } else if (!shouldGo & (hitResult != null)){
        debugPrint("game: incorrect go");
        score[0] -= timeoutMs;
        await player.setAsset('assets/audio/owOw.mp3');
      }
      await player.play();

      debugPrint("game: correct hits = $correctHits");
      streamController.add(correctHits[0]);
      debugPrint("game: written to stream controller");

      await Future.delayed(const Duration(milliseconds: 1000));
      if (shouldGo){rNum++;}
    }
    debugPrint("game: game over");
  }
}