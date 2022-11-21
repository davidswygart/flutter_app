import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/BlueTooth/bluetooth_handler.dart';

import '../BlueTooth/characteristics/hit_sensor.dart';
import '../BlueTooth/characteristics/led_display.dart';

class Game {

  LedDisplay leds = LedDisplay();
  BlueToothHandler bth = BlueToothHandler();
  Random rng = Random();

  int numColors = 4;
  int numRounds = 4;
  late List<int> score;
  late List<int> correctHits;

  Game(){
    score = List.filled(numColors, 0, growable: false); // fill with zeros
    correctHits = List.filled(numColors, 0, growable: false); // fill with zeros
  }

  Future<void> start() async {

    List<List<int>> offArray = leds.genUniformColorArray(val:0);
    await leds.writeLEDs(offArray);

    List<List<int>> onArray = [[0,0,0,0],[0,0,0,0]];

    for (int rNum = 0; rNum<5; rNum++){
      await Future.delayed(Duration(milliseconds: rng.nextInt(4000)));
      int chosenPaddle = rng.nextInt(offArray.length);

      //onArray = bth.genUniformColorArray(val:0);
      onArray[chosenPaddle][1] = 255; // Turn on random green


      debugPrint("game: writing - $onArray");
      await leds.writeLEDs(onArray);

      debugPrint("game: Waiting for hit");
      HitResults hitResult = await bth.getHit();

      debugPrint("game: Hit paddle = ${hitResult.targetNum}");
      debugPrint("game: Reaction time = ${hitResult.reactionTime}");
      await leds.writeLEDs(offArray);
    }
  }
  }