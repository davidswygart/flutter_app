
import 'package:flutter/material.dart';
import 'package:flutter_app/bluetooth/single_target.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'characteristics/hit_sensor.dart';

class BlueToothHandler {
  // create a constructor that only creates 1 instance and can then easily access that instance

  factory BlueToothHandler() => _instance; // Factory keyword specifies that the constructor doesn't always create a new instance of this class
  static final BlueToothHandler _instance = BlueToothHandler._internal(); // nothing special about _internal() keyword. Just the name of the method.
  BlueToothHandler._internal() {
    debugPrint("bluetooth_handler: Created instance of the bluetooth handler");
  }

  List<SingleTarget> targetList = [];
  List<ScanResult> availableDevices = [];


  Future<List<ScanResult>> updateAvailableDevices({Duration timeout = const Duration(seconds: 3)}) async {
    FlutterBlue fb = FlutterBlue.instance;
    if (await fb.isScanning.first) {
      debugPrint("bluetoothHandler: Already scanning");
      throw Exception("Bluetooth is already scanning");
    }

    debugPrint("bluetoothHandler: starting scan");
    Stream<ScanResult> scanStream = fb.scan(timeout: timeout);
    availableDevices.clear();
    await for (ScanResult r in scanStream) {
      debugPrint("device: device found; name = ${r.device.name}");
      availableDevices.add(r);
    }
    return availableDevices;
  }

  // ToDo: check if devices in list are still connected. Maybe run before game or periodically? Clear from list if no connection.


  addTarget() async {
    await updateAvailableDevices();



    // Check if connected // Is this really needed? Probably need to remove from list if advertizing has restarted
/*    for (SingleTarget singleT in targetList) {
      if(singleT.device.fbDevice.name == t.device.fbDevice.name){
        debugPrint("bluetooth_handler: Device already added to list, skipping");
        return;
      }
    }*/

    for (ScanResult r in availableDevices){
      if (r.device.name.startsWith("HTT_")) { //TODO: limit scanning to these matching names
        SingleTarget t = SingleTarget(r.device);
        try {
          await t.init();
          targetList.add(t);
          debugPrint("bluetooth_handler: Successfully added BLE device to list in BLE handler");
        }
        on Exception catch (_) {
          debugPrint("bluetooth_handler: Failed to add BLE device to list in BLE handler");
        }
      }
    }

/*    debugPrint("device: 4 Device not found in scan results");
    throw TimeoutException("Device not found in scan results");*/


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