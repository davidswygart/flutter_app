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
  late Stream<List<int>> hitStream;
  late QualifiedCharacteristic hitThreshold;
  late QualifiedCharacteristic hitTimeout;
  late QualifiedCharacteristic hitAcceleration;

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

    StreamController<List<int>> sc = StreamController.broadcast();
    sc.addStream(FlutterReactiveBle().subscribeToCharacteristic(hitSensor));
    hitStream = sc.stream;

    hitThreshold = QualifiedCharacteristic(
        serviceId: ID().service,
        characteristicId: ID().hitThreshold,
        deviceId: device.id
    );

    hitTimeout = QualifiedCharacteristic(
        serviceId: ID().service,
        characteristicId: ID().hitTimeout,
        deviceId: device.id
    );

    hitAcceleration = QualifiedCharacteristic(
        serviceId: ID().service,
        characteristicId: ID().hitAcceleration,
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

  Future<void> disconnect() async {
    debugPrint("single_target: Attempting disconnect");
    try{await stateStream.cancel();}
    catch(error){debugPrint("couldn't disconnect from device. Probably not initialized");}
  }


  Future<bool> writeLED(List<int> intList) async {
    //debugPrint("led: writing to LEDs: $intList");
    if (intList.length != 3){
      throw Exception("Wrong list length for writing to LEDs (should be 3, RGB)");
    }
    await FlutterReactiveBle().writeCharacteristicWithoutResponse(
        led, value: intList
    );
    return true;
  }



  Future<HitResults> getHit(int tNum) async {
    //debugPrint("hit_sensor: waiting for hit value");

    List<int> byteList = await hitStream.firstWhere((b) => b.isNotEmpty);
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(byteList));
    int rTime = byteData.getUint32(0, Endian.little);
    return HitResults(targetNum: tNum, reactionTime: rTime);
  }

  Future<void> setHitThreshold(double thresh) async {
    int threshInt = (32767 * thresh / 16).round(); //convert from Gs to 16-bit int with 16g range
    List<int> intList = Uint8List(2)..buffer.asByteData().setInt16(0, threshInt, Endian.little); //convert to list of bytes

    await FlutterReactiveBle().writeCharacteristicWithoutResponse(
        hitThreshold, value: intList
    );
  }
  Future<double> readHitThreshold() async {
    List<int> byteList = await FlutterReactiveBle().readCharacteristic(hitThreshold);
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(byteList));
    int thresh16 = byteData.getInt16(0, Endian.little);
    double thresh  =  16 * thresh16 / 32767; // convert 16-bit value for 16g range
    return thresh;
  }


  Future<double> readHitAcceleration() async {
    List<int> byteList = await FlutterReactiveBle().readCharacteristic(hitAcceleration);
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(byteList));
    int accel16 = byteData.getInt16(0, Endian.little);
    double acceleration  =  16 * accel16 / 32767; // convert 16-bit value for 16g range
    return acceleration;
  }

  Future<void> setHitRefractoryPeriod(double buffer) async {
    List<int> bufferInt = [buffer~/10]; //Divide by 10 to fit in an 8-bit value. Expand back to original value in ESP32.
    await FlutterReactiveBle().writeCharacteristicWithoutResponse(
        hitTimeout, value: bufferInt
    );
  }

  Future<int> readHitRefractoryPeriod() async{
    List<int> intList = await FlutterReactiveBle().readCharacteristic(hitTimeout);
    int refractory = intList[0]*10;
    return refractory;
  }
}

class HitResults {
  int reactionTime;
  int targetNum;
  HitResults({required this.targetNum, required this.reactionTime});
  int getTargetNum() => targetNum;
  int getReactionTime() => reactionTime;
}


