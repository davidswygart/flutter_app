
import 'package:flutter/material.dart';
import 'package:flutter_app/bluetooth/single_target.dart';

import 'characteristics/hit_sensor.dart';

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
}