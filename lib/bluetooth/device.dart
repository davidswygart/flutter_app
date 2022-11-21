import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Device {
  final String _deviceName = "HTT_";
  late final BluetoothDevice fbDevice;

  Future<void> init() async {
/*    bool isConnected = await _checkConnected();
    if (isConnected) {
      debugPrint("device: 2 Already connected no need to scan");
      return;
    } else {*/
      await _scan();
      await _connect();
    //}
  }
/*
  Future<bool> _checkConnected() async {
    FlutterBlue fb = FlutterBlue.instance;

    List<BluetoothDevice> devList = await fb.connectedDevices;
    for (BluetoothDevice d in devList) {
      debugPrint(d.name == _deviceName);
      if (d.name.startsWith(_deviceName)) {
        fbDevice = d;
        return true;
      }
    }
    return false;
  }*/

  Future<BluetoothDevice> _scan() async {
    FlutterBlue fb = FlutterBlue.instance;
    if (await fb.isScanning.first) {
      debugPrint("device: 2 Already scanning");
      throw Exception("Bluetooth is already scanning");
    }

    debugPrint("device: 2 starting scan, looking for $_deviceName");
    Stream<ScanResult> scanStream =
        fb.scan(timeout: const Duration(seconds: 2));
    await for (ScanResult r in scanStream) {
      debugPrint("device: device found; name = ${r.device.name}");
      if (r.device.name.startsWith(_deviceName)) {
        await fb.stopScan();
        fbDevice = r.device;
        return fbDevice;
      }
    }

    debugPrint("device: 4 Device not found in scan results");
    throw TimeoutException("Device not found in scan results");
  }

  Future<void> _connect() async {
    debugPrint("device: 5 Attempting connection");
    await fbDevice.connect(timeout: const Duration(seconds: 2));
    if (await fbDevice.state.first == BluetoothDeviceState.connected) {
      debugPrint("device: connection successful");
    }
    else {
      throw Exception("unable to connect");
    }
  }
}
