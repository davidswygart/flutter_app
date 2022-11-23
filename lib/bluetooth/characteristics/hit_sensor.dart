import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_app/bluetooth/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class HitResults {

  int reactionTime;
  int targetNum;
  HitResults({required this.targetNum, required this.reactionTime});

  int getTargetNum() => targetNum;
  int getReactionTime() => reactionTime;
}

class HitSensorCharacteristic {
  final Guid _uuid = Guid('00000002-151b-11ec-82a8-0242ac130003');
  BluetoothCharacteristic? _fbChar;

  Future<void> init(Service s) async {
    debugPrint("hit_sensor: Looking for characteristic");

    List<BluetoothCharacteristic> charList = s.fbService.characteristics;

    bool charFound = false;
    for (BluetoothCharacteristic s in charList) {
      if (s.uuid == _uuid) {
        _fbChar = s;
        charFound = true;
        debugPrint("hit_sensor: Found characteristic");
      }
    }

    if (!charFound) {
      debugPrint("hit_sensor: characteristic not found");
      throw Exception("hit_sensor: characteristic not found");
    }

    await _fbChar?.setNotifyValue(true); // Definitely needs to be set if you want to receive values

  }

  Future<HitResults> getHit(int tNum) async {
    debugPrint("hit_sensor: waiting for hit value");
    List<int> byteList = await _fbChar!.value.firstWhere((b) => b.isNotEmpty);
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(byteList));
    int rTime = byteData.getUint32(0, Endian.little);

    return HitResults(targetNum: tNum, reactionTime: rTime);
  }
}