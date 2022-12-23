import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'id.dart';


class SingleTarget{

  final DiscoveredDevice device;
  SingleTarget(this.device);

  late StreamSubscription<ConnectionStateUpdate> stateStream;
  late QualifiedCharacteristic led;
  late QualifiedCharacteristic hitSensor;

  Future<void> init () async { // init needs to be its own function because constructor cannot be async
    await _connect();

    led = QualifiedCharacteristic(
          serviceId: ID().service,
          characteristicId: ID().led,
          deviceId: device.id
    );

    hitSensor = QualifiedCharacteristic(
        serviceId: ID().service,
        characteristicId: ID().hit,
        deviceId: device.id
    );
  }

  Future<void> _connect() async {
    debugPrint("single_target: Attempting connection");

    stateStream = FlutterReactiveBle().connectToAdvertisingDevice(
      id: device.id,
      withServices: [],
      prescanDuration: const Duration(seconds: 3),
      connectionTimeout: const Duration(seconds:  2),
    ).listen((connectionState) {
      debugPrint("Connection state update: $connectionState");
    }, onError: (dynamic error) {
      throw Exception("unable to connect");
    });
  }

  Future<bool> writeLED(List<int> intList) async {
    //debugPrint("led: writing to LEDs: $intList");
    if (intList.length != 3){
      throw Exception("Wrong list length for writing to LEDs (should be 3, RGB)");
    }
    led = QualifiedCharacteristic(
        serviceId: ID().service,
        characteristicId: ID().led,
        deviceId: device.id
    );
    await FlutterReactiveBle().writeCharacteristicWithoutResponse(
        led, value: intList
    );
    return true;
  }

  Future<HitResults> getHit(int tNum) async {
    //debugPrint("hit_sensor: waiting for hit value");
    Stream<List<int>> hitStream =  FlutterReactiveBle().subscribeToCharacteristic(hitSensor);
    List<int> byteList = await hitStream.firstWhere((b) => b.isNotEmpty);
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(byteList));
    int rTime = byteData.getUint32(0, Endian.little);
    return HitResults(targetNum: tNum, reactionTime: rTime);
  }
}

class HitResults {

  int reactionTime;
  int targetNum;
  HitResults({required this.targetNum, required this.reactionTime});

  int getTargetNum() => targetNum;
  int getReactionTime() => reactionTime;
}


