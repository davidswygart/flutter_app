
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

class BlueStateAssembler {
  static bool _supported = true;
  static bool _unauthorized = false;
  static bool _turnedON = true;
  static bool _scanning = false;
  static bool _connecting = false;
  static bool _connected = false;

  static StreamController<blueStates> _stateBroadcaster = StreamController<blueStates>.broadcast();
  static blueStates currentState = blueStates.error; //Should be overwritten when we first assess the state

  static StreamSubscription<BluetoothState>? _adapterSubscription;
  static StreamSubscription<bool>? _scannerSubscription;
  static StreamSubscription<BluetoothDeviceState>? _deviceSubscription;

  static Future<void> startAdapterStateHandler() async {
    await _adapterSubscription?.cancel();//Cancel previous versions of the subscription
    _adapterSubscription = FlutterBlue.instance.state.listen((BluetoothState adapterState) {
        debugPrint('Adapter State: ' + adapterState.toString());
        switch (adapterState) {
          case BluetoothState.unknown:
          case BluetoothState.unavailable:
            {
              _supported = false;
              break;
            }
          case BluetoothState.unauthorized:
            {
              _unauthorized = true;
              break;
            }
          case BluetoothState.turningOn:
          case BluetoothState.on:
            {
              _supported = true;
              _unauthorized = false;
              _turnedON = true;
              break;
            }
          case BluetoothState.turningOff:
          case BluetoothState.off:
            {
              _turnedON = false;
              break;
            }
        }
        _assessState();
      });
    await _scannerSubscription?.cancel();//Cancel previous versions of the subscription
    _scannerSubscription = FlutterBlue.instance.isScanning.listen((bool s) {
        debugPrint('Is Scanning: ' + s.toString());
        _scanning = s;
        _assessState();
      });
  }
  static Future<void> startDeviceStateHandler(BluetoothDevice device) async {
    await _deviceSubscription?.cancel(); //Cancel previous versions of the subscription
    _deviceSubscription = device.state.listen((BluetoothDeviceState deviceState){
      debugPrint('Device State: ' + deviceState.toString());
      switch(deviceState){
        case BluetoothDeviceState.disconnected:
        case BluetoothDeviceState.disconnecting:
          {
            _connected = false;
            break;
          }
        case BluetoothDeviceState.connecting:
          {
            _connecting = true;
            break;
          }
        case BluetoothDeviceState.connected:
          {
            _connected = true;
            break;
          }
      }
      _assessState();
    });
  }
  static Stream<blueStates> getStateStream() {return _stateBroadcaster.stream;}
  static void _assessState(){
    blueStates newState;
    if (!_supported){newState = blueStates.notSupported;}
    else if (_unauthorized){newState = blueStates.unauthorized;}
    else if (!_turnedON){newState = blueStates.turnedOff;}
    else if (_turnedON && !_scanning && !_connecting && !_connected){newState = blueStates.notConnected;}
    else if (_scanning && !_connected){newState = blueStates.scanning;}
    else if (_connecting){newState = blueStates.connecting;}
    else if (_connected){newState = blueStates.connected;}
    else {newState = blueStates.error;}

    if (newState != currentState){
      currentState = newState;
      _stateBroadcaster.add(newState);
    }
  }
}

