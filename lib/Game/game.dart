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

  Game(){
    score = List.filled(numColors, 0, growable: false); // fill with zeros
    correctHits = List.filled(numColors, 0, growable: false); // fill with zeros
  }


  Future<void> start() async {
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
      double points = 10000 / hitResult.reactionTime;

      debugPrint("game: Hit paddle = ${hitResult.targetNum}");
      debugPrint("game: Reaction time = ${hitResult.reactionTime}");

      score[winner] += points.round();
      correctHits[winner] += 1;

      debugPrint("game: correct hits = $correctHits");

      await leds.writeLEDs(offArray);
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }
  }