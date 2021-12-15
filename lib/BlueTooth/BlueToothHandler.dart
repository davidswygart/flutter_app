import 'dart:async';
import 'dart:typed_data';

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
  BlueToothHandler._internal() {
    debugPrint("Created instance of the bluetooth handler");
  }
  BluetoothCharacteristic? get ledCharacteristic => _ledCharacteristic;
  BluetoothCharacteristic? get hitCharacteristic => _hitCharacteristic;
  Stream<blueStates> get stateStream => _stateBroadcaster.stream;
  blueStates get lastState => _lastState;

  //List<String> _deviceNames = ['HTT_001', 'HTT_002'];
  String _deviceName = 'HTT_001';

  Guid _serviceUUID = Guid('00000000-151b-11ec-82a8-0242ac130003');
  Guid _ledUUID = Guid('00000001-151b-11ec-82a8-0242ac130003');
  Guid _hitUUID = Guid('00000002-151b-11ec-82a8-0242ac130003');
  Guid _batteryUUID = Guid('00000003-151b-11ec-82a8-0242ac130003');

  StreamController<blueStates> _stateBroadcaster =
      StreamController<blueStates>.broadcast();
  blueStates _lastState =
      blueStates.error; //Should be overwritten when we first assess the state

  BluetoothDevice? _btDev;
  BluetoothCharacteristic? _ledCharacteristic;
  BluetoothCharacteristic? _hitCharacteristic;
  BluetoothCharacteristic? _batteryCharacteristic;

  bool _runningLoop = false;

  int _batteryLevel = 0;
  int get batteryLevel => _batteryLevel;

  Future<int> _readBattery() async {
    List<int> batteryBytes = await _batteryCharacteristic!.read();
    _batteryLevel = ByteData.sublistView(Uint8List.fromList(batteryBytes))
        .getUint32(0, Endian.little);
    return _batteryLevel;
  }

  stopStateHandler() {
    _runningLoop = false;
  }

  Future<bool> startStateHandler() async {
    debugPrint('State handler started_________________');
    if (_runningLoop) {
      debugPrint(
          'State handler already running loop. I will not start another one_________________');
      return false;
    } else {
      _runningLoop = true;
    }
    while (_runningLoop) {
      try {
        debugPrint('State handler top of loop_________________');
        if (await isConnected(_btDev)) {
          if (_btDev != null) {
            await _readBattery();
          }
          debugPrint(
              'State handler determined we were connected_________________');
          await _readBattery();
          _updateState(blueStates.connected);
          //TODO: allow for connection to multiple devices. Need to check connection status for each.  Setup device names on first app run or in settings.
          //TODO: set checks for bluetooth turned off
        } else {
          debugPrint(
              'State handler determined we need to connect_________________');
          _updateState(blueStates.connecting);
          Future<bool> connectFuture = _attemptConnect();
          Future<bool> futureTimeout =
              connectFuture.timeout(Duration(seconds: 10));
          bool connectSuccess = await futureTimeout;
          if (connectSuccess) {
            //Try to connect from the beginning.
            _updateState(blueStates.connected);
            debugPrint(
                'State handler was successful in connecting_________________');
          } else {
            //broadcast that we are disconnected
            debugPrint(
                'State handler tried and failed at connecting_________________');
            _updateState(blueStates.notConnected);
          }
        }
        debugPrint('State handler is taking a 1s rest break_________________');
        await Future.delayed(Duration(seconds: 1));
      } catch (error) {
        debugPrint('An error ocured while trying to connect________________');
        await Future.delayed(Duration(seconds: 1));
        _updateState(blueStates.notConnected);
        continue;
      }
    }
    debugPrint('State handler has exited the loop_________________');
    return true;
  }
  Future<int> listenForHit({timeout = 6000000}) async {
    //returns -11 if Bluetooth not set, returns -1 if timeout reached
    if (_hitCharacteristic == null) {
      return -11;
    }
    else {
      Future<List<int>> hitFuture = _hitCharacteristic!.value.firstWhere((
          val) => val.isNotEmpty);

      List<int> hitBytes =
      await hitFuture.timeout(Duration(milliseconds: timeout), onTimeout: () {
        return [-1];
      });
      if (hitBytes.first < 0) {
        return -1;
      } else {
        return ByteData.sublistView(Uint8List.fromList(hitBytes))
            .getUint32(0, Endian.little);
      }
    }
  }

  Future<bool> isConnected(BluetoothDevice? dev) async {
    //Check that this device is listed as a connected device
    if (dev == null) {
      dev = _btDev;
      if (dev == null) {
        return false;
      }
    }

    List<BluetoothDevice> devList = await FlutterBlue.instance.connectedDevices;
    for (BluetoothDevice devFromList in devList) {
      if (devFromList.id == dev.id) {
        debugPrint("Device was found in list of connected devices");
        return true;
      }
    }
    return false;
  }

  void _updateState(blueStates b) {
    _lastState = b;
    _stateBroadcaster.add(b);
  }

  Future<bool> _attemptConnect() async {
    FlutterBlue fb = FlutterBlue.instance;
    debugPrint("BluetoothHandler: 1 Attempting connection");
    // Find device //
    BluetoothDevice? device;
    if (await fb.isScanning.first) {
      debugPrint("BluetoothHandler: 2 Already scanning");
      return false;
    }

    debugPrint("BluetoothHandler: 2 starting scan");
    Stream<ScanResult> scanStream = fb.scan(timeout: Duration(seconds: 2));
    await for (ScanResult r in scanStream) {
      if (r.device.name == _deviceName) {
        await fb.stopScan();
        device = r.device;
      }
    }

    if (device == null) {
      debugPrint("BluetoothHandler: 4 Device not found in scan results");
      return false;
    }

    // Connect to device //
    debugPrint("BluetoothHandler: 5 Attempting connection");
    await device.connect(timeout: Duration(seconds: 2));
    if (!await isConnected(device)) {
      debugPrint("BluetoothHandler: 6 connection was unsuccessful");
      return false;
    }

    // find services //
    BluetoothService? service;
    debugPrint("BluetoothHandler: 7 discovering services");
    List<BluetoothService> serviceList = await device.discoverServices();
    for (BluetoothService s in serviceList) {
      if (s.uuid == _serviceUUID) {
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
      if (c.uuid == _ledUUID) {
        ledC = c;
      } else if (c.uuid == _hitUUID) {
        hitC = c;
      } else if (c.uuid == _batteryUUID) {
        batteryC = c;
      }
    }

    if ((ledC == null) || (hitC == null) || (batteryC == null)) {
      debugPrint("BluetoothHandler: 10 characteristic was not found");
      return false;
    } else {
      await hitC.setNotifyValue(true);
      debugPrint("BluetoothHandler: 10 characteristic was found");
      // Set discovered devices, services, and characteristics as public
      _btDev = device;
      _ledCharacteristic = ledC;
      _hitCharacteristic = hitC;
      _batteryCharacteristic = batteryC;
      return true;
    }
  }
}
