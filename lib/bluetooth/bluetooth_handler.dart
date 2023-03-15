import 'dart:async';

import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bluetooth/single_target.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';


import 'id.dart';

class BlueToothHandler {
  // create a constructor that only creates 1 instance and can then easily access that instance
  static final BlueToothHandler _instance = BlueToothHandler._internal();
  BlueToothHandler._internal() {debugPrint("bluetooth_handler: Created instance");}
  factory BlueToothHandler() => _instance;

  final bleLibrary = FlutterReactiveBle();

  List<SingleTarget> targetList = [];

  Future<List<SingleTarget>> connectToTargets(
      {Duration timeout = const Duration(seconds: 3)}) async {

    if (await BluetoothEnable.enableBluetooth == "false"){return [];}

    if (await Permission.location.isDenied) {
      PermissionStatus result = await Permission.location.request();
      if(!result.isGranted){return [];}
    }

    List<Uuid> id = [ID().advertising];
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
        debugPrint("available device $name");
        List<int> toPop = [];
        for(int i=0; i<targetList.length; i++) {
          if (name == targetList[i].device.name) {
            await targetList[i].disconnect();
            toPop.add(i);
          }
        }
        for(int i=0; i<toPop.length; i++){targetList.removeAt(i);} //remove from list after loop so I don't mess up my indexing of for loop
        SingleTarget t = SingleTarget(dev);
        await t.init();
        targetList.add(t);
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

  void setHitThreshold(double thresh){
    for (int i=0; i<targetList.length; i++){
      targetList[i].setHitThreshold(thresh);
    }
  }
  void setHitRefractoryPeriod(double buffer){
    for (int i=0; i<targetList.length; i++){
      targetList[i].setHitRefractoryPeriod(buffer);
    }
  }

  Future<HitResults> getHit() async {
    List<Future<HitResults>> futureHitResults =[];
    for (int i=0; i<targetList.length; i++){
      futureHitResults.add(targetList[i].getHit(i));
    }
    HitResults result = await Future.any(futureHitResults);
    return result;
  }

  Future<void> clearTargets() async {
    for(int i=0; i<targetList.length; i++) {
      await targetList[i].disconnect();
    }
    targetList.clear();
  }
}
