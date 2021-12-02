import 'package:flutter_blue/flutter_blue.dart';

class BlueToothObjects{
  BluetoothDevice? device;
  final Map<String,ServiceObject> _services = {};
  void addService(String name, BluetoothService service){
    _services[name] = ServiceObject(service: service);
  }
  BluetoothService? getService(String name){
    return _services[name]?.service;
  }
  bool addCharacteristic(String serviceName, String charName, BluetoothCharacteristic btChar){

    ServiceObject? servObj = _services[serviceName];
    if(servObj != null){
      servObj.characteristics[charName] = btChar;
      return true;
    }
    else {return false;}//could not find the service by name
  }
  BluetoothCharacteristic? getChar(String serviceName, String charName){
    return _services[serviceName]?.characteristics[charName];
  }
}
class ServiceObject{
  BluetoothService service;
  ServiceObject({required this.service});
  final Map<String,BluetoothCharacteristic> characteristics = {};
}
