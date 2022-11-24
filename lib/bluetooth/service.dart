import 'package:flutter_app/bluetooth/device.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';

class Service {
  final Guid _serviceUUID = Guid('00000000-151b-11ec-82a8-0242ac130003');
  late final BluetoothService fbService;

  Future<void> init(Device device) async {
    debugPrint("Service: 7 discovering services");

    List<BluetoothService> sList = await device.fbDevice.discoverServices();

    bool serviceFound = false;
    for (BluetoothService s in sList) {
      if (s.uuid == _serviceUUID) {
        fbService = s;
        serviceFound = true;
      }
    }

    if (!serviceFound) {
      debugPrint("BluetoothHandler: 8 service not found");
      throw Exception("could not find the BLE server");
    }
  }
}