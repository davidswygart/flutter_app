import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';


import 'characteristics/hit_sensor.dart';
import 'characteristics/led.dart';


class SingleTarget{
  final Uuid _serviceId = Uuid.parse('00000000-151b-11ec-82a8-0242ac130003');
  final Uuid _hitId = Uuid.parse('00000000-151b-11ec-82a8-0242ac130003');
  final Uuid _ledId = Uuid.parse('00000000-151b-11ec-82a8-0242ac130003');

  final DiscoveredDevice device;
  SingleTarget(this.device);
  late StreamSubscription<ConnectionStateUpdate> stateStream;

  LedCharacteristic led = LedCharacteristic();
  HitSensorCharacteristic hitSensor = HitSensorCharacteristic();

  Future<void> init () async {
    await _connect();

    final hitCharacteristic = QualifiedCharacteristic(
        serviceId: _serviceId,
        characteristicId: _ledId,
        deviceId: device.id
    );

    final ledCharacteristic = QualifiedCharacteristic(
        serviceId: _serviceId,
        characteristicId: _hitId,
        deviceId: device.id
    );

/*    led.init(ledCharacteristic);
    await hitSensor.init(hitCharacteristic);*/

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
}


