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

  int numColors = 2; // ToDo: Need to make it actually detect the number of paddles, but not go over number of colors
  int numRounds = 4;
  late List<int> score;
  late List<int> correctHits;

  final streamController = StreamController();

  Game(){
    score = List.filled(numColors, 0, growable: false); // fill with zeros
    correctHits = List.filled(numColors, 0, growable: false); // fill with zeros
  }

  Future<void> startGoNoGo() async {
    score = List.filled(numColors, 0, growable: false); // fill with zeros
    correctHits = List.filled(numColors, 0, growable: false); // fill with zeros

    List<List<int>> offArray = leds.genUniformColorArray(val:0);

    int rNum = 0;
    while (rNum < numRounds){
      await leds.writeLEDs(offArray);
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
      await leds.writeLEDs(offArray);

      if (shouldGo & (hitResult != null)){ // correct go
        score[1] += timeoutMs - hitResult!.reactionTime;
        correctHits[1] += 1;
      } else {
        score[1] -= timeoutMs;
        correctHits[1] -= 1;
      }

      debugPrint("game: correct hits = $correctHits");
      streamController.add(correctHits[1]);

      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  Future<void> startMemorySequence() async {
    bool perfection = true;
    score = List.filled(numColors, 0, growable: false); // fill with zeros
    correctHits = List.filled(numColors, 0, growable: false); // fill with zeros
    List<List<int>> offArray = leds.genUniformColorArray(val:0);
    int numPaddles = offArray.length;

    int rNum = 0;
    while (perfection){
      await leds.writeLEDs(offArray);
      await Future.delayed(Duration(milliseconds: rng.nextInt(4000)));

      List<int> paddleSequence = [];
      for (int i=0; i<rNum+1; i++){
        int chosenPaddle = rng.nextInt(numPaddles);
        paddleSequence.add(chosenPaddle);
        await leds.writeOnePaddle(chosenPaddle, [0,255,0,0]); //write the paddle green
        await Future.delayed(const Duration(milliseconds: 500));
        await leds.writeOnePaddle(chosenPaddle, [0,0,0,0]);
        await Future.delayed(const Duration(milliseconds: 100));
      }

      bool continueSubround = true;
      int subRoundNum = 0;
      while(continueSubround){
        debugPrint("game: Waiting for hit");
        HitResults hitResult = await bth.getHit();
        if (paddleSequence[subRoundNum] == hitResult.targetNum){
          double points = (subRoundNum+1) * 100000 / hitResult.reactionTime;
          score[0] += points.round();
          correctHits[0] += 1;
        } else {
          perfection = false;
          continueSubround = false;
        }
        debugPrint("game: Hit paddle = ${hitResult.targetNum}");
        debugPrint("game: Reaction time = ${hitResult.reactionTime}");

        subRoundNum++;
        streamController.add(subRoundNum); // just a dirty way to force a screen update
        if (subRoundNum == rNum){
          continueSubround = false;
        }
      }
      rNum++;
    }
  }

  Future<void> startColorDiscrimination() async {
    bool perfection = true;

    score = List.filled(numColors, 0, growable: false); // fill with zeros
    correctHits = List.filled(numColors, 0, growable: false); // fill with zeros
    List<List<int>> offArray = leds.genUniformColorArray(val:0);

    int rNum = 0;


    int subtractor = 125;


    while (perfection){
      await leds.writeLEDs(offArray);
      await Future.delayed(Duration(milliseconds: rng.nextInt(4000)));

      List<List<int>> equalMix = [[128,128,50,50],[128,128,50,50]];
      int chosenT = rng.nextInt(2);
      equalMix[chosenT][0] = equalMix[chosenT][0]+subtractor;
      equalMix[chosenT][1] = equalMix[chosenT][1]-subtractor;
      double subDbl = (subtractor-1)*0.8;
      subtractor = subDbl.round();
      await leds.writeLEDs(equalMix);

      debugPrint("game: Waiting for hit");
      HitResults hitResult = await bth.getHit();
      double points = 100000 / hitResult.reactionTime;

      if (chosenT == hitResult.targetNum){

        score[0] += points.round();
        correctHits[0] += 1;
      } else {
        perfection = false;
        score[1] += points.round();
        correctHits[1] += 1;
      }
      debugPrint("game: Hit paddle = ${hitResult.targetNum}");
      debugPrint("game: Reaction time = ${hitResult.reactionTime}");

      rNum++;
      streamController.add(rNum);

      await leds.writeLEDs(offArray);
      await Future.delayed(const Duration(milliseconds: 1000));


    }
  }

  Future<void> startShootYourColor() async {
    score = List.filled(numColors, 0, growable: false); // fill with zeros
    correctHits = List.filled(numColors, 0, growable: false); // fill with zeros

    List<List<int>> offArray = leds.genUniformColorArray(val:0);

    for (int rNum = 0; rNum<numRounds; rNum++){
      await leds.writeLEDs(offArray);
      await Future.delayed(Duration(milliseconds: rng.nextInt(4000)));
      List<int> colors = List<int>.generate(numColors, (i) => i);
      colors.shuffle(); //Index is the paddle, Value is the color
      debugPrint("game: colors for game $colors");
      await leds.writeSingleColorPerPaddle(colors);

      debugPrint("game: Waiting for hit");
      HitResults hitResult = await bth.getHit();

      int winner = colors[hitResult.targetNum];
      double points = 100000 / hitResult.reactionTime;

      debugPrint("game: Hit paddle = ${hitResult.targetNum}");
      debugPrint("game: Reaction time = ${hitResult.reactionTime}");

      score[winner] += points.round();
      correctHits[winner] += 1;

      debugPrint("game: correct hits = $correctHits");

      streamController.add(rNum);

      await leds.writeLEDs(offArray);
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }
  }