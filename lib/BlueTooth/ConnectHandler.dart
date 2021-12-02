import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/BlueTooth/BluetoothObjects.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'BlueStateAssembler.dart';
import 'UUIDs.dart';

enum nextConnectAction {
  wait,
  findDevice,
  connectToDevice,
  findServicesAndCharacteristics,
  finished,
}

class ConnectHandler {
  static BlueToothObjects _btObjects = BlueToothObjects();
  static nextConnectAction _nextAction = nextConnectAction.wait;//Should be overwritten when we first assess the state
  static bool _continueAttempts = true;
  static bool _connectLoopBusy = false;
  static bool _deviceFound = false;
  static bool _servCharFound = false;

  static void initialize(){
    BlueStateAssembler.startAdapterStateHandler();
    connectionAttemptLoop();
  }
  static BlueToothObjects getBtObjects(){
    if (_nextAction == nextConnectAction.finished){return _btObjects;}
    else {throw('Have not finished connecting and verifying bluetooth device');}
    }
  static Future<bool> connectionAttemptLoop() async {
    if (_connectLoopBusy){return false;} //Prevents starting a connection action while we are already attempting an action
    else{
      _connectLoopBusy = true;
      while(_continueAttempts) {
        _assessNextConnectAction();
        await _tryNextConnectAction();
      }
      _connectLoopBusy = false;
    }
    return false;
  }
  static void _assessNextConnectAction() {
    if (BlueStateAssembler.currentState == blueStates.notConnected){ //TODO: Make and exception for scanning in the BlueToothDevices Page.  It doesn't mean that we are currently running a connection action.
      if(!_deviceFound){_nextAction = nextConnectAction.findDevice;}
      else{_nextAction = nextConnectAction.connectToDevice;}
    }
    else if (BlueStateAssembler.currentState == blueStates.connected){
      if(!_servCharFound){_nextAction = nextConnectAction.findServicesAndCharacteristics;}
      else {_nextAction = nextConnectAction.finished;}//Everything has been successfully completed
    }
    else {_nextAction = nextConnectAction.wait;}//Bluetooth is not in a connectable state.  Handle opening settings in the BlueToothBar UI.
  }
  static Future<void> _tryNextConnectAction() async {
    debugPrint('_________nextAction '+ _nextAction.toString());
    switch (_nextAction) {
      case nextConnectAction.wait:
        await new Future.delayed(const Duration(seconds : 1));
        break;
      case nextConnectAction.findDevice:
        BluetoothDevice? possibleDevice = await _scanForDevice();
        if (possibleDevice != null){
          await BlueStateAssembler.startDeviceStateHandler(possibleDevice);
          _btObjects.device = possibleDevice;
          _deviceFound = true;
        }
        else{await new Future.delayed(const Duration(seconds : 1));}
        break;
      case nextConnectAction.connectToDevice:
        await _btObjects.device?.connect(timeout: Duration(seconds: 5));
        break;
      case nextConnectAction.findServicesAndCharacteristics:
        _servCharFound = await _findServices();
        break;
      case nextConnectAction.finished:
        _continueAttempts = false;
        break;
    }
  }

  //TODO:the following 3 functions could probably be housed in the bluetoothObjects class
  static Future<BluetoothDevice?> _scanForDevice() async {
    FlutterBlue fb = FlutterBlue.instance;
    Stream<ScanResult> scanStream = fb.scan(timeout: Duration(seconds: 5));
    await for (ScanResult r in scanStream) {
      if (r.device.name == UUIDs.deviceName){
        await fb.stopScan();
        return r.device;
      }
    }
    return null; //Couldn't find matching device
  }
  static Future<bool> _findServices() async {
    Map<Guid,String> serviceUUIDs = UUIDs.getServiceUuids();
    List<BluetoothService> serviceList = await _btObjects.device!.discoverServices();
    for (BluetoothService service in serviceList){
      String? serviceName = serviceUUIDs.remove(service.uuid);
      if (serviceName != null){
        _btObjects.addService(serviceName, service);
        bool foundAllChars = await _findCharacteristics(serviceName, service);
        if(!foundAllChars){return false;}
      }
    }
    if(serviceUUIDs.isEmpty){return true;}
    else{return false;}
  }
  static Future<bool> _findCharacteristics(String serviceName, BluetoothService service) async {
    Map<Guid,String> charUUIDs = UUIDs.getCharUuids(serviceName);
    for (BluetoothCharacteristic char in service.characteristics){
      String? charName = charUUIDs.remove(char.uuid);
      if (charName != null){
        _btObjects.addCharacteristic(serviceName, charName, char);
        //char.setNotifyValue(true);
      }
    }
    if(charUUIDs.isEmpty){return true;}
    else{return false;}
  }


}
