import 'package:flutter/material.dart';


class LedCharacteristic {

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