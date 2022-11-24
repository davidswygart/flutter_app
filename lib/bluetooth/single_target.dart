import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/bluetooth/device.dart';
import 'package:flutter_app/bluetooth/service.dart';
import 'characteristics/hit_sensor.dart';
import 'characteristics/led.dart';

class SingleTarget {
  Device device = Device();
  Service service = Service();
  LedCharacteristic led = LedCharacteristic();
  HitSensorCharacteristic hitSensor = HitSensorCharacteristic();

  Future<void> init () async {
    await device.init();
    await service.init(device);
    led.init(service);
    await hitSensor.init(service);
    debugPrint("single_target: all characteristics found");
  }
}