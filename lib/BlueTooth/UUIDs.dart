import 'package:flutter_blue/flutter_blue.dart';

class UUIDs {
  static String deviceName = 'HTT_001';
  static Map<String,ServUUIDs> _services = {
    'Play': ServUUIDs(
        uuidString: '00000000-151b-11ec-82a8-0242ac130003',
        charUUIDs: {
          'paddleColor':'00000001-151b-11ec-82a8-0242ac130003',
          'hitPaddle' : "00000002-151b-11ec-82a8-0242ac130003",
        }),
  };

  static Map<Guid,String> getServiceUuids(){
    Map<Guid,String> uuidMap = {};
    _services.forEach((name, servUUIDs) {uuidMap[Guid(servUUIDs.uuidString)] = name;});
    return uuidMap;
  }

  static Map<Guid,String> getCharUuids(String serviceName){
    Map<String,String>? charMap =  _services[serviceName]?.charUUIDs;
    Map<Guid,String> uuidMap = {};
    charMap?.forEach((name, uuidString) {uuidMap[Guid(uuidString)] = name;});
    return uuidMap;
  }
}

class ServUUIDs{
  String uuidString;
  Map<String, String> charUUIDs;
  ServUUIDs({required this.uuidString, required this.charUUIDs});
}