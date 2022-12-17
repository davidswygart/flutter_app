import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/bluetooth/single_target.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'characteristics/hit_sensor.dart';

class BlueToothHandler {
  // create a constructor that only creates 1 instance and can then easily access that instance
  static final BlueToothHandler _instance = BlueToothHandler
      ._internal(); // nothing special about _internal() keyword. Just the name of the method.
  BlueToothHandler._internal() {
    debugPrint("bluetooth_handler: Created instance");
  }
  factory BlueToothHandler() =>
      _instance; // Factory keyword specifies that the constructor doesn't always create a new instance of this class

  final bleLibrary = FlutterReactiveBle();

  List<SingleTarget> targetList = [];

  Future<List<SingleTarget>> connectToTargets(
      {Duration timeout = const Duration(seconds: 3)}) async {
    List<Uuid> id = [Uuid.parse('aaaaaaaa-151b-11ec-82a8-0242ac130003')];
    debugPrint("bluetoothHandler: starting scan");

    final Map<String, DiscoveredDevice> availableDevices = {};
    Stream<DiscoveredDevice> scanStream = bleLibrary.scanForDevices(
      withServices: id,
    );
    StreamSubscription<DiscoveredDevice> subscription;
    subscription = scanStream.listen(
      (dev) {
        availableDevices[dev.name] = dev;
      },
    );
    await Future.delayed(const Duration(seconds: 3));
    await subscription.cancel();

    availableDevices.forEach((name, dev) async {
      try {
        SingleTarget t = SingleTarget(dev);
        await t.init();
        targetList.add(t); //ToDo : remove from availableDevices list
        debugPrint(
            "bluetooth_handler: Successfully added BLE device to list in BLE handler");
      } on Exception catch (_) {
        debugPrint(
            "bluetooth_handler: Failed to add BLE device to list in BLE handler");
      }
    });
    return targetList;
  }

  // ToDo: check if devices in list are still connected. Maybe run before game or periodically? Clear from list if no connection.

/*

  Future<HitResults> getHit() async {
    List<Future<HitResults>> futureHitResults =[];
    for (int i=0; i<targetList.length; i++){
      futureHitResults.add(targetList[i].hitSensor.getHit(i));
    }
    HitResults result = await Future.any(futureHitResults);
    return result;
  }
*/

}
