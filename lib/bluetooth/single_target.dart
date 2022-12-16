import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/bluetooth/service.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'characteristics/hit_sensor.dart';
import 'characteristics/led.dart';


class SingleTarget{
  final BluetoothDevice device;
  SingleTarget(this.device);

  Service service = Service();
  LedCharacteristic led = LedCharacteristic();
  HitSensorCharacteristic hitSensor = HitSensorCharacteristic();

  Future<void> init () async {
    await _connect();
    await service.init(device);
    led.init(service);
    await hitSensor.init(service);
    debugPrint("single_target: all characteristics found");
  }

  Future<void> _connect() async {
    debugPrint("single_target: 5 Attempting connection");
    await device.connect(timeout: const Duration(seconds: 2));
    if (await device.state.first == BluetoothDeviceState.connected) {
      debugPrint("device: connection successful");
    }
    else {
      throw Exception("unable to connect");
    }
  }
}