import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

enum blueStates {
  error,
  notSupported,
  unauthorized,
  turnedOff,
  notConnected,
  scanning,
  connecting,
  connected,
}

class BlueToothHandler {
  factory BlueToothHandler() => _instance;
  static final BlueToothHandler _instance = BlueToothHandler._internal();
  BlueToothHandler._internal(){debugPrint("Created instance of the bluetooth handler");}
  BluetoothCharacteristic? get ledCharacteristic => _ledCharacteristic;
  BluetoothCharacteristic? get hitCharacteristic => _hitCharacteristic;
  Stream<blueStates> get stateStream => _stateBroadcaster.stream;
  blueStates get lastState => _lastState;

  //List<String> _deviceNames = ['HTT_001', 'HTT_002'];
  String _deviceName = 'HTT_001';

  Guid _serviceUUID = Guid('00000000-151b-11ec-82a8-0242ac130003');
  Guid _ledUUID = Guid('00000001-151b-11ec-82a8-0242ac130003');
  Guid _hitUUID = Guid('00000002-151b-11ec-82a8-0242ac130003');

  StreamController<blueStates> _stateBroadcaster = StreamController<blueStates>.broadcast();
  blueStates _lastState = blueStates.error; //Should be overwritten when we first assess the state

  BluetoothDevice? _btDev;
  BluetoothCharacteristic? _ledCharacteristic;
  BluetoothCharacteristic? _hitCharacteristic;

  bool _runningLoop = false;

  stopStateHandler() {_runningLoop = false;}
  Future<bool> startStateHandler() async {
    if (_runningLoop){return false;}
    else {_runningLoop = true;}
    while(_runningLoop){
      if(await isConnected(_btDev)){
        _updateState(blueStates.connected);
        //TODO: allow for connection to multiple devices. Need to check connection status for each.  Setup device names on first app run or in settings.
        //TODO: set checks for bluetooth turned off
      }
      else{
        _updateState(blueStates.connecting);
        if (await _attemptConnect()){//Try to connect from the beginning.
          _updateState(blueStates.connected);
        }
        else{
          //broadcast that we are disconnected
          _updateState(blueStates.notConnected);
        }
      }
      await new Future.delayed(Duration(seconds: 5));
    }
    return true;
  }
  Future<bool> isConnected(BluetoothDevice? dev) async{
    //Check that this device is listed as a connected device
    if (dev == null){
      dev = _btDev;
      if (dev == null) {
        return false;
      }
    }

    List<BluetoothDevice> devList = await FlutterBlue.instance.connectedDevices;
    for (BluetoothDevice devFromList in devList){
      if(devFromList.id == dev.id){
        //debugPrint("Device was found in list of connected devices");
        return true;
      }
    }
    return false;
  }
  void _updateState(blueStates b){
    _lastState = b;
    _stateBroadcaster.add(b);
  }
  Future<bool> _attemptConnect() async{
    FlutterBlue fb = FlutterBlue.instance;
    debugPrint("BluetoothHandler: 1 Attempting connection");
    // Find device //
    BluetoothDevice? device;
    if (await fb.isScanning.first){
      debugPrint("BluetoothHandler: 2 Already scanning");
      return false;
    }

    debugPrint("BluetoothHandler: 2 starting scan");
    Stream<ScanResult> scanStream = fb.scan(timeout: Duration(seconds: 5));
    await for (ScanResult r in scanStream) {
      if (r.device.name == _deviceName){
        await fb.stopScan();
        device = r.device;
      }
    }

    if (device == null){
      debugPrint("BluetoothHandler: 4 Device not found in scan results");
      return false;
    }

    // Connect to device //
    debugPrint("BluetoothHandler: 5 Attempting connection");
    await device.connect(timeout: Duration(seconds: 5));
    if (!await isConnected(device)){
      debugPrint("BluetoothHandler: 6 connection was unsuccessful");
      return false;
    }

    // find services //
    BluetoothService? service;
    debugPrint("BluetoothHandler: 7 discovering services");
     List<BluetoothService> serviceList = await device.discoverServices();
     for (BluetoothService s in serviceList){
       if(s.uuid == _serviceUUID) {
         service = s;
       }
     }
     if (service == null){
       debugPrint("BluetoothHandler: 8 service not found");
       return false;
     }

     // find Characteristics //
    BluetoothCharacteristic? ledC;
    BluetoothCharacteristic? hitC;

    debugPrint("BluetoothHandler: 9 Looking for characteristics");
    List<BluetoothCharacteristic> charList = service.characteristics;
    for (BluetoothCharacteristic c in charList){
      if(c.uuid == _ledUUID) {
        ledC = c;
      }
      else if(c.uuid == _hitUUID){
        hitC = c;
      }
    }

    if ((ledC == null) || (hitC == null)){
      debugPrint("BluetoothHandler: 10 characteristic was not found");
      return false;
    }
    else{
      await hitC.setNotifyValue(true);
      debugPrint("BluetoothHandler: 10 characteristic was found");
      // Set discovered devices, services, and characteristics as public
      _btDev = device;
      _ledCharacteristic = ledC;
      _hitCharacteristic = hitC;
      return true;
    }
  }
}