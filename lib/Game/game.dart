import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/bluetooth/characteristics/hit_sensor.dart';

import '../bluetooth/bluetooth_handler.dart';

class Game {
  BlueToothHandler bth = BlueToothHandler();

  Future<void> start() async {
    Random rng = Random();

    List<List<int>> offArray = bth.genUniformColorArray(val:0);
    await bth.writeLEDs(offArray);

    List<List<int>> onArray = [[0,0,0,0],[0,0,0,0]];

    for (int rNum = 0; rNum<5; rNum++){
      await Future.delayed(Duration(milliseconds: rng.nextInt(4000)));
      int chosenPaddle = rng.nextInt(offArray.length);

      //onArray = bth.genUniformColorArray(val:0);
      onArray[chosenPaddle][1] = 255; // Turn on random green


      debugPrint("game: writing - $onArray");
      await bth.writeLEDs(onArray);

      debugPrint("game: Waiting for hit");
      HitResults hitResult = await bth.getHit();

      debugPrint("game: Hit paddle = ${hitResult.targetNum}");
      debugPrint("game: Reaction time = ${hitResult.reactionTime}");
      await bth.writeLEDs(offArray);
    }
  }
  }