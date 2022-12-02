import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/bluetooth/bluetooth_handler.dart';

import '../bluetooth/characteristics/hit_sensor.dart';
import '../bluetooth/characteristics/led_display.dart';

class Game {

  LedDisplay leds = LedDisplay();
  BlueToothHandler bth = BlueToothHandler();
  Random rng = Random();
  final StreamController<int> streamController = StreamController(); //this is just as a dirty way to force screen rebuilding

  int numRounds = 4;

  // This number needs to be updated before starting a game
  int numTargets = 0;
  List<int> score =[0];
  List<int> correctHits = [0];
  List<List<int>> offArray = [[0,0,0,0]]; // array of zeros for all paddles that is often used to turn them all off
  int rNum = 0; // current round number


  preGameUpdate() async {
    numTargets = bth.targetList.length;
    score = List.filled(numTargets, 0, growable: false); // fill with zeros
    correctHits = List.filled(numTargets, 0, growable: false); // fill with zeros
    offArray = leds.genUniformColorArray(val:0);
    await leds.writeLEDs(offArray);
    rNum = 0;
    streamController.add(rNum);
  }

  Future<void> startGoNoGo() async {
    await preGameUpdate();

    while (rNum < numRounds){
      await Future.delayed(Duration(milliseconds: rng.nextInt(4000)));

      bool shouldGo = rng.nextBool();
      if (shouldGo){
        await leds.writeOnePaddle(0, [0,255,0,0]); // assumes single paddle and uses the first one on the list
        rNum++; // Only advance the round for go trials
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
      }
      else if (!shouldGo & (hitResult == null)){
        debugPrint("game: correct no go");
      } else {
        debugPrint("game: incorrect go or no go");
        score[0] -= timeoutMs;
        correctHits[0] -= 1;
      }

      debugPrint("game: correct hits = $correctHits");
      streamController.add(correctHits[0]);
      debugPrint("game: written to stream controller");

      await Future.delayed(const Duration(milliseconds: 1000));
    }
    debugPrint("game: game over");
  }

  Future<void> startMemorySequence() async {
    await preGameUpdate();
    bool perfection = true;

    while (perfection){
      debugPrint("game: Round # $rNum");
      await Future.delayed(Duration(milliseconds: rng.nextInt(4000)));

      List<int> paddleSequence = [];
      for (int i=0; i<rNum+1; i++){
        int chosenPaddle = rng.nextInt(numTargets);
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
    await preGameUpdate();
    bool perfection = true;
    int moreGreen = 125;
    List<int> equalMix = [128,128,50,50];
    List<int> usedTargets = [0,1]; // Needs 2 targets and only uses the first 2

    if (numTargets<2){throw("error, need at least 2 targets for this game") ;}

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
        score[1] += points.round();
        correctHits[1] += 1;
        await leds.flashAllTargetsOneLed(1);
      } else {
        perfection = false;
        score[0] += points.round();
        correctHits[0] += 1;
        await leds.flashAllTargetsOneLed(0);
      }
      debugPrint("game: Hit paddle = ${hitResult.targetNum}");
      debugPrint("game: Reaction time = ${hitResult.reactionTime}");

      rNum++;
      streamController.add(rNum);

      await Future.delayed(const Duration(milliseconds: 1000));
    }
    debugPrint("game: game over");
  }

  Future<void> startShootYourColor() async {
    await preGameUpdate();

    for (int rNum = 0; rNum<numRounds; rNum++){
      await Future.delayed(Duration(milliseconds: rng.nextInt(4000)));
      List<int> colors = List<int>.generate(numTargets, (i) => i);
      colors.shuffle(); //Index is the paddle, Value is the color
      debugPrint("game: colors for game $colors");
      await leds.writeSingleColorPerPaddle(colors);

      debugPrint("game: Waiting for hit");
      HitResults hitResult = await bth.getHit();
      await leds.writeLEDs(offArray);

      int winner = colors[hitResult.targetNum];
      double points = 100000 / hitResult.reactionTime;

      debugPrint("game: Hit paddle = ${hitResult.targetNum}");
      debugPrint("game: Reaction time = ${hitResult.reactionTime}");

      score[winner] += points.round();
      correctHits[winner] += 1;

      debugPrint("game: correct hits = $correctHits");

      streamController.add(rNum);
      await leds.flashAllTargetsOneLed(winner);
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    debugPrint("game: game over");
  }

  Future<void> startMovingTargets() async {
    await preGameUpdate();

    for (int rNum = 0; rNum<numRounds; rNum++){
      await Future.delayed(Duration(milliseconds: rng.nextInt(4000)));
      List<int> colors = List<int>.generate(numTargets, (i) => i);

      colors.shuffle(); //Index is the paddle, Value is the color

      bool hitDetected = false;
      Future(() async {
        while(!hitDetected){
          colors.add(colors[0]); // add the first color to the end
          colors.removeAt(0); // remove the first color
          await leds.writeSingleColorPerPaddle(colors);
          await Future.delayed(const Duration(milliseconds: 400));
        }
      });
      HitResults hitResult = await bth.getHit();
      hitDetected = true;



      int winner = colors[hitResult.targetNum];
      double points = 100000 / hitResult.reactionTime;

      debugPrint("game: Hit paddle = ${hitResult.targetNum}");
      debugPrint("game: Reaction time = ${hitResult.reactionTime}");

      score[winner] += points.round();
      correctHits[winner] += 1;

      debugPrint("game: correct hits = $correctHits");

      streamController.add(rNum);

      await leds.flashAllTargetsOneLed(winner);
      await Future.delayed(const Duration(milliseconds: 1000));
      await leds.writeLEDs(offArray); // I waited to turn it off until now in case the moving loop is still running
    }
    debugPrint("game: game over");
  }

}