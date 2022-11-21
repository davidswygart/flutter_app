import 'dart:async';
import 'dart:math';
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/bluetooth/characteristics/hit_sensor.dart';
import 'package:flutter_app/bluetooth/single_target.dart';


class BlueToothHandler {
  // create a constructor that only creates 1 instance and can then easily access that instance
  factory BlueToothHandler() => _instance; // Factory keyword specifies that the constructor doesn't always create a new instance of this class
  static final BlueToothHandler _instance = BlueToothHandler._internal(); // nothing special about _internal() keyword. Just the name of the method.
  BlueToothHandler._internal() {
    debugPrint("bluetooth_handler: Created instance of the bluetooth handler");
  }

  List<SingleTarget> targetList = [];


  addTarget() async {
    SingleTarget t = SingleTarget();
    try {
      await t.init();
      debugPrint("bluetooth_handler: target initialized");

      for (SingleTarget singleT in targetList) {
        if(singleT.device.fbDevice.name == t.device.fbDevice.name){
          debugPrint("bluetooth_handler: Device already added to list, skipping");
          return;
        }
      }

      targetList.add(t);
      debugPrint("bluetooth_handler: Successfully added BLE device to list in BLE handler");
    }
    on Exception catch (_) {
      debugPrint("bluetooth_handler: Failed to add BLE device to list in BLE handler");
    }
  }

  Future<HitResults> getHit() async {
    List<Future<HitResults>> futureHitResults =[];
    for (int i=0; i<targetList.length; i++){
      futureHitResults.add(targetList[i].hitSensor.getHit(i));
    }
    HitResults result = await Future.any(futureHitResults);
    return result;
  }

  writeLEDs(List<List<int>> ledColors){
    for (int i=0; i<targetList.length; i++){
      targetList[i].led.writeLED(ledColors[i]);
    }
  }

  List<List<int>> genUniformColorArray( {int val=0}){
    int numColors = 4;
    List<int> singleTargetArray = List.filled(numColors, val, growable: false); // fill with zeros
    List<List<int>> fullArray = List.filled(targetList.length, singleTargetArray, growable: false);
    return fullArray;
  }

  randomColors() async {
    Random rng = Random();
    List<List<int>> colors = genUniformColorArray();

    for (int i=0; i< colors.length ; i++) {
      for (int ii=0; ii < colors[0].length ; ii++) {
        colors[i][ii] = rng.nextInt(256);
      }
    }
    writeLEDs(colors);
  }

  Future<void> showPaddleNumber() async {
    List<List<int>> offArray = genUniformColorArray(val:0);
    await writeLEDs(offArray);
    await Future.delayed(const Duration(seconds: 1));
    int numColors = 4;

    for (int i=0; i< offArray.length ; i++) {
      offArray[i] = List.filled(numColors, 255, growable: false); // turn on a single target
      await writeLEDs(offArray);
      offArray[i] = List.filled(numColors, 0, growable: false);
      await Future.delayed(const Duration(seconds: 1));
      await writeLEDs(offArray);
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}