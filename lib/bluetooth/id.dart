import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class ID {
  final Uuid advertising = Uuid.parse('aaaaaaaa-151b-11ec-82a8-0242ac130003');
  final Uuid service = Uuid.parse('00000000-151b-11ec-82a8-0242ac130003');
  final Uuid hit = Uuid.parse('00000002-151b-11ec-82a8-0242ac130003');
  final Uuid led = Uuid.parse('00000001-151b-11ec-82a8-0242ac130003');
  final Uuid hitThreshold = Uuid.parse('00000004-151b-11ec-82a8-0242ac130003');
  final Uuid hitTimeout = Uuid.parse('00000005-151b-11ec-82a8-0242ac130003');
  final Uuid hitAcceleration = Uuid.parse('00000006-151b-11ec-82a8-0242ac130003');
}