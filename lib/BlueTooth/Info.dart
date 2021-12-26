
import 'package:flutter_blue/flutter_blue.dart';

class Info { // TODO: this is temp class for holding bluetooth info.  Replace with something smarter.
  //List<String> _deviceNames = ['HTT_001', 'HTT_002'];
  String deviceName = 'HTT_001';
  Guid serviceUUID = Guid('00000000-151b-11ec-82a8-0242ac130003');
  Guid ledUUID = Guid('00000001-151b-11ec-82a8-0242ac130003');
  Guid hitUUID = Guid('00000002-151b-11ec-82a8-0242ac130003');
  Guid batteryUUID = Guid('00000003-151b-11ec-82a8-0242ac130003');
}