import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'Info.dart';

/*enum blueStates {
  error,
  notSupported,
  unauthorized,
  turnedOff,
  notConnected,
  scanning,
  connecting,
  connected,
}*/

class BlueToothHandler {
  Info info = Info();

  factory BlueToothHandler() => _instance;
  static final BlueToothHandler _instance = BlueToothHandler._internal();
  BlueToothHandler._internal() {
    debugPrint("Created instance of the bluetooth handler");
  }

  //Stream<blueStates> get stateStream => _stateBroadcaster.stream;
  //blueStates get lastState => _lastState;
  //StreamController<blueStates> _stateBroadcaster = StreamController<blueStates>.broadcast();
  //blueStates _lastState = blueStates.error; //Should be overwritten when we first assess the state



/*  void _updateState(blueStates b) {
    _lastState = b;
    _stateBroadcaster.add(b);
  }*/

/*  Future<void> connect() async{
    _updateState(blueStates.connecting);
    try {
      bool connectSuccess = await _attemptConnect();
      if (connectSuccess) {
        _updateState(blueStates.connected);
      }
      else {
        _updateState(blueStates.notConnected);
      }
    }
    catch(error){
      _updateState(blueStates.error);
    }
  }*/

  Future<bool> attemptConnect() async {
    FlutterBlue fb = FlutterBlue.instance;
    debugPrint("BluetoothHandler: 1 Attempting connection");
    BluetoothDevice? device;

    Stream<ScanResult> scanStream = fb.scan(timeout: Duration(seconds: 5));
    ScanResult r = await scanStream.firstWhere((r) => r.device.name == info.deviceName);
    await fb.stopScan();



    // Connect to device //
    debugPrint("BluetoothHandler: 5 Attempting connection");
    await device.connect(timeout: Duration(seconds: 5));

    // find services //
    BluetoothService? service;
    debugPrint("BluetoothHandler: 7 discovering services");
    List<BluetoothService> serviceList = await device.discoverServices();
    for (BluetoothService s in serviceList) {
      if (s.uuid == info.serviceUUID) {
        service = s;
      }
    }
    if (service == null) {
      debugPrint("BluetoothHandler: 8 service not found");
      return false;
    }

    // find Characteristics //
    BluetoothCharacteristic? ledC;
    BluetoothCharacteristic? hitC;
    BluetoothCharacteristic? batteryC;

    debugPrint("BluetoothHandler: 9 Looking for characteristics");
    List<BluetoothCharacteristic> charList = service.characteristics;
    for (BluetoothCharacteristic c in charList) {
      if (c.uuid == info.ledUUID) {
        ledC = c;
      } else if (c.uuid == info.hitUUID) {
        hitC = c;
      } else if (c.uuid == info.batteryUUID) {
        batteryC = c;
      }
    }

    if ((ledC == null) || (hitC == null) || (batteryC == null)) {
      debugPrint("BluetoothHandler: 10 characteristic was not found");
      return false;
    } else {
      await hitC.setNotifyValue(true);
      await batteryC.setNotifyValue(true);
      debugPrint("BluetoothHandler: 10 all characteristics were found");
      return true;
    }
  }
}
