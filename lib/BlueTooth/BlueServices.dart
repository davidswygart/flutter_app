import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/BlueTooth/UUIDs.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'PossibleStates.dart';

class BlueServices {
  static FlutterBlue flutterBlue = FlutterBlue.instance;
  static Stream<String> getStateStream(){return _stateBroadcaster.stream;}



  static StreamController<String> _stateBroadcaster = StreamController<String>.broadcast();
  static late BluetoothDevice _device;
  static bool _deviceFound = false;
  static bool _connecting = false;
  static bool _keepScanning = false;


  static void initialize(){
    _addBlueToothToStateStream();
    Timer.periodic(Duration(seconds:5), (Timer timer) async {
      debugPrint('_____________Run timer');
      if (await _manuallyCheckState()){
        debugPrint('_____________timer trying to connect');
        await _connectToBTDevice();
      }
    });
  }
  static Future<void> _connectToBTDevice() async {
    _stateBroadcaster.add(ConnectionStates.connecting);
    _connecting = true;
    try {
      if (!_deviceFound){await _scanForDevice();}
      if (_deviceFound){await _device.connect(timeout: Duration(seconds: 10));}
    }
    catch (stackTrace){}
    _connecting = false;
    _manuallyCheckState();
  }
  static Future<void> _scanForDevice() async {
    Stream<ScanResult> scanStream = flutterBlue.scan();
    debugPrint('______________scan started');
    await for (ScanResult r in scanStream) {
      //print('${r.device.name} found! rssi: ${r.rssi}');
      if (r.device.name.contains(UUIDs.deviceName) && !_deviceFound){//Only do this once.
        debugPrint('_____Found Matching BT device');
        _device = r.device;
        _addDeviceToStateStream();
        _deviceFound = true;
        if (!_keepScanning){
          debugPrint('_____scan stopped');
          flutterBlue.stopScan();
        }
        return;
      }
    }
  }
  static Stream<List<ScanResult>> getEternalScanResults(){
    _keepScanning = true;
    return flutterBlue.scanResults;
  }
  static void _addBlueToothToStateStream() {
    flutterBlue.state.listen((BluetoothState btState) {
      switch (btState) {
        case BluetoothState.unknown: {
          _stateBroadcaster.add(ConnectionStates.notSupported);
          break;}
        case BluetoothState.unavailable:{
          _stateBroadcaster.add(ConnectionStates.notSupported);
          break;}
        case BluetoothState.unauthorized:{
          _stateBroadcaster.add(ConnectionStates.notSupported);
          break;}
        case BluetoothState.turningOn:{
          _stateBroadcaster.add(ConnectionStates.notConnected);
          break;}
        case BluetoothState.off:{
          _stateBroadcaster.add(ConnectionStates.blueToothDisabled);
          break;}
        default:{}
      }
    });
  }
  static void _addDeviceToStateStream(){
    _device.state.listen((BluetoothDeviceState deviceState) {
      switch (deviceState) {
        case BluetoothDeviceState.connected: {
          _stateBroadcaster.add(ConnectionStates.connected);
          break;}
        case BluetoothDeviceState.disconnected:
          _stateBroadcaster.add(ConnectionStates.notConnected);
          break;
        default:{}
      }
    });
  }
  static Future<bool> _manuallyCheckState() async {//return true only if need to connect
    String state;
    bool needConnect = false;
    if (! await flutterBlue.isAvailable){
      state = ConnectionStates.notSupported;
    }
    else if (! await flutterBlue.isOn){
      state = ConnectionStates.blueToothDisabled;
    }
    else if (_connecting){
      state = ConnectionStates.connecting;
    }
    else if (await _isConnected()){
      state = ConnectionStates.connected;
    }
    else {
      state = ConnectionStates.notConnected;
      needConnect =  true;
    }
    _stateBroadcaster.add(state);
    return needConnect;
  }
  static Future<bool> _isConnected() async {
    for (BluetoothDevice connectedDevice in await flutterBlue.connectedDevices){
      if (connectedDevice.name.contains(UUIDs.deviceName)){
        debugPrint('_____already connected to ' + connectedDevice.name);
        _device = connectedDevice;
        return true;
      }
    }
    return false;
  }



}

/*  static Future<void> discoverServices() async {
    debugPrint('_____Looking through services');
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      if (service.uuid.toString().contains(UUIDs.settingsService)) {
        settingsService = SettingsService(service: service);
        debugPrint('_____Found the GameMode service');
        return;
      }
    }
    throw Errors.missingServices;
  }*/


//static late SettingsService settingsService;

/*
class SettingsService {
  BluetoothService service;
  SettingsService({required this.service});

  void verifyCharacteristics() {
    Map<String, String> uuids = Map.from(UUIDs.settingsChar);

    for (BluetoothCharacteristic characteristic in service.characteristics) {
      for (String uuidKey in uuids.keys){
        if (characteristic.uuid.toString() == uuids[uuidKey]){
          uuids.remove(uuidKey);
          break;
        }
      }
    }

    if (uuids.isEmpty){
      debugPrint('_________All characteristics accounted for');
      return;
    }
    else {
      debugPrint('_________Missing characteristics');
      throw Errors.missingCharacteristics;
    }
  }

  Future<void> printValue() async {
    for (BluetoothCharacteristic characteristic in service.characteristics) {
      List<int> val = await characteristic.read();
      debugPrint('______________val' + val.toString());

      int newVal = 0;
      val.asMap().forEach((int i, int b) {
        newVal += b << (8*i);
      });

      debugPrint('______________new val ' + (newVal.toString()));
    }
  }



}

class Status {
  final String service = '';
}

class Results {
  final String service = '';
}*/

