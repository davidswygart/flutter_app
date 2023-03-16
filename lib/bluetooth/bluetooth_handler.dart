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

  Future<List<SingleTarget>> connectToTargets() async {
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
    await Future.delayed(const Duration(seconds: 2));
    await subscription.cancel();

    availableDevices.forEach((name, dev) {
      debugPrint("available device $name");
      bool newDevice = true;
      for(int i=0; i<targetList.length; i++) {
        if (name == targetList[i].device.name) {newDevice = false;}
      }
      if (newDevice){
        SingleTarget t = SingleTarget(dev);
        targetList.add(t);
        debugPrint("bluetooth_handler: Successfully added BLE device to list");
      }
    });

    return targetList;
  }

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

  bool anyLostConnections() {
    for(int i=0; i<targetList.length; i++) {
      if(targetList[i].state == DeviceConnectionState.disconnected){
        return true;
      }
    }
    return false;
  }
}
