import 'package:flutter_app/bluetooth/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class LedCharacteristic {
  final Guid _ledUUID = Guid('00000001-151b-11ec-82a8-0242ac130003');
  BluetoothCharacteristic? _fbChar;

  void init(Service s) {
    debugPrint("led: Looking for characteristics");

    List<BluetoothCharacteristic> charList = s.fbService.characteristics;

    bool charFound = false;
    for (BluetoothCharacteristic s in charList) {
      if (s.uuid == _ledUUID) {
        _fbChar = s;
        charFound = true;
      }
    }

    if (!charFound) {
      debugPrint("led: LED characteristic not found");
      throw Exception("could not find LED characteristic");
    }
  }

  writeLED(List<int> intList) async {
    debugPrint("led: writing to LEDs: $intList");
    if (intList.length != 4){
      throw Exception("Wrong list length for writing to LEDs (should be 4, RGBW)");
    }
    await _fbChar?.write(intList);
  }

}