import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/bluetooth/bluetooth_handler.dart';
import 'package:just_audio/just_audio.dart';

import '../bluetooth/led_display.dart';
import '../bluetooth/single_target.dart';


class Game {

  LedDisplay leds = LedDisplay();
  BlueToothHandler bth = BlueToothHandler();
  Random rng = Random();
  final StreamController<int> streamController = StreamController(); //this is just as a dirty way to force screen rebuilding

  int numRounds = 4;

  // This number needs to be updated before starting a game
  List<int> score =[0];
  List<int> correctHits = [0];
  List<int> reactionTimeArray = [0];
  List<List<int>> offArray = [[0,0,0,0]]; // array of zeros for all paddles that is often used to turn them all off
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

    AudioPlayer player = AudioPlayer();
    debugPrint("game: numRounds = $numRounds");

    while (rNum < numRounds){
      await Future.delayed(Duration(milliseconds: rng.nextInt(4000)));

      bool shouldGo = rng.nextBool();
      if (shouldGo){
        await leds.writeOnePaddle(0, [0,255,0,0]); // assumes single paddle and uses the first one on the list
      } else {
        int redInt = rng.nextInt(255);
        int blueInt = 255-redInt; // use a random combination of red and blue for No Go
        await leds.writeOnePaddle(0, [redInt,0,blueInt,0]);
      }

      debugPrint("game: Waiting for hit");
      Future<HitResults> hR = bth.getHit();
      int timeoutMs = 4000;
      Future<HitResults?> timeout = Future.delayed(Duration(milliseconds: timeoutMs), (){return null;});

      HitResults? hitResult = await Future.any([hR, timeout]);
      debugPrint("game: hit detected or timeout reached");
      await leds.writeOnePaddle(0, [0,0,0,0]); // Turn the target back off
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

  Future<void> startSingleSwitcher() async {
    await preGameUpdate(4); // 4 players using 1 paddle

    for (rNum = 0; rNum<numRounds; rNum++){
      await Future.delayed(Duration(milliseconds: rng.nextInt(1000)));
      List<int> ledArray = [0,1,2,3]; // Index RGBW

      ledArray.shuffle();

      bool hitDetected = false;
      int currentArrayIndex = 0;
      int currentLed = 0;
      int delayMillis = 10;
      Future(() async {
        while(!hitDetected){
          currentLed = ledArray[currentArrayIndex];
          await leds.writeOnePaddleOneColor(0, currentLed); // Only write the first target
          currentArrayIndex++;
          if (currentArrayIndex == ledArray.length){currentArrayIndex = 0;} // restart at beginning of array
          await Future.delayed(Duration(milliseconds: delayMillis));
          delayMillis = (delayMillis * 1.05).round(); //increase delay by 5%
          debugPrint("game: current delay = $delayMillis");
        }
      });
      HitResults hitResult = await bth.getHit();
      hitDetected = true;
      await Future.delayed(const Duration(milliseconds: 100));


      score[currentLed] += (100000 / delayMillis).round();
      correctHits[currentLed] += 1;
      reactionTimeArray[currentLed] = hitResult.reactionTime;
      await leds.flashAllTargetsOneLed(currentLed);

      debugPrint("game: Hit paddle = ${hitResult.targetNum}");
      debugPrint("game: Reaction time = ${hitResult.reactionTime}");
      debugPrint("game: correct hits = $correctHits");

      streamController.add(rNum);

      await Future.delayed(const Duration(milliseconds: 1000));
      await leds.writeLEDs(offArray); // I waited to turn it off until now in case the moving loop is still running
    }
    debugPrint("game: game over");
  }

  Future<void> startMemorySequence() async {
    await preGameUpdate(1); // 1 players using all paddle
    bool perfection = true;

    while (perfection){
      debugPrint("game: Round # $rNum");
      await Future.delayed(Duration(milliseconds: rng.nextInt(4000)));

      List<int> paddleSequence = [];
      for (int i=0; i<rNum+1; i++){
        int chosenPaddle = rng.nextInt(bth.targetList.length);
        paddleSequence.add(chosenPaddle);
        await leds.writeOnePaddle(chosenPaddle, [0,255,0,0]); //write the paddle green
        await Future.delayed(const Duration(milliseconds: 500));
        await leds.writeOnePaddle(chosenPaddle, [0,0,0,0]);
        await Future.delayed(const Duration(milliseconds: 100));
      }
      debugPrint("game: correct sequence # $paddleSequence");

      bool continueSubround = true;
      int subRoundNum = 0;
      while(continueSubround){
        debugPrint("game: subround # $subRoundNum");
        debugPrint("game: Waiting for hit");
        HitResults hitResult = await bth.getHit();
        debugPrint("game: Hit paddle = ${hitResult.targetNum}");
        debugPrint("game: Reaction time = ${hitResult.reactionTime}");

        if (paddleSequence[subRoundNum] == hitResult.targetNum){
          double points = (subRoundNum+1) * 100000 / hitResult.reactionTime;
          score[0] += points.round();
          correctHits[0] += 1;
          reactionTimeArray[0] = hitResult.reactionTime;
        } else {
          perfection = false;
          continueSubround = false;
          await leds.flashAllTargetsOneLed(0);
        }

        streamController.add(subRoundNum);
        if (subRoundNum == rNum){
          continueSubround = false;
        }
        subRoundNum++;
      }
      rNum++;
    }
    debugPrint("game: game over");
  }

  Future<void> startColorDiscrimination() async {
    await preGameUpdate(1); // 1 players using 2 paddles
    bool perfection = true;
    int moreGreen = 125;
    List<int> equalMix = [128,128,50,50];
    List<int> usedTargets = [0,1]; // Needs 2 targets and only uses the first 2

    if (bth.targetList.length<2){throw("error, need at least 2 targets for this game") ;}

    while (perfection){
      await Future.delayed(Duration(milliseconds: rng.nextInt(4000)));

      List<int> greenerMix = List<int>.from(equalMix);
      greenerMix[0] -= moreGreen;
      greenerMix[1] += moreGreen;
      moreGreen = ((moreGreen-1)*0.8).round();

      usedTargets.shuffle();
      int greenerTarget = usedTargets[0];
      int redderTarget = usedTargets[1];

      await leds.writeOnePaddle(greenerTarget, greenerMix);
      await leds.writeOnePaddle(redderTarget, equalMix);

      debugPrint("game: Waiting for hit");
      HitResults hitResult = await bth.getHit();
      await leds.writeLEDs(offArray);

      double points = 100000 / hitResult.reactionTime;
      if (greenerTarget == hitResult.targetNum){
        score[0] += points.round();
        correctHits[0] += 1;
        reactionTimeArray[0] = hitResult.reactionTime;
        await leds.flashAllTargetsOneLed(1);
      } else {
        perfection = false;
        score[0] -= points.round();
        reactionTimeArray[0] = hitResult.reactionTime;
        await leds.flashAllTargetsOneLed(0);
      }
      debugPrint("game: Hit paddle = ${hitResult.targetNum}");
      debugPrint("game: Reaction time = ${hitResult.reactionTime}");


      streamController.add(rNum);
      rNum++;

      await Future.delayed(const Duration(milliseconds: 1000));
    }
    debugPrint("game: game over");
  }

  Future<void> startShootYourColor() async {
    await preGameUpdate(bth.targetList.length); // as many players as connected targets

    for (rNum = 0; rNum<numRounds; rNum++){
      await Future.delayed(Duration(milliseconds: rng.nextInt(4000)));
      List<int> colors = List<int>.generate(bth.targetList.length, (i) => i);
      colors.shuffle(); //Index is the paddle, Value is the color
      debugPrint("game: colors for game $colors");
      await leds.writeSingleColorPerPaddle(colors);

      debugPrint("game: Waiting for hit");
      HitResults hitResult = await bth.getHit();
      await leds.writeLEDs(offArray);

      int winner = colors[hitResult.targetNum];

      debugPrint("game: Hit paddle = ${hitResult.targetNum}");
      debugPrint("game: Reaction time = ${hitResult.reactionTime}");

      score[winner] += (100000 / hitResult.reactionTime).round();
      correctHits[winner] += 1;
      reactionTimeArray[winner] = hitResult.reactionTime;

      debugPrint("game: correct hits = $correctHits");

      streamController.add(rNum);
      await leds.flashAllTargetsOneLed(winner);
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    debugPrint("game: game over");
  }

  Future<void> startMovingTargets() async {
    await preGameUpdate(bth.targetList.length);  // as many players as connected targets

    for (rNum = 0; rNum<numRounds; rNum++){
      await Future.delayed(Duration(milliseconds: rng.nextInt(2000)));
      List<int> colors = List<int>.generate(bth.targetList.length, (i) => i);

      colors.shuffle(); //Index is the paddle, Value is the color

      bool hitDetected = false;
      int numCycled = 1;
      Future(() async {
        while(!hitDetected){
          colors.add(colors[0]); // add the first color to the end
          colors.removeAt(0); // remove the first color
          await leds.writeSingleColorPerPaddle(colors);
          await Future.delayed(const Duration(milliseconds: 400));
          numCycled++;
        }
      });
      HitResults hitResult = await bth.getHit();
      hitDetected = true;
      await Future.delayed(const Duration(milliseconds: 100));

      int winner = colors[hitResult.targetNum];
      int points = (100 / numCycled).round();

      debugPrint("game: Hit paddle = ${hitResult.targetNum}");
      debugPrint("game: Reaction time = ${hitResult.reactionTime}");

      score[winner] += points;
      correctHits[winner] += 1;

      debugPrint("game: correct hits = $correctHits");

      streamController.add(rNum);

      await leds.flashAllTargetsOneLed(winner);
      await Future.delayed(const Duration(milliseconds: 500));
      await leds.writeLEDs(offArray); // I waited to turn it off until now in case the moving loop is still running
    }
    debugPrint("game: game over");
  }

  Future<void> testSwitchingLimit() async {
    await preGameUpdate(1); // display minimum time in reaction time

    int delayMillis = 500;
    int start;
    int delay = 500;
    while (delayMillis > 0){
      start = DateTime.now().millisecondsSinceEpoch;

      await Future.delayed(Duration(milliseconds: delayMillis));
      await leds.writeOnePaddle(0, [250,250,250,250]);

      await Future.delayed(Duration(milliseconds: delayMillis));
      await leds.writeOnePaddle(0, [0,0,0,0]);
      delayMillis = ((delayMillis * .95) - 1).round();

      delay = ((DateTime.now().millisecondsSinceEpoch - start)/2).round();
      debugPrint("actual = $delay"); // Takes about 15 ms to write one
      debugPrint("target = $delayMillis");
    }

    reactionTimeArray[0] = delay;
    streamController.add(rNum);
    await leds.writeLEDs(offArray);

  }
}
